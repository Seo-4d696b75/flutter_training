import 'package:api/model/main_climatic_elements.dart';
import 'package:api/model/weather.dart';
import 'package:api/model/wind.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'current_weather.freezed.dart';

part 'current_weather.g.dart';

/// [see api docs](https://openweathermap.org/current)
@freezed
class CurrentWeather with _$CurrentWeather {
  const CurrentWeather._();

  const factory CurrentWeather({
    /// its size must be 1
    @JsonKey(name: "weather") required List<Weather> weatherList,
    required MainElements main,
    required Wind wind,
    @JsonKey(name: "dt") @UTCTimeConverter() required DateTime date,
    @JsonKey(name: "id") required int cityId,
    @JsonKey(name: "name") required String cityName,
    @JsonKey(name: "timezone")
    @TimeZoneOffsetConverter()
        required Duration timeZoneOffset,
  }) = _CurrentWeather;

  factory CurrentWeather.fromJson(Map<String, dynamic> json) =>
      _$CurrentWeatherFromJson(json);

  Weather get weather => weatherList[0];

  /// Gets datetime added timezone offset
  ///
  /// **Note** timezone still UTC, `isUtc` is true
  DateTime get localDate => date.add(timeZoneOffset);
}

class UTCTimeConverter implements JsonConverter<DateTime, int> {
  const UTCTimeConverter();

  @override
  DateTime fromJson(int json) {
    return DateTime.fromMillisecondsSinceEpoch(json * 1000, isUtc: true);
  }

  @override
  int toJson(DateTime object) {
    return object.toUtc().millisecondsSinceEpoch ~/ 1000;
  }
}

class TimeZoneOffsetConverter implements JsonConverter<Duration, int> {
  const TimeZoneOffsetConverter();

  @override
  Duration fromJson(int json) {
    return Duration(seconds: json);
  }

  @override
  int toJson(Duration object) {
    return object.inSeconds;
  }
}
