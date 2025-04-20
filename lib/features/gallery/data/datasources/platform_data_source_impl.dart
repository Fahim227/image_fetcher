import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

import 'platform_data_source.dart';

@Injectable(as: PlatformDataSource)
class PlatformDataSourceImpl implements PlatformDataSource {
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
  Future<String> saveAllImages(List<Uint8List> images) async {
    for (final byte in images) {
      final fileName = "img_${DateTime.now().millisecondsSinceEpoch}.jpg";
      final result = await _channel.invokeMethod(saveImagesChannelName, {
        "bytes": byte,
        "fileName": fileName,
        "folderName": "MyCustomGallery"
      });
    }

    return "Done";
  }
}
