import '../entities/image_entity.dart';
import '../entities/weather_entity.dart';

abstract class ApiRepositoryInterface {
  /// Fetches a list of images from the API
  Future<List<ImageEntity>> fetchImages();

  /// Fetches weather information for Ho Chi Minh City
  Future<WeatherEntity> fetchWeather();

  /// Fetches both images and weather data concurrently
  Future<Map<String, dynamic>> fetchDataConcurrently();
}
