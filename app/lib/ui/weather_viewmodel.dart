import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_flutter/data/weather_repository.dart';
import 'package:hello_flutter/ui/event.dart';

import '../data/weather.dart';
import '../data/weather_repository_impl.dart';

class WeatherViewModel extends ChangeNotifier {
  WeatherViewModel(WeatherRepository repository) : _repository = repository;

  final WeatherRepository _repository;
  Event<UnknownException> _reloadError = Event.none();

  Weather? get weather => _repository.weather;

  int? get minTemp => _repository.minTemp;

  int? get maxTemp => _repository.maxTemp;

  Event<UnknownException> get error => _reloadError;

  void reload() {
    try {
      _repository.updateWeather();
    } on UnknownException catch (e) {
      _reloadError = Event.create(e);
    }
    notifyListeners();
  }
}

final weatherViewModelProvider = ChangeNotifierProvider(
  (ref) => WeatherViewModel(ref.read(weatherRepositoryProvider)),
);
