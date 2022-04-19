import 'package:freezed_annotation/freezed_annotation.dart';

part 'weather.freezed.dart';

part 'weather.g.dart';

/// [see API docs](https://openweathermap.org/weather-conditions)
@freezed
class Weather with _$Weather {
  const factory Weather({
    required int id,
    required String main,
    required String description,
    required String icon,
  }) = _Weather;

  factory Weather.fromJson(Map<String, dynamic> json) =>
      _$WeatherFromJson(json);
}
