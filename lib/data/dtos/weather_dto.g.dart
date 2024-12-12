// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherDto _$WeatherDtoFromJson(Map<String, dynamic> json) => WeatherDto(
      weather: (json['weather'] as List<dynamic>?)
          ?.map((e) => WeatherIconDataDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      main: json['main'] == null
          ? null
          : WeatherMainInfoDto.fromJson(json['main'] as Map<String, dynamic>),
      wind: json['wind'] == null
          ? null
          : WeatherWindInfoDto.fromJson(json['wind'] as Map<String, dynamic>),
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
    );

WeatherIconDataDto _$WeatherIconDataDtoFromJson(Map<String, dynamic> json) =>
    WeatherIconDataDto(
      description: json['description'] as String?,
      icon: json['icon'] as String?,
    );

WeatherMainInfoDto _$WeatherMainInfoDtoFromJson(Map<String, dynamic> json) =>
    WeatherMainInfoDto(
      temp: (json['temp'] as num?)?.toDouble(),
      feelsLike: (json['feels_like'] as num?)?.toDouble(),
      pressure: (json['pressure'] as num?)?.toDouble(),
      humidity: (json['humidity'] as num?)?.toDouble(),
    );

WeatherWindInfoDto _$WeatherWindInfoDtoFromJson(Map<String, dynamic> json) =>
    WeatherWindInfoDto(
      speed: (json['speed'] as num?)?.toDouble(),
      deg: (json['deg'] as num?)?.toInt(),
    );
