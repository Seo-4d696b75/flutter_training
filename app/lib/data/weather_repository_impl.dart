import 'package:api/model/city.dart';
import 'package:api/model/current_weather.dart';
import 'package:api/open_weather_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_flutter/data/result.dart';
import 'package:hello_flutter/data/weather_api.dart';
import 'package:hello_flutter/data/weather_api_impl.dart';
import 'package:hello_flutter/data/weather_repository.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  WeatherRepositoryImpl(WeatherAPI api) : _api = api;

  final WeatherAPI _api;
  CurrentWeather? _weather;
  int _cityIndex = -1;

  List<Result<CurrentWeather>> _weatherList = [];

  @override
  Future<void> updateWeather() async {
    final nextIndex = (_cityIndex + 1) % cities.length;
    var response = await _api.fetch(cities[nextIndex]);
    _cityIndex = nextIndex;
    _weather = response;
  }

  @override
  CurrentWeather? get weather => _weather;

  @override
  List<Result<CurrentWeather>> get allWeather => _weatherList;

  @override
  Future<void> updateAllWeather() async {
    var loadFutures = cities.map((city) => _api
        .fetch(city)
        .then((w) => Result.success(w))
        .onError<APIException>((error, _) => Result.failure(error)));
    _weatherList = await Future.wait(loadFutures);
  }
}

final weatherRepositoryProvider = Provider<WeatherRepository>(
  (ref) => WeatherRepositoryImpl(ref.watch(weatherAPIProvider)),
);
