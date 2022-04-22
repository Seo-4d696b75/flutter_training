import 'package:api/model/city.dart';
import 'package:api/model/current_weather.dart';
import 'package:api/open_weather_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_flutter/data/stateful_value.dart';
import 'package:hello_flutter/data/weather_api.dart';
import 'package:hello_flutter/data/weather_api_impl.dart';
import 'package:hello_flutter/data/weather_repository.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  WeatherRepositoryImpl(WeatherAPI api) : _api = api;

  final WeatherAPI _api;

  @override
  int selectedCityIndex = 0;

  List<StatefulValue<CurrentWeather, APIException>> _weatherList = cities
      .map((e) => const StatefulValue<CurrentWeather, APIException>.none())
      .toList();

  @override
  Future<APIException?> updateSelected(int index) async {
    try {
      var response = await _api.fetch(cities[index]);
      _weatherList[index] = StatefulValue.data(response);
      return null;
    } on APIException catch (e) {
      _weatherList[index] = StatefulValue.error(e);
      return e;
    }
  }

  @override
  List<StatefulValue<CurrentWeather, APIException>> get allWeather =>
      _weatherList;

  @override
  Future<void> updateAll() async {
    var loadFutures = cities.map((city) => _api
        .fetch(city)
        .then((w) => StatefulValue<CurrentWeather, APIException>.data(w))
        .onError<APIException>((error, _) =>
            StatefulValue<CurrentWeather, APIException>.error(error)));
    _weatherList = await Future.wait(loadFutures);
  }
}

final weatherRepositoryProvider = Provider<WeatherRepository>(
  (ref) => WeatherRepositoryImpl(ref.watch(weatherAPIProvider)),
);
