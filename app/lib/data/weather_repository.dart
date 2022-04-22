import 'package:api/model/current_weather.dart';
import 'package:hello_flutter/data/result.dart';

/// 天気予報情報へアクセス＆更新する機能
abstract class WeatherRepository {
  Future<void> updateWeather();

  CurrentWeather? get weather;

  Future<void> updateAllWeather();

  List<Result<CurrentWeather>> get allWeather;
}
