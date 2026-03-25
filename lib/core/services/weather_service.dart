import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherSnapshot {
  final String city;
  final int temperatureC;
  final int humidity;
  final String condition;
  final int uvIndex;
  final String sunrise;
  final String sunset;
  final IconData icon;
  final DateTime fetchedAt;

  const WeatherSnapshot({
    required this.city,
    required this.temperatureC,
    required this.humidity,
    required this.condition,
    required this.uvIndex,
    required this.sunrise,
    required this.sunset,
    required this.icon,
    required this.fetchedAt,
  });
}

class WeatherService {
  static const _geocodeBase = 'https://geocoding-api.open-meteo.com/v1/search';
  static const _forecastBase = 'https://api.open-meteo.com/v1/forecast';
  static const Duration _requestTimeout = Duration(seconds: 8);
  static const Duration _cacheTtl = Duration(minutes: 15);
  static final Map<String, _CachedWeather> _cache = {};

  Future<WeatherSnapshot?> fetchCurrentWeather({
    required String city,
    double? lat,
    double? lng,
    bool forceRefresh = false,
  }) async {
    try {
      final cacheKey = _cacheKey(city: city, lat: lat, lng: lng);
      if (!forceRefresh) {
        final cached = _cache[cacheKey];
        if (cached != null &&
            DateTime.now().difference(cached.fetchedAt) < _cacheTtl) {
          return cached.snapshot;
        }
      }

      final resolved = await _resolveCoordinates(
        city: city,
        lat: lat,
        lng: lng,
      );
      if (resolved == null) return null;

      final uri = Uri.parse(_forecastBase).replace(
        queryParameters: {
          'latitude': resolved.latitude.toString(),
          'longitude': resolved.longitude.toString(),
          'current':
              'temperature_2m,relative_humidity_2m,weather_code,uv_index',
          'daily': 'sunrise,sunset',
          'timezone': 'auto',
        },
      );

      final response = await _getWithRetry(uri);
      if (response == null || response.statusCode != 200) return null;

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final current = data['current'] as Map<String, dynamic>?;
      final daily = data['daily'] as Map<String, dynamic>?;
      if (current == null || daily == null) return null;

      final sunriseList = daily['sunrise'] as List<dynamic>?;
      final sunsetList = daily['sunset'] as List<dynamic>?;
      final weatherCode = (current['weather_code'] as num?)?.toInt();
      final temp = (current['temperature_2m'] as num?)?.round();
      final humidity = (current['relative_humidity_2m'] as num?)?.round();
      final uv = (current['uv_index'] as num?)?.round();

      if (weatherCode == null ||
          temp == null ||
          humidity == null ||
          uv == null) {
        return null;
      }

      final sunrise = sunriseList == null || sunriseList.isEmpty
          ? '--:--'
          : _hhmmFromIso(sunriseList.first.toString());
      final sunset = sunsetList == null || sunsetList.isEmpty
          ? '--:--'
          : _hhmmFromIso(sunsetList.first.toString());

      final condition = _conditionText(weatherCode);

      final snapshot = WeatherSnapshot(
        city: resolved.cityName,
        temperatureC: temp,
        humidity: humidity,
        condition: condition,
        uvIndex: uv,
        sunrise: sunrise,
        sunset: sunset,
        icon: _weatherIcon(weatherCode),
        fetchedAt: DateTime.now(),
      );

      _cache[cacheKey] = _CachedWeather(
        snapshot: snapshot,
        fetchedAt: snapshot.fetchedAt,
      );

      return snapshot;
    } catch (_) {
      return null;
    }
  }

  Future<_ResolvedLocation?> _resolveCoordinates({
    required String city,
    double? lat,
    double? lng,
  }) async {
    if (lat != null && lng != null) {
      return _ResolvedLocation(cityName: city, latitude: lat, longitude: lng);
    }

    final uri = Uri.parse(_geocodeBase).replace(
      queryParameters: {
        'name': city,
        'count': '1',
        'language': 'en',
        'format': 'json',
      },
    );

    final response = await _getWithRetry(uri);
    if (response == null || response.statusCode != 200) return null;

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final results = data['results'] as List<dynamic>?;
    if (results == null || results.isEmpty) return null;

    final first = results.first as Map<String, dynamic>;
    final latitude = (first['latitude'] as num?)?.toDouble();
    final longitude = (first['longitude'] as num?)?.toDouble();
    final cityName = first['name']?.toString() ?? city;

    if (latitude == null || longitude == null) return null;
    return _ResolvedLocation(
      cityName: cityName,
      latitude: latitude,
      longitude: longitude,
    );
  }

  Future<http.Response?> _getWithRetry(Uri uri) async {
    for (var attempt = 0; attempt < 2; attempt++) {
      try {
        final response = await http.get(uri).timeout(_requestTimeout);
        if (response.statusCode == 200 || attempt == 1) {
          return response;
        }
      } catch (_) {
        if (attempt == 1) return null;
      }
    }
    return null;
  }

  String _cacheKey({required String city, double? lat, double? lng}) {
    final latKey = lat?.toStringAsFixed(3) ?? '-';
    final lngKey = lng?.toStringAsFixed(3) ?? '-';
    return '${city.toLowerCase().trim()}|$latKey|$lngKey';
  }

  String _hhmmFromIso(String iso) {
    final parsed = DateTime.tryParse(iso);
    if (parsed == null) return '--:--';
    final hh = parsed.hour.toString().padLeft(2, '0');
    final mm = parsed.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  String _conditionText(int code) {
    if (code == 0) return 'Clear sky';
    if (code == 1 || code == 2) return 'Partly cloudy';
    if (code == 3) return 'Overcast';
    if (code == 45 || code == 48) return 'Fog';
    if (code == 51 || code == 53 || code == 55) return 'Drizzle';
    if (code == 56 || code == 57) return 'Freezing drizzle';
    if (code == 61 || code == 63 || code == 65) return 'Rain';
    if (code == 66 || code == 67) return 'Freezing rain';
    if (code == 71 || code == 73 || code == 75) return 'Snow';
    if (code == 77) return 'Snow grains';
    if (code == 80 || code == 81 || code == 82) return 'Rain showers';
    if (code == 85 || code == 86) return 'Snow showers';
    if (code == 95) return 'Thunderstorm';
    if (code == 96 || code == 99) return 'Thunderstorm and hail';
    return 'Unknown';
  }

  IconData _weatherIcon(int code) {
    if (code == 0) return Icons.wb_sunny;
    if (code == 1 || code == 2) return Icons.cloud_queue;
    if (code == 3) return Icons.cloud;
    if (code == 45 || code == 48) return Icons.foggy;
    if (code == 51 || code == 53 || code == 55 || code == 56 || code == 57) {
      return Icons.grain;
    }
    if (code == 61 || code == 63 || code == 65 || code == 66 || code == 67) {
      return Icons.umbrella;
    }
    if (code == 71 || code == 73 || code == 75 || code == 77) {
      return Icons.ac_unit;
    }
    if (code == 80 || code == 81 || code == 82) return Icons.shower;
    if (code == 85 || code == 86) return Icons.ac_unit;
    if (code == 95 || code == 96 || code == 99) return Icons.thunderstorm;
    return Icons.wb_cloudy;
  }
}

class _ResolvedLocation {
  final String cityName;
  final double latitude;
  final double longitude;

  const _ResolvedLocation({
    required this.cityName,
    required this.latitude,
    required this.longitude,
  });
}

class _CachedWeather {
  final WeatherSnapshot snapshot;
  final DateTime fetchedAt;

  const _CachedWeather({required this.snapshot, required this.fetchedAt});
}
