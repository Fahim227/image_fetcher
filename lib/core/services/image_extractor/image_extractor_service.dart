abstract class IImageExtractorService {
  Future<List<String>> getImages();

  Future<String> saveAllImages(List<String> images);
}
