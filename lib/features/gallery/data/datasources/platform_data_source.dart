import 'dart:typed_data';

abstract class PlatformDataSource {
  Future<List<String>> getImages();

  Future<String> saveAllImages(List<Uint8List> images);
}
