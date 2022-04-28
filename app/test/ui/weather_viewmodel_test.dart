import 'dart:convert';

import 'package:api/model/current_weather.dart';
import 'package:api/open_weather_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hello_flutter/data/weather_api.dart';
import 'package:hello_flutter/data/weather_api_impl.dart';
import 'package:hello_flutter/ui/select/weather_viewmodel.dart';
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
      const jsonStr = """
          {"coord":{"lon":139.6917,"lat":35.6895},"weather":[{"id":803,"main":"Clouds","description":"曇りがち","icon":"04n"}],"base":"stations","main":{"temp":17.48,"feels_like":16.88,"temp_min":15.97,"temp_max":18.13,"pressure":1015,"humidity":61},"visibility":10000,"wind":{"speed":6.17,"deg":200},"clouds":{"all":75},"dt":1650359863,"sys":{"type":2,"id":2038398,"country":"JP","sunrise":1650312233,"sunset":1650359798},"timezone":32400,"id":1850147,"name":"東京都","cod":200}
      """;
      final mockWeather = CurrentWeather.fromJson(json.decode(jsonStr));
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
      expect(viewModel.weather?.weather.main, "Clouds");
      expect(viewModel.weather?.main.minTemperature, 15.97);
      expect(viewModel.weather?.main.maxTemperature, 18.13);
      expect(viewModel.loading, false);
      expect(viewModel.error.hasValue, false);
      // setup mock api
      final mockException = APIException("test");
      when(api.fetch(any)).thenThrow(mockException);
      // reload
      reload = viewModel.reload();
      expect(viewModel.loading, true);
      await reload;
      // check
      expect(viewModel.weather?.weather.main, "Clouds");
      expect(viewModel.weather?.main.minTemperature, 15.97);
      expect(viewModel.weather?.main.maxTemperature, 18.13);
      expect(viewModel.loading, false);
      expect(viewModel.error.hasValue, true);
      expect(viewModel.error.peek, mockException);
      // verify
      verify(api.fetch(any)).called(2);
    });
  });
}
