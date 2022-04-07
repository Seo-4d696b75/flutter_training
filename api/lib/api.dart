/// Support for doing something awesome.
///
/// More dartdocs go here.
library api;

import 'dart:convert';
import 'dart:math';

import 'package:api/model/request.dart';
import 'package:api/model/response.dart';

enum _Weather { Sunny, Cloudy, Rainy }

extension on _Weather {
  String get name => toString().split(".").last.toLowerCase();
}

class YumemiWeather {
  final _random = Random();

  String fetchSimpleWeather() {
    return _Weather.values[_random.nextInt(_Weather.values.length)].name;
  }

  String fetchThrowWeather() {
    final size = _Weather.values.length;
    final idx = _random.nextInt(size + 1);
    if (idx == size) {
      throw UnknownException("fail to fetch weather");
    } else {
      return _Weather.values[idx].name;
    }
  }

  String fetchJsonWeather(String jsonStr) {
    var request = Request.fromJson(json.decode(jsonStr));
    var maxTemp = _random.nextInt(30) + 10;
    var minTemp = _random.nextInt(maxTemp + 40) - 40;
    var res = Response(
      weather: fetchThrowWeather(),
      maxTemp: maxTemp,
      minTemp: minTemp,
      date: request.date,
    );
    return json.encode(res.toJson());
  }
}

class UnknownException implements Exception {
  UnknownException(this.message);

  final dynamic message;

  @override
  String toString() {
    return "UnknownException{$message}";
  }
}
