import '../repositories/api_repository_interface.dart';

class GetHomeDataUseCase {
  final ApiRepositoryInterface _apiRepository;

  GetHomeDataUseCase(this._apiRepository);

  /// Executes the use case to fetch both images and weather data concurrently
  Future<Map<String, dynamic>> execute() async {
    try {
      return await _apiRepository.fetchDataConcurrently();
    } catch (e) {
      throw Exception('Failed to get home data: $e');
    }
  }
}
