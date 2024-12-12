import 'package:volkov_flutter_test_app/data/dtos/weather_dto.dart';
import 'package:volkov_flutter_test_app/domain/models/card.dart';

const _imagePlaceHolder = 'images/face-with-raised-eyebrow.png';

extension WeatherDataDtoToModel on WeatherDto {
  CardData toDomain() {
    final iconCode = weather?.isNotEmpty == true ? weather!.first.icon : null;
    final imageUrl = iconCode != null
        ? 'https://openweathermap.org/img/wn/$iconCode@2x.png'
        : _imagePlaceHolder;

    final temperature =
        main?.temp != null ? main!.temp!.toStringAsFixed(1) : 'N/A';

    return CardData(
      '${name ?? 'UNKNOWN'}, $temperature°C',
      imageUrl: imageUrl,
      descriptionText: _buildDescription(),
    );
  }

  String _buildDescription() {
    final description = weather?.isNotEmpty == true
        ? weather!.first.description ?? 'N/A'
        : 'N/A';
    final humidity = main?.humidity != null ? '${main!.humidity}%' : 'N/A';
    final pressure = main?.pressure != null ? '${main!.pressure} hPa' : 'N/A';
    final windSpeed = wind?.speed != null ? '${wind!.speed} m/s' : 'N/A';
    final windDirection = wind?.deg != null ? '${wind!.deg}°' : 'N/A';

    return 'Погода: $description\nВлажность: $humidity\nДавление: $pressure\nВетер: $windSpeed, $windDirection';
  }
}
