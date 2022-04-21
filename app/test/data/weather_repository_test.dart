import 'dart:convert';

import 'package:api/model/current_weather.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hello_flutter/data/weather_api.dart';
import 'package:hello_flutter/data/weather_api_impl.dart';
import 'package:hello_flutter/data/weather_repository_impl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'weather_repository_test.mocks.dart';

@GenerateMocks([WeatherAPI])
void main() {
  group("weather repository unit test", () {
    test("update weather", () async {
      final api = MockWeatherAPI();
      final container = ProviderContainer(overrides: [
        weatherAPIProvider.overrideWithValue(api),
      ]);
      // setup mock api
      const jsonStr = """
          {"coord":{"lon":139.6917,"lat":35.6895},"weather":[{"id":803,"main":"Clouds","description":"曇りがち","icon":"04n"}],"base":"stations","main":{"temp":17.48,"feels_like":16.88,"temp_min":15.97,"temp_max":18.13,"pressure":1015,"humidity":61},"visibility":10000,"wind":{"speed":6.17,"deg":200},"clouds":{"all":75},"dt":1650359863,"sys":{"type":2,"id":2038398,"country":"JP","sunrise":1650312233,"sunset":1650359798},"timezone":32400,"id":1850147,"name":"東京都","cod":200}
      """;
      final mockWeather = CurrentWeather.fromJson(json.decode(jsonStr));
      when(api.fetch(any)).thenAnswer((_) async => mockWeather);
      // target
      final repository = container.read(weatherRepositoryProvider);
      // not init yet
      expect(repository.weather, isNull);
      // update
      await repository.updateWeather();
      // check
      expect(repository.weather?.weather.main, "Clouds");
      expect(repository.weather?.main.minTemperature, 15.97);
      expect(repository.weather?.main.maxTemperature, 18.13);
      // verify
      verify(api.fetch(any)).called(1);
    });
  });
}
