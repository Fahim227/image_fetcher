import 'package:flutter/services.dart';

class ImageExtractor {
  static const MethodChannel _channel = MethodChannel('image_extractor');

  static Future<List<String>> getImages() async {
    final List<dynamic> imagePaths = await _channel.invokeMethod('getImages');
    return imagePaths.cast<String>();
  }
}
