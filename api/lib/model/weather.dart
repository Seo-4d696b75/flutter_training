import 'package:freezed_annotation/freezed_annotation.dart';

part 'weather.freezed.dart';

part 'weather.g.dart';

/// [see API docs](https://openweathermap.org/weather-conditions)
@freezed
class Weather with _$Weather {
  const factory Weather({
    required int id,
    required String main,
    required String description,
    @WeatherIconConverter() required WeatherIcon icon,
  }) = _Weather;

  factory Weather.fromJson(Map<String, dynamic> json) =>
      _$WeatherFromJson(json);
}

enum WeatherIcon {
  clearSky,
  fewClouds,
  scatteredClouds,
  brokenClouds,
  showerRain,
  rain,
  thunderstorm,
  snow,
  mist,
  unknown
}

class WeatherIconConverter implements JsonConverter<WeatherIcon, String> {
  const WeatherIconConverter();

  @override
  WeatherIcon fromJson(String json) {
    if (json.length == 3) {
      switch (json.substring(0, 2)) {
        case "01":
          return WeatherIcon.clearSky;
        case "02":
          return WeatherIcon.fewClouds;
        case "03":
          return WeatherIcon.scatteredClouds;
        case "04":
          return WeatherIcon.brokenClouds;
        case "09":
          return WeatherIcon.showerRain;
        case "10":
          return WeatherIcon.rain;
        case "11":
          return WeatherIcon.thunderstorm;
        case "13":
          return WeatherIcon.snow;
        case "50":
          return WeatherIcon.mist;
        default:
      }
    }
    return WeatherIcon.unknown;
  }

  @override
  String toJson(WeatherIcon object) {
    switch (object) {
      case WeatherIcon.clearSky:
        return "01d";
      case WeatherIcon.fewClouds:
        return "02d";
      case WeatherIcon.scatteredClouds:
        return "03d";
      case WeatherIcon.brokenClouds:
        return "04d";
      case WeatherIcon.showerRain:
        return "09d";
      case WeatherIcon.rain:
        return "10d";
      case WeatherIcon.thunderstorm:
        return "11d";
      case WeatherIcon.snow:
        return "13d";
      case WeatherIcon.mist:
        return "50d";
      default:
        throw ArgumentError("can not convert unknown to string");
    }
  }
}
