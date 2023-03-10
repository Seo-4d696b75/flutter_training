import 'package:api/model/request.dart';
import 'package:hello_flutter/data/model/weather_forecast.dart';

/// 天気予報情報を外部から取得する機能を抽象化
abstract class WeatherAPI {
  /// 新しい天気予報を取得する
  ///
  /// Throws [UnknownException] if any runtime error from api.
  Future<WeatherForecast> fetch(Request request);
}
