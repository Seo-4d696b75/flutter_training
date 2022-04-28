import 'package:api/model/current_weather.dart';
import 'package:api/open_weather_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_flutter/app.dart';
import 'package:hello_flutter/data/stateful_value.dart';
import 'package:hello_flutter/data/weather_api_impl.dart';
import 'package:hello_flutter/data/weather_repository.dart';
import 'package:hello_flutter/data/weather_repository_impl.dart';

class WeatherListViewModel extends ChangeNotifier {
  WeatherListViewModel(WeatherRepository repository)
      : _repository = repository,
        _weatherList =
            repository.allWeather.map((e) => WeatherState(e, false)).toList();

  final WeatherRepository _repository;
  List<WeatherState> _weatherList;
  bool _loading = false;

  List<WeatherState> get weatherList => _weatherList;

  void selectCity(int index) {
    _repository.selectedCityIndex = index;
  }

  Future<void> reload({int index = -1}) async {
    if (_loading) return;
    _loading = true;
    _weatherList = _repository.allWeather.asMap().entries.map((e) {
      var i = e.key;
      var value = e.value;
      return WeatherState(value, index == i);
    }).toList();
    notifyListeners();
    try {
      if (index < 0) {
        await _repository.updateAll();
      } else {
        await _repository.updateSelected(index);
      }
    } finally {
      _loading = false;
      _weatherList =
          _repository.allWeather.map((e) => WeatherState(e, false)).toList();
      notifyListeners();
    }
  }
}

final weatherListViewModelProvider = ChangeNotifierProvider(
  (ref) => WeatherListViewModel(ref.watch(weatherRepositoryProvider)),
  dependencies: [
    localeProvider,
    weatherAPIProvider,
    weatherRepositoryProvider,
  ],
);

class WeatherState {
  const WeatherState(this.value, this.loading);

  final StatefulValue<CurrentWeather, APIException> value;
  final bool loading;
}
