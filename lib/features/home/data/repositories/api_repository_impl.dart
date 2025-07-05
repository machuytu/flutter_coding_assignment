import 'package:dio/dio.dart';
import '../../domain/repositories/api_repository_interface.dart';
import '../../domain/entities/image_entity.dart';
import '../../domain/entities/weather_entity.dart';
import '../models/image_model.dart';
import '../models/weather_model.dart';

class ApiRepositoryImpl implements ApiRepositoryInterface {
  final Dio _dio = Dio();

  static const String _imageApiUrl =
      'https://mocki.io/v1/a5d4cf16-1f36-4f2b-b5cd-89772a83e999';
  static const String _weatherApiUrl =
      'https://mocki.io/v1/b9607fd2-bd7a-484e-917f-a5e641ec6cc9';

  @override
  Future<List<ImageEntity>> fetchImages() async {
    try {
      final response = await _dio.get(_imageApiUrl);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.asMap().entries.map((entry) {
          final index = entry.key;
          final url = entry.value as String;
          final imageModel = ImageModel.fromUrl(url, index: index + 1);
          return _mapImageToEntity(imageModel);
        }).toList();
      } else {
        throw Exception('Failed to load images');
      }
    } catch (e) {
      throw Exception('Failed to load images: $e');
    }
  }

  @override
  Future<WeatherEntity> fetchWeather() async {
    try {
      final response = await _dio.get(_weatherApiUrl);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;

        // Find Ho Chi Minh City weather data
        final hoChiMinhData = data.firstWhere(
          (item) => item['location'] == 'Ho Chi Minh',
          orElse:
              () =>
                  data.first, // Fallback to first item if Ho Chi Minh not found
        );

        final weatherModel = WeatherModel.fromApiResponse(hoChiMinhData);
        return _mapWeatherToEntity(weatherModel);
      } else {
        throw Exception('Failed to load weather');
      }
    } catch (e) {
      throw Exception('Failed to load weather: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> fetchDataConcurrently() async {
    try {
      final results = await Future.wait([fetchImages(), fetchWeather()]);

      return {
        'images': results[0] as List<ImageEntity>,
        'weather': results[1] as WeatherEntity,
      };
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }

  // Mapper methods to convert data models to domain entities
  ImageEntity _mapImageToEntity(ImageModel model) {
    return ImageEntity(
      id: model.id,
      url: model.url,
      title: model.title,
      description: model.description,
    );
  }

  WeatherEntity _mapWeatherToEntity(WeatherModel model) {
    return WeatherEntity(
      city: model.city,
      temperature: model.temperature,
      description: model.description,
      humidity: model.humidity,
      windSpeed: model.windSpeed,
    );
  }
}
