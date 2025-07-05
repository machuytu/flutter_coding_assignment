import '../entities/weather_entity.dart';
import '../repositories/api_repository_interface.dart';

class GetWeatherUseCase {
  final ApiRepositoryInterface _apiRepository;

  GetWeatherUseCase(this._apiRepository);

  /// Executes the use case to fetch weather information
  Future<WeatherEntity> execute() async {
    try {
      return await _apiRepository.fetchWeather();
    } catch (e) {
      throw Exception('Failed to get weather: $e');
    }
  }
}
