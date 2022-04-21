import 'dart:convert';

import 'package:api/model/city.dart';
import 'package:api/model/current_weather.dart';
import 'package:http/http.dart' as http;

class OpenWeatherMapAPI {
  OpenWeatherMapAPI(
    this._client,
    this._apiKey, {
    String language = "en",
    String units = "standard",
  })  : _language = language,
        _units = units;

  final http.Client _client;
  final String _language;
  final String _units;
  final String _apiKey;

  static const _host = "api.openweathermap.org";
  static const _basePath = "data/2.5";

  Map<String, String> _getQuery(Map<String, String> query) {
    query["appid"] = _apiKey;
    query["lang"] = _language;
    query["units"] = _units;
    return query;
  }

  Future<CurrentWeather> fetchCurrentWeather(City city) async {
    try {
      var query = _getQuery({"id": city.id.toString()});
      var url = Uri.https(_host, "$_basePath/weather", query);
      var res = await _client.get(url);
      return CurrentWeather.fromJson(json.decode(res.body));
    } catch (e) {
      throw APIException("fail to fetch current weather ${city.name}: $e");
    }
  }
}

class APIException implements Exception {
  APIException(this.message);

  final dynamic message;

  @override
  String toString() {
    return "UnknownException{$message}";
  }
}
