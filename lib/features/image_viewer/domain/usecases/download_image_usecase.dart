import '../repositories/image_repository_interface.dart';

class DownloadImageUseCase {
  final ImageRepositoryInterface _imageRepository;

  DownloadImageUseCase(this._imageRepository);

  /// Executes the use case to download and resize an image
  Future<String> execute(String imageUrl) async {
    try {
      return await _imageRepository.downloadAndResizeImage(imageUrl);
    } catch (e) {
      throw Exception('Failed to download image: $e');
    }
  }
}
