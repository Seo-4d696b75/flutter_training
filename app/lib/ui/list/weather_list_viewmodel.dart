import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_flutter/app.dart';
import 'package:hello_flutter/data/weather_api_impl.dart';
import 'package:hello_flutter/data/weather_repository.dart';
import 'package:hello_flutter/data/weather_repository_impl.dart';
import 'package:hello_flutter/ui/list/weather_list_view_state.dart';

class WeatherListViewModel extends StateNotifier<WeatherListViewState> {
  WeatherListViewModel(WeatherRepository repository)
      : _repository = repository,
        super(
          WeatherListViewState(
            list: repository.allWeather
                .map((e) => WeatherState(e, false))
                .toList(),
            isLoading: false,
          ),
        );

  final WeatherRepository _repository;

  void selectCity(int index) {
    _repository.selectedCityIndex = index;
  }

  Future<void> reload({int index = -1}) async {
    if (state.isLoading) return;
    state = state.copyWith(
      isLoading: true,
      list: _repository.allWeather.asMap().entries.map((e) {
        var i = e.key;
        var value = e.value;
        return WeatherState(value, index == i);
      }).toList(),
    );
    try {
      if (index < 0) {
        await _repository.updateAll();
      } else {
        await _repository.updateSelected(index);
      }
    } finally {
      state = state.copyWith(
        isLoading: false,
        list:
            _repository.allWeather.map((e) => WeatherState(e, false)).toList(),
      );
    }
  }
}

final weatherListViewModelProvider =
    StateNotifierProvider<WeatherListViewModel, WeatherListViewState>(
  (ref) => WeatherListViewModel(ref.watch(weatherRepositoryProvider)),
  dependencies: [
    localeProvider,
    weatherAPIProvider,
    weatherRepositoryProvider,
  ],
);
