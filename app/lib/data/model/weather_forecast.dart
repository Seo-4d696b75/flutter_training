import 'package:api/model/datetime_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hello_flutter/data/model/weather.dart';

part 'weather_forecast.freezed.dart';

part 'weather_forecast.g.dart';

@freezed
class WeatherForecast with _$WeatherForecast {
  const factory WeatherForecast({
    @WeatherConverter() required Weather weather,
    required int maxTemp,
    required int minTemp,
    @DateTimeConverter() required DateTime date,
  }) = _WeatherForecast;

  factory WeatherForecast.fromJson(Map<String, dynamic> json) =>
      _$WeatherForecastFromJson(json);
}
