import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/country.dart';
import '../models/weather.dart';
import 'api_service.dart' show ApiException;

/// Talks to two public services:
///  - Open countries dataset on GitHub (list of all countries, no API key)
///  - Open-Meteo (current weather by latitude/longitude, no API key)
///
/// Note: the classic restcountries.com v3.1 API was shut down (v5 needs an account
/// and a key), so we read the same open dataset it was built on.
class CountriesService {
  static const Duration _timeout = Duration(seconds: 15); // the file is ~1.4 MB
  static List<Country>? _cache;

  final http.Client _client;
  CountriesService({http.Client? client}) : _client = client ?? http.Client();

  Future<dynamic> _get(Uri uri) async {
    try {
      final response = await _client
          .get(uri, headers: const {'Accept': 'application/json'})
          .timeout(_timeout);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      }
      throw ApiException(_messageForStatus(response.statusCode), response.statusCode);
    } on TimeoutException {
      throw const ApiException('The request timed out. Please try again.');
    } on SocketException {
      throw const ApiException('No internet connection.');
    } on http.ClientException {
      throw const ApiException('Network error. Check your connection.');
    } on FormatException {
      throw const ApiException('Received invalid data from the server.');
    }
  }

  String _messageForStatus(int code) {
    if (code == 404) return 'Not found (404).';
    if (code == 429) return 'Too many requests (429). Wait a moment.';
    if (code >= 500) return 'Server error ($code). Try again later.';
    return 'Unexpected error ($code).';
  }

  List<Country> _parseCountries(dynamic data) {
    if (data is! List) {
      throw const ApiException('Unexpected data format from the server.');
    }
    try {
      final list = data
          .map((e) => Country.fromJson(e as Map<String, dynamic>))
          .toList();
      list.sort((a, b) => a.name.compareTo(b.name));
      return list;
    } catch (e) {
      throw ApiException('Parse error: $e');
    }
  }

  /// GET the full countries file. Result is cached in memory;
  /// pass [forceRefresh] (pull-to-refresh) to download it again.
  Future<List<Country>> getAll({bool forceRefresh = false}) async {
    if (!forceRefresh && _cache != null) return _cache!;
    final uri = Uri.https(
      'raw.githubusercontent.com',
      '/mledoze/countries/master/countries.json',
    );
    _cache = _parseCountries(await _get(uri));
    return _cache!;
  }

  /// GET https://api.open-meteo.com/v1/forecast?latitude=..&longitude=..&current=..
  Future<Weather> getWeather(double lat, double lng) async {
    final uri = Uri.https('api.open-meteo.com', '/v1/forecast', {
      'latitude': '$lat',
      'longitude': '$lng',
      'current': 'temperature_2m,wind_speed_10m,weather_code',
    });
    final data = await _get(uri);
    return Weather.fromJson(data as Map<String, dynamic>);
  }
}
