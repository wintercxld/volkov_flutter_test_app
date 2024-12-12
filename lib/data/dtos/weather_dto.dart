import 'package:json_annotation/json_annotation.dart';

part 'weather_dto.g.dart';

@JsonSerializable(createToJson: false)
class WeatherDto {
  final List<WeatherIconDataDto>? weather;
  final WeatherMainInfoDto? main;
  final WeatherWindInfoDto? wind;
  final int? id;
  final String? name;

  const WeatherDto({this.weather, this.main, this.wind, this.id, this.name});

  factory WeatherDto.fromJson(Map<String, dynamic> json) =>
      _$WeatherDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class WeatherIconDataDto {
  final String? description;
  final String? icon;

  const WeatherIconDataDto({this.description, this.icon});

  factory WeatherIconDataDto.fromJson(Map<String, dynamic> json) =>
      _$WeatherIconDataDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class WeatherMainInfoDto {
  final double? temp;
  @JsonKey(name: 'feels_like')
  final double? feelsLike;
  final double? pressure;
  final double? humidity;

  const WeatherMainInfoDto(
      {this.temp, this.feelsLike, this.pressure, this.humidity});

  factory WeatherMainInfoDto.fromJson(Map<String, dynamic> json) =>
      _$WeatherMainInfoDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class WeatherWindInfoDto {
  final double? speed;
  final int? deg;

  const WeatherWindInfoDto({this.speed, this.deg});

  factory WeatherWindInfoDto.fromJson(Map<String, dynamic> json) =>
      _$WeatherWindInfoDtoFromJson(json);
}
