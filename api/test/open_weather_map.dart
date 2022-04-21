import 'dart:io';

import 'package:api/model/city.dart';
import 'package:api/open_weather_map.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'open_weather_map.mocks.dart';

@GenerateMocks([Client])
void main() {
  const str = """
  {"coord":{"lon":139.6917,"lat":35.6895},"weather":[{"id":501,"main":"Rain","description":"適度な雨","icon":"10d"}],"base":"stations","main":{"temp":20.4,"feels_like":20.01,"temp_min":17.75,"temp_max":21.55,"pressure":1020,"humidity":58},"visibility":8000,"wind":{"speed":3.09,"deg":150},"rain":{"1h":2.54},"clouds":{"all":75},"dt":1650511541,"sys":{"type":2,"id":2038398,"country":"JP","sunrise":1650484882,"sunset":1650532699},"timezone":32400,"id":1850147,"name":"東京都","cod":200}
  """;
  test("get current weather (mock http)", () async {
    final client = MockClient();
    final api = OpenWeatherMapAPI(client, "test");
    var response = Response(str, 200, headers: {
      HttpHeaders.contentTypeHeader: "application/json; charset=utf-8"
    });
    when(client.get(any)).thenAnswer((_) async => response);
    var weather = await api.fetchCurrentWeather(City.tokyo);
    expect(weather.cityId, City.tokyo.id);
  });
}
