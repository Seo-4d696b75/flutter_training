import 'package:api/model/current_weather.dart';
import 'package:api/open_weather_map.dart';
import 'package:hello_flutter/data/stateful_value.dart';

/// 天気予報情報へアクセス＆更新する機能
abstract class WeatherRepository {
  Future<APIException?> updateSelected(int index);

  int selectedCityIndex = 0;

  Future<void> updateAll();

  List<StatefulValue<CurrentWeather, APIException>> get allWeather;

  CurrentWeather? get selectedCityWeather;
}
