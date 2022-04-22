import 'package:api/model/current_weather.dart';
import 'package:api/open_weather_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_flutter/app.dart';
import 'package:hello_flutter/data/weather_api_impl.dart';
import 'package:hello_flutter/data/weather_repository.dart';
import 'package:hello_flutter/ui/event.dart';

import '../data/weather_repository_impl.dart';

class WeatherViewModel extends ChangeNotifier {
  WeatherViewModel(WeatherRepository repository) : _repository = repository;

  final WeatherRepository _repository;
  Event<APIException> _reloadError = Event.none();
  bool _loading = false;

  CurrentWeather? get weather => _repository.weather;

  bool get loading => _loading;

  Event<APIException> get error => _reloadError;

  Future<void> reload() async {
    _loading = true;
    notifyListeners();
    try {
      await _repository.updateWeather();
    } on APIException catch (e) {
      _reloadError = Event.create(e);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}

final weatherViewModelProvider = ChangeNotifierProvider(
  (ref) => WeatherViewModel(ref.watch(weatherRepositoryProvider)),
  dependencies: [
    localeProvider,
    weatherAPIProvider,
    weatherRepositoryProvider,
  ],
);
