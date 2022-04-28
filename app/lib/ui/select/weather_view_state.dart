import 'package:api/model/current_weather.dart';
import 'package:api/open_weather_map.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hello_flutter/ui/event.dart';

part 'weather_view_state.freezed.dart';

@freezed
class WeatherViewState with _$WeatherViewState {
  const factory WeatherViewState({
    required CurrentWeather? weather,
    required bool isLoading,
    required Event<APIException> error,
  }) = _WeatherViewState;
}
