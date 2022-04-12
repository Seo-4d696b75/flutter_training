import 'package:api/model/request.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_flutter/data/model/weather_forecast.dart';
import 'package:hello_flutter/data/weather_api.dart';
import 'package:hello_flutter/data/weather_api_impl.dart';
import 'package:hello_flutter/data/weather_repository.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  WeatherRepositoryImpl(WeatherAPI api) : _api = api;

  final WeatherAPI _api;
  WeatherForecast? _weather;

  @override
  Future<void> updateWeather() async {
    var request = Request(
      date: DateTime.now(),
      area: "tokyo",
    );
    var response = await _api.fetch(request);
    _weather = response;
  }

  @override
  WeatherForecast? get weather => _weather;
}

final weatherRepositoryProvider = Provider<WeatherRepository>(
  (ref) => WeatherRepositoryImpl(ref.read(weatherAPIProvider)),
);
