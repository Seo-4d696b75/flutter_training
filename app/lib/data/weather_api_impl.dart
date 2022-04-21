import 'dart:math';

import 'package:api/model/city.dart';
import 'package:api/model/current_weather.dart';
import 'package:api/open_weather_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_flutter/data/weather_api.dart';
import 'package:http/http.dart';

class WeatherAPIImpl implements WeatherAPI {
  WeatherAPIImpl(Client client, String apiKey)
      : _api = OpenWeatherMapAPI(
          client,
          apiKey,
          language: "jp",
          units: "metric",
        );

  final OpenWeatherMapAPI _api;
  final _random = Random();

  @override
  Future<CurrentWeather> fetch(City city) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    if (_random.nextDouble() < 0.2) {
      throw APIException(
          "fail to fetch current weather ${city.name}: random error");
    }
    return _api.fetchCurrentWeather(city);
  }
}

final httpClientProvider = Provider<Client>((_) => Client());
final apiKeyProvider =
    Provider<String>((_) => const String.fromEnvironment("API_KEY"));
final weatherAPIProvider = Provider<WeatherAPI>((ref) {
  var client = ref.read(httpClientProvider);
  var apiKey = ref.read(apiKeyProvider);
  return WeatherAPIImpl(client, apiKey);
});
