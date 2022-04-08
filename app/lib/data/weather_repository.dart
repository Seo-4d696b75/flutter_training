import 'package:hello_flutter/data/weather.dart';

/// 天気予報情報へアクセス＆更新する機能
abstract class WeatherRepository {
  void updateWeather();

  Weather? get weather;

  int? get minTemp;

  int? get maxTemp;
}
