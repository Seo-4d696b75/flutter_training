import 'package:freezed_annotation/freezed_annotation.dart';

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

class WeatherConverter implements JsonConverter<Weather, String> {
  const WeatherConverter();

  @override
  Weather fromJson(String json) {
    return parseWeather(json);
  }

  @override
  String toJson(Weather object) {
    return object.name.split(".").last;
  }
}
