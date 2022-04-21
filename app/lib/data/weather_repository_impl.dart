import 'package:api/model/city.dart';
import 'package:api/model/current_weather.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_flutter/data/weather_api.dart';
import 'package:hello_flutter/data/weather_api_impl.dart';
import 'package:hello_flutter/data/weather_repository.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  WeatherRepositoryImpl(WeatherAPI api) : _api = api;

  final WeatherAPI _api;
  CurrentWeather? _weather;
  int _cityIndex = -1;

  @override
  Future<void> updateWeather() async {
    final nextIndex = (_cityIndex + 1) % cities.length;
    var response = await _api.fetch(cities[nextIndex]);
    _cityIndex = nextIndex;
    _weather = response;
  }

  @override
  CurrentWeather? get weather => _weather;
}

final weatherRepositoryProvider = Provider<WeatherRepository>(
  (ref) => WeatherRepositoryImpl(ref.watch(weatherAPIProvider)),
);
