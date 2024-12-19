import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:volkov_flutter_test_app/data/dtos/weather_dto.dart';
import 'package:volkov_flutter_test_app/data/mappers/weather_mapper.dart';
import 'package:volkov_flutter_test_app/data/repositories/api_interface.dart';
import 'package:volkov_flutter_test_app/domain/models/card.dart';

class WeatherRepository extends ApiInterface {
  static final Dio _dio = Dio()
    ..interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
    ));

  static const String _baseUrl = 'https://api.openweathermap.org';
  static const String _apiKey = '8f94917ee16d3c61a463af36dcb10499';

  List<Map<String, dynamic>> _allCities = [];

  Future<void> _loadCities() async {
    if (_allCities.isEmpty) {
      final String data =
          await rootBundle.loadString('assets/current.city.list.json');
      _allCities = List<Map<String, dynamic>>.from(json.decode(data));
    }
  }

  Future<List<String>> _getCitiesPage({
    int page = 1,
    int pageSize = 10,
    String? search,
  }) async {
    await _loadCities();

    final filteredCities = search != null && search.isNotEmpty
        ? _allCities.where((city) {
            final cityName = (city['name'] as String).toLowerCase();
            return cityName.contains(search.toLowerCase());
          }).toList()
        : _allCities;

    return filteredCities
        .skip((page - 1) * pageSize)
        .take(pageSize)
        .map((city) => city['name'] as String)
        .toList();
  }

  Future<List<CardData>> getWeatherForCities({
    required List<String> cities,
    OnErrorCallback? onError,
  }) async {
    try {
      final results = await Future.wait(
        cities.map((city) async {
          try {
            return await loadData(q: city, onError: onError);
          } catch (e) {
            onError?.call('Error fetching weather for city $city: $e');
            return [];
          }
        }),
      );

      return results
          .whereType<List<CardData>>()
          .expand((data) => data)
          .toList();
    } catch (e) {
      throw Exception('Error fetching weather for cities: $e');
    }
  }

  Future<List<CardData>> getWeatherForPage({
    required int page,
    int pageSize = 10,
    String? search,
    OnErrorCallback? onError,
  }) async {
    try {
      // Получаем список городов для текущей страницы с учётом фильтрации
      final cities = await _getCitiesPage(
        page: page,
        pageSize: pageSize,
        search: search,
      );

      // Загружаем погоду для этих городов
      return await getWeatherForCities(cities: cities, onError: onError);
    } catch (e) {
      onError?.call('Error loading weather for page $page: $e');
      return [];
    }
  }

  @override
  Future<List<CardData>> loadData({
    String? q,
    OnErrorCallback? onError,
  }) async {
    try {
      if (q == null || q.isEmpty) {
        throw ArgumentError('City name (q) must not be null or empty');
      }

      final String url = '$_baseUrl/data/2.5/weather';
      final response = await _dio.get<Map<String, dynamic>>(
        url,
        queryParameters: {
          'q': q,
          'appid': _apiKey,
          'lang': 'en',
          'units': 'metric',
        },
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to fetch weather data for $q. Status code: ${response.statusCode}');
      }

      final dto = WeatherDto.fromJson(response.data as Map<String, dynamic>);
      final data = dto.toDomain();
      return [data];
    } catch (e) {
      onError?.call(e.toString());
      return [];
    }
  }
}
