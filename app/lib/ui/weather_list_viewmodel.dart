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
  WeatherListViewModel(WeatherRepository repository) : _repository = repository;

  final WeatherRepository _repository;
  bool _loading = false;

  List<StatefulValue<CurrentWeather, APIException>> get weatherList =>
      _repository.allWeather;

  bool get loading => _loading;

  void selectCity(int index) {
    _repository.selectedCityIndex = index;
  }

  Future<void> reload({int index = -1}) async {
    if (_loading) return;
    _loading = true;
    notifyListeners();
    try {
      if (index < 0) {
        await _repository.updateAll();
      } else {
        await _repository.updateSelected(index);
      }
    } finally {
      _loading = false;
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
