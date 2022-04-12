import 'package:hello_flutter/data/model/weather_forecast.dart';

/// 天気予報情報へアクセス＆更新する機能
abstract class WeatherRepository {
  Future<void> updateWeather();

  WeatherForecast? get weather;
}
