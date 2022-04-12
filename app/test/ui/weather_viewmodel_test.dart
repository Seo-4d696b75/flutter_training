import 'package:api/api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hello_flutter/data/model/weather.dart';
import 'package:hello_flutter/data/model/weather_forecast.dart';
import 'package:hello_flutter/data/weather_api.dart';
import 'package:hello_flutter/data/weather_api_impl.dart';
import 'package:hello_flutter/ui/weather_viewmodel.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../data/weather_repository_test.mocks.dart';

@GenerateMocks([WeatherAPI])
void main() {
  group("weather view-model unit test", () {
    test("reload", () async {
      final api = MockWeatherAPI();
      final container = ProviderContainer(overrides: [
        weatherAPIProvider.overrideWithValue(api),
      ]);
      // setup mock api
      final mockWeather = WeatherForecast(
        weather: Weather.sunny,
        maxTemp: 20,
        minTemp: 10,
        date: DateTime.now(),
      );
      when(api.fetch(any)).thenAnswer((_) async => mockWeather);
      // target
      final viewModel = container.read(weatherViewModelProvider);
      // not init yet
      expect(viewModel.weather, isNull);
      expect(viewModel.error.hasValue, false);
      expect(viewModel.loading, false);
      // reload
      var reload = viewModel.reload();
      expect(viewModel.loading, true);
      await reload;
      // check
      expect(viewModel.weather?.weather, Weather.sunny);
      expect(viewModel.weather?.minTemp, 10);
      expect(viewModel.weather?.maxTemp, 20);
      expect(viewModel.loading, false);
      expect(viewModel.error.hasValue, false);
      // setup mock api
      final mockException = UnknownException("test");
      when(api.fetch(any)).thenThrow(mockException);
      // reload
      reload = viewModel.reload();
      expect(viewModel.loading, true);
      await reload;
      // check
      expect(viewModel.weather?.weather, Weather.sunny);
      expect(viewModel.weather?.minTemp, 10);
      expect(viewModel.weather?.maxTemp, 20);
      expect(viewModel.loading, false);
      expect(viewModel.error.hasValue, true);
      expect(viewModel.error.peek, mockException);
      // verify
      verify(api.fetch(any)).called(2);
    });
  });
}
