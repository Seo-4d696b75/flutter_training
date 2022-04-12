import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_flutter/data/model/weather_forecast.dart';
import 'package:hello_flutter/data/weather_repository.dart';
import 'package:hello_flutter/ui/event.dart';

import '../data/weather_repository_impl.dart';

class WeatherViewModel extends ChangeNotifier {
  WeatherViewModel(WeatherRepository repository) : _repository = repository;

  final WeatherRepository _repository;
  Event<UnknownException> _reloadError = Event.none();
  bool _loading = false;

  WeatherForecast? get weather => _repository.weather;

  bool get loading => _loading;

  Event<UnknownException> get error => _reloadError;

  void reload() async {
    _loading = true;
    notifyListeners();
    try {
      await _repository.updateWeather();
    } on UnknownException catch (e) {
      _reloadError = Event.create(e);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}

final weatherViewModelProvider = ChangeNotifierProvider(
  (ref) => WeatherViewModel(ref.read(weatherRepositoryProvider)),
);
