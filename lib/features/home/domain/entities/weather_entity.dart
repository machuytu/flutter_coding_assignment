class WeatherEntity {
  final String city;
  final double temperature;
  final String description;
  final int humidity;
  final double windSpeed;

  const WeatherEntity({
    required this.city,
    required this.temperature,
    required this.description,
    required this.humidity,
    required this.windSpeed,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WeatherEntity &&
        other.city == city &&
        other.temperature == temperature &&
        other.description == description &&
        other.humidity == humidity &&
        other.windSpeed == windSpeed;
  }

  @override
  int get hashCode {
    return city.hashCode ^
        temperature.hashCode ^
        description.hashCode ^
        humidity.hashCode ^
        windSpeed.hashCode;
  }

  @override
  String toString() {
    return 'WeatherEntity(city: $city, temperature: $temperature, description: $description, humidity: $humidity, windSpeed: $windSpeed)';
  }
}
