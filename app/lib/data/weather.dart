import 'dart:convert';

import 'package:api/api.dart';
import 'package:api/model/request.dart';
import 'package:api/model/response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Weather { sunny, cloudy, rainy }

Weather parseWeather(String value) {
  switch (value) {
    case "sunny":
      return Weather.sunny;
    case "cloudy":
      return Weather.cloudy;
    case "rainy":
      return Weather.rainy;
    default:
      throw ArgumentError("invalid weather string value: $value");
  }
}

abstract class WeatherAPI {
  Response fetch(Request request);
}

class WeatherAPIImpl implements WeatherAPI {
  final _api = YumemiWeather();

  @override
  Response fetch(Request request) {
    var str = _api.fetchJsonWeather(json.encode(request.toJson()));
    return Response.fromJson(json.decode(str));
  }
}

final weatherAPIProvider = Provider<WeatherAPI>((_) => WeatherAPIImpl());
