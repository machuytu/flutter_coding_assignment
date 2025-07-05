import '../entities/image_entity.dart';
import '../repositories/api_repository_interface.dart';

class GetImagesUseCase {
  final ApiRepositoryInterface _apiRepository;

  GetImagesUseCase(this._apiRepository);

  /// Executes the use case to fetch images
  Future<List<ImageEntity>> execute() async {
    try {
      return await _apiRepository.fetchImages();
    } catch (e) {
      throw Exception('Failed to get images: $e');
    }
  }
}
