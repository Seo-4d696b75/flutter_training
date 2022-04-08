import 'package:api/model/request.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_flutter/data/weather.dart';

abstract class WeatherRepository {
  void updateWeather();

  Weather? get weather;

  int? get minTemp;

  int? get maxTemp;
}

class WeatherRepositoryImpl implements WeatherRepository {
  WeatherRepositoryImpl(WeatherAPI api) : _api = api;

  final WeatherAPI _api;
  Weather? _weather;
  int? _minTemp;
  int? _maxTemp;

  @override
  int? get maxTemp => _maxTemp;

  @override
  int? get minTemp => _minTemp;

  @override
  void updateWeather() {
    var request = Request(
      date: DateTime.now(),
      area: "tokyo",
    );
    var response = _api.fetch(request);
    _weather = parseWeather(response.weather);
    _minTemp = response.minTemp;
    _maxTemp = response.maxTemp;
  }

  @override
  Weather? get weather => _weather;
}

final weatherRepositoryProvider = Provider<WeatherRepository>(
    (ref) => WeatherRepositoryImpl(ref.read(weatherAPIProvider)));
