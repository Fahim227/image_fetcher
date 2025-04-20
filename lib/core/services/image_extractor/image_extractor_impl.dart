import 'dart:io';

import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

import 'image_extractor_service.dart';

@Singleton(as: IImageExtractorService)
class ImageExtractorServiceImpl implements IImageExtractorService {
  static const MethodChannel _channel = MethodChannel('image_extractor');

  static String get getImagesChannelName => "getImages";
  static String get saveImagesChannelName => "saveImages";

  @override
  Future<List<String>> getImages() async {
    final List<dynamic> imagePaths =
        await _channel.invokeMethod(getImagesChannelName);
    return imagePaths.cast<String>();
  }

  @override
  Future<String> saveAllImages(List<String> images) async {
    List<Uint8List> imagesInBytes = await getImagesInBytes(images);
    for (final byte in imagesInBytes) {
      final fileName = "img_${DateTime.now().millisecondsSinceEpoch}.jpg";
      final result = await _channel.invokeMethod(saveImagesChannelName, {
        "bytes": byte,
        "fileName": fileName,
        "folderName": "MyCustomGallery"
      });
    }

    return "Done";
  }

  Future<List<Uint8List>> getImagesInBytes(List<String> images) async {
    return await Future.wait(images.map((e) => File(e).readAsBytes()));
  }
}
