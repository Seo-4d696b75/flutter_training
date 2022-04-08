import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_flutter/data/weather_repository.dart';

import '../data/weather.dart';

class WeatherViewModel extends ChangeNotifier {
  WeatherViewModel(WeatherRepository repository) : _repository = repository;

  final WeatherRepository _repository;

  Weather? get weather => _repository.weather;

  int? get minTemp => _repository.minTemp;

  int? get maxTemp => _repository.maxTemp;

  void updateWeather() {
    _repository.updateWeather();
    notifyListeners();
  }
}

final weatherViewModelProvider = ChangeNotifierProvider(
    (ref) => WeatherViewModel(ref.read(weatherRepositoryProvider)));
