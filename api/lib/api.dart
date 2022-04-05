/// Support for doing something awesome.
///
/// More dartdocs go here.
library api;

import 'dart:math';

enum _Weather { Sunny, Cloudy, Rainy }

extension on _Weather {
  String get name => toString().split(".").last;
}

class YumemiWeather {
  final _random = Random();

  String fetchSimpleWeather() {
    return _Weather.values[_random.nextInt(_Weather.values.length)].name;
  }
}
