package com.image.fetcher.image_fetcher;

import io.flutter.embedding.android.FlutterActivity;

import android.content.ContentValues;
import android.database.Cursor;
import android.net.Uri;
import android.provider.MediaStore;

import androidx.annotation.NonNull;

import java.io.IOException;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.List;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.Result;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "image_extractor";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall call, Result result) {
                        if (call.method.equals("getImages")) {
                            List<String> images = getAllImages();
                            result.success(images);
                        }
                        if (call.method.equals("saveImages")) {
                            byte[] bytes = call.argument("bytes");
                            String fileName = call.argument("fileName");
                            String folderName = call.argument("folderName");
                            saveImageToGallery(bytes, fileName, folderName, result);
                        } else {
                            result.notImplemented();
                        }
                    }
                });
    }

    private List<String> getAllImages() {
        List<String> imageList = new ArrayList<>();
        String[] projection = {MediaStore.Images.Media.DATA};

        String selection = MediaStore.Images.Media.MIME_TYPE + " LIKE ?";
        String[] selectionArgs = new String[] {"image/%"};

        Cursor cursor = getContentResolver().query(
                MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
                projection,
                selection,
                selectionArgs,
                null
        );

        if (cursor != null) {
            int columnIndex = cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA);
            while (cursor.moveToNext()) {
                String imagePath = cursor.getString(columnIndex);
                if(isFromGalleryFolder(imagePath)){
                    imageList.add(imagePath);
                }
            }
            cursor.close();
        }
        return imageList;
    }

    private boolean isFromGalleryFolder(String path) {
        path = path.toLowerCase();

        return path.contains("/dcim/") ||
                path.contains("/camera/") ||
                path.contains("/pictures/") ||
                path.contains("/download/") ||
                path.contains("/images/");
    }

    private void saveImageToGallery(byte[] imageBytes, String fileName, String folderName, Result result) {
        ContentValues values = new ContentValues();
        values.put(MediaStore.Images.Media.DISPLAY_NAME, fileName);
        values.put(MediaStore.Images.Media.MIME_TYPE, "image/jpeg");

        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.Q) {
            values.put(MediaStore.Images.Media.RELATIVE_PATH, "Pictures/" + folderName); // custom gallery folder
            values.put(MediaStore.Images.Media.IS_PENDING, 1);
        }

        Uri uri = getContentResolver().insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, values);
        if (uri == null) {
            result.error("SAVE_FAILED", "Unable to create MediaStore entry", null);
            return;
        }

        try {
            OutputStream out = getContentResolver().openOutputStream(uri);
            if (out != null) {
                out.write(imageBytes);
                out.close();
            }

            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.Q) {
                values.clear();
                values.put(MediaStore.Images.Media.IS_PENDING, 0);
                getContentResolver().update(uri, values, null, null);
            }

            result.success("saved");
        } catch (IOException e) {
            result.error("SAVE_FAILED", "IOException: " + e.getMessage(), null);
        }
    }

}
