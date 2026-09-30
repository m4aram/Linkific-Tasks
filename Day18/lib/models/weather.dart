/// Model for the Open-Meteo API (https://open-meteo.com), no API key needed.
class Weather {
  final double temperature;
  final double windSpeed;
  final int code;
  final String temperatureUnit;
  final String windUnit;

  const Weather({
    required this.temperature,
    required this.windSpeed,
    required this.code,
    required this.temperatureUnit,
    required this.windUnit,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    final current = json['current'] as Map<String, dynamic>;
    final units = json['current_units'] as Map<String, dynamic>;
    return Weather(
      temperature: (current['temperature_2m'] as num).toDouble(),
      windSpeed: (current['wind_speed_10m'] as num).toDouble(),
      code: (current['weather_code'] as num).toInt(),
      temperatureUnit: units['temperature_2m'] as String,
      windUnit: units['wind_speed_10m'] as String,
    );
  }

  /// WMO weather codes -> readable text.
  String get description {
    if (code == 0) return 'Clear sky';
    if (code >= 1 && code <= 3) return 'Partly cloudy';
    if (code == 45 || code == 48) return 'Fog';
    if (code >= 51 && code <= 57) return 'Drizzle';
    if (code >= 61 && code <= 67) return 'Rain';
    if (code >= 71 && code <= 77) return 'Snow';
    if (code >= 80 && code <= 82) return 'Rain showers';
    if (code >= 95) return 'Thunderstorm';
    return 'Unknown';
  }

  Map<String, dynamic> toJson() => {
        'temperature': temperature,
        'windSpeed': windSpeed,
        'code': code,
      };
}
