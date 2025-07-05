abstract class ImageRepositoryInterface {
  /// Downloads and resizes an image to half dimensions
  /// Returns the file path where the resized image is saved
  Future<String> downloadAndResizeImage(String imageUrl);
}
