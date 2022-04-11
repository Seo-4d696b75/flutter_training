import 'package:api/api.dart';
import 'package:api/model/response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hello_flutter/data/weather.dart';
import 'package:hello_flutter/data/weather_api.dart';
import 'package:hello_flutter/data/weather_api_impl.dart';
import 'package:hello_flutter/ui/weather_viewmodel.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../data/weather_repository_test.mocks.dart';

@GenerateMocks([WeatherAPI])
void main() {
  group("weather view-model unit test", () {
    test("reload", () {
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
      final viewModel = container.read(weatherViewModelProvider);
      // not init yet
      expect(viewModel.weather, isNull);
      expect(viewModel.minTemp, isNull);
      expect(viewModel.maxTemp, isNull);
      expect(viewModel.error.hasValue, false);
      // reload
      viewModel.reload();
      // check
      expect(viewModel.weather, Weather.sunny);
      expect(viewModel.minTemp, 10);
      expect(viewModel.maxTemp, 20);
      expect(viewModel.error.hasValue, false);
      // setup mock api
      final mockException = UnknownException("test");
      when(api.fetch(any)).thenThrow(mockException);
      // reload
      viewModel.reload();
      // check
      expect(viewModel.weather, Weather.sunny);
      expect(viewModel.minTemp, 10);
      expect(viewModel.maxTemp, 20);
      expect(viewModel.error.hasValue, true);
      expect(viewModel.error.peek, mockException);
      // verify
      verify(api.fetch(any)).called(2);
    });
  });
}
