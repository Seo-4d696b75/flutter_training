import 'package:api/model/current_weather.dart';

/// 天気予報情報へアクセス＆更新する機能
abstract class WeatherRepository {
  Future<void> updateWeather();

  CurrentWeather? get weather;
}
