import 'package:api/model/response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hello_flutter/data/weather.dart';
import 'package:hello_flutter/data/weather_api.dart';
import 'package:hello_flutter/data/weather_api_impl.dart';
import 'package:hello_flutter/data/weather_repository_impl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'weather_repository_test.mocks.dart';

@GenerateMocks([WeatherAPI])
void main() {
  group("weather repository unit test", () {
    test("update weather", () {
      final api = MockWeatherAPI();
      final container = ProviderContainer(overrides: [
        weatherAPIProvider.overrideWithValue(api),
      ]);
      // setup mock api
      final mockWeather = Response(
        weather: "sunny",
        maxTemp: 20,
        minTemp: 10,
        date: DateTime.now(),
      );
      when(api.fetch(any)).thenReturn(mockWeather);
      // target
      final repository = container.read(weatherRepositoryProvider);
      // not init yet
      expect(repository.weather, isNull);
      expect(repository.minTemp, isNull);
      expect(repository.maxTemp, isNull);
      // update
      repository.updateWeather();
      // check
      expect(repository.weather, Weather.sunny);
      expect(repository.minTemp, 10);
      expect(repository.maxTemp, 20);
      // verify
      verify(api.fetch(any)).called(1);
    });
  });
}
