import 'dart:convert';

import 'package:api/model/current_weather.dart';
import 'package:api/model/main_climatic_elements.dart';
import 'package:api/model/weather.dart';
import 'package:api/model/wind.dart';
import 'package:test/test.dart';

/// This tests decoding JSON response from openweathermap.org
///
/// [see sample JSON and docs](https://openweathermap.org/current)
void main() {
  test("decode weather", () {
    const str = """
    {
      "id": 800,
      "main": "Clear",
      "description": "clear sky",
      "icon": "01d"
    }
    """;
    final weather = Weather.fromJson(json.decode(str));
    expect(weather.id, 800);
    expect(weather.main, "Clear");
    expect(weather.description, "clear sky");
    expect(weather.icon, "01d");
  });
  test("decode main climatic elements", () {
    const str = """
  {
    "temp": 282.55,
    "feels_like": 281.86,
    "temp_min": 280.37,
    "temp_max": 284.26,
    "pressure": 1023,
    "humidity": 100
  }
    """;
    final main = MainElements.fromJson(json.decode(str));
    expect(main.temperature, 282.55);
    expect(main.sensibleTemperature, 281.86);
    expect(main.minTemperature, 280.37);
    expect(main.maxTemperature, 284.26);
    expect(main.pressure, 1023.0);
    expect(main.humidity, 100.0);
  });
  test("decode wind", () {
    const str = """
  {
    "speed": 1.5,
    "deg": 350
  }
    """;
    final wind = Wind.fromJson(json.decode(str));
    expect(wind.speed, 1.5);
    expect(wind.deg, 350);
  });
  test("decode current weather", () {
    // https://api.openweathermap.org/data/2.5/weather?appid=${your_key}&id=1850147&units=metric&lang=ja
    const str = """
    {"coord":{"lon":139.6917,"lat":35.6895},"weather":[{"id":803,"main":"Clouds","description":"曇りがち","icon":"04n"}],"base":"stations","main":{"temp":17.48,"feels_like":16.88,"temp_min":15.97,"temp_max":18.13,"pressure":1015,"humidity":61},"visibility":10000,"wind":{"speed":6.17,"deg":200},"clouds":{"all":75},"dt":1650359863,"sys":{"type":2,"id":2038398,"country":"JP","sunrise":1650312233,"sunset":1650359798},"timezone":32400,"id":1850147,"name":"東京都","cod":200}
    """;
    final weather = CurrentWeather.fromJson(json.decode(str));
    expect(weather.weather.main, "Clouds");
    expect(weather.main.temperature, 17.48);
    expect(weather.wind.speed, 6.17);
    expect(weather.date.isUtc, true);
    expect(weather.date.millisecondsSinceEpoch, 1650359863 * 1000);
    expect(weather.timeZoneOffset.inHours, 9);
    expect(weather.cityId, 1850147);
    expect(weather.cityName, "東京都");
  });
}
