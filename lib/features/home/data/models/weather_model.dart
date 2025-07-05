class WeatherModel {
  final String city;
  final double temperature;
  final String description;
  final int humidity;
  final double windSpeed;

  WeatherModel({
    required this.city,
    required this.temperature,
    this.description = 'Partly cloudy',
    this.humidity = 70,
    this.windSpeed = 5.0,
  });

  // Factory constructor for API response (location and temperature only)
  factory WeatherModel.fromApiResponse(Map<String, dynamic> json) {
    return WeatherModel(
      city: json['location'] ?? '',
      temperature: (json['temperature'] ?? 0.0).toDouble(),
      description: 'Partly cloudy',
      humidity: 70,
      windSpeed: 5.0,
    );
  }

  // Factory constructor for full JSON object (if API changes in future)
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      city: json['city'] ?? '',
      temperature: (json['temperature'] ?? 0.0).toDouble(),
      description: json['description'] ?? '',
      humidity: json['humidity'] ?? 0,
      windSpeed: (json['windSpeed'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'temperature': temperature,
      'description': description,
      'humidity': humidity,
      'windSpeed': windSpeed,
    };
  }
}
