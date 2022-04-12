import 'dart:convert';

import 'package:api/api.dart';
import 'package:api/model/request.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_flutter/data/model/weather_forecast.dart';
import 'package:hello_flutter/data/weather_api.dart';

class WeatherAPIImpl implements WeatherAPI {
  final _api = YumemiWeather();

  @override
  WeatherForecast fetch(Request request) {
    var str = _api.fetchJsonWeather(json.encode(request.toJson()));
    return WeatherForecast.fromJson(json.decode(str));
  }
}

final weatherAPIProvider = Provider<WeatherAPI>((_) => WeatherAPIImpl());
