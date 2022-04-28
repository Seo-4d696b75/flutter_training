import 'package:api/model/city.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_flutter/app.dart';
import 'package:hello_flutter/data/weather_api_impl.dart';
import 'package:hello_flutter/data/weather_repository.dart';
import 'package:hello_flutter/ui/event.dart';
import 'package:hello_flutter/ui/select/weather_view_state.dart';

import '../../data/weather_repository_impl.dart';

class WeatherViewModel extends StateNotifier<WeatherViewState> {
  WeatherViewModel(WeatherRepository repository)
      : _repository = repository,
        super(
          WeatherViewState(
            weather: repository.selectedCityWeather,
            isLoading: false,
            error: Event.none(),
          ),
        );

  final WeatherRepository _repository;

  Future<void> reload() async {
    state = state.copyWith(
      isLoading: true,
    );
    final currentIndex = _repository.selectedCityIndex;
    final nextIndex = (currentIndex + 1) % cities.length;
    final index = _repository.allWeather[currentIndex].when(
      data: (_) => nextIndex,
      error: (_) => currentIndex,
      none: () => currentIndex,
    );
    var error = await _repository.updateSelected(index);
    if (error != null) {
      state = state.copyWith(
        isLoading: false,
        weather: _repository.selectedCityWeather,
        error: Event.create(error),
      );
    } else {
      _repository.selectedCityIndex = nextIndex;
      state = state.copyWith(
        isLoading: false,
        weather: _repository.selectedCityWeather,
      );
    }
  }
}

final weatherViewModelProvider =
    StateNotifierProvider<WeatherViewModel, WeatherViewState>(
  (ref) => WeatherViewModel(
    ref.watch(weatherRepositoryProvider),
  ),
  dependencies: [
    localeProvider,
    weatherAPIProvider,
    weatherRepositoryProvider,
  ],
);
