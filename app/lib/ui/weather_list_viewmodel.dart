import 'package:api/model/current_weather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_flutter/app.dart';
import 'package:hello_flutter/data/result.dart';
import 'package:hello_flutter/data/weather_api_impl.dart';
import 'package:hello_flutter/data/weather_repository.dart';
import 'package:hello_flutter/data/weather_repository_impl.dart';

class WeatherListViewModel extends ChangeNotifier {
  WeatherListViewModel(WeatherRepository repository) : _repository = repository;

  final WeatherRepository _repository;
  bool _loading = false;

  List<Result<CurrentWeather>> get weatherList => _repository.allWeather;

  bool get loading => _loading;

  Future<void> reload({bool lazy = false}) async {
    if (lazy && weatherList.isNotEmpty) return;
    _loading = true;
    notifyListeners();
    try {
      await _repository.updateAllWeather();
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
