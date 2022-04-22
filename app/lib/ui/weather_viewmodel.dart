import 'package:api/model/city.dart';
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

  CurrentWeather? get weather =>
      _repository.allWeather[_repository.selectedCityIndex].when(
        data: (v) => v,
        error: (_) => null,
        none: () => null,
      );

  bool get loading => _loading;

  Event<APIException> get error => _reloadError;

  Future<void> reload() async {
    _loading = true;
    notifyListeners();
    final currentIndex = _repository.selectedCityIndex;
    final nextIndex = (currentIndex + 1) % cities.length;
    final index = _repository.allWeather[currentIndex].when(
      data: (_) => nextIndex,
      error: (_) => currentIndex,
      none: () => currentIndex,
    );
    try {
      var error = await _repository.updateSelected(index);
      if (error != null) {
        _reloadError = Event.create(error);
      } else {
        _repository.selectedCityIndex = index;
      }
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
