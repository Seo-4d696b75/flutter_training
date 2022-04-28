import 'package:api/model/current_weather.dart';
import 'package:api/open_weather_map.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hello_flutter/data/stateful_value.dart';

part 'weather_list_view_state.freezed.dart';

@freezed
class WeatherListViewState with _$WeatherListViewState {
  const factory WeatherListViewState({
    required List<WeatherState> list,
    required bool isLoading,
  }) = _WeatherListViewState;
}

class WeatherState {
  const WeatherState(this.value, this.loading);

  final StatefulValue<CurrentWeather, APIException> value;
  final bool loading;
}
