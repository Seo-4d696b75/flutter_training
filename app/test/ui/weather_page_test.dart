import 'dart:convert';

import 'package:api/model/current_weather.dart';
import 'package:api/open_weather_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hello_flutter/data/weather_api.dart';
import 'package:hello_flutter/data/weather_api_impl.dart';
import 'package:hello_flutter/l10n/l10n.dart';
import 'package:hello_flutter/ui/weather_page.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../data/weather_repository_test.mocks.dart';
import '../utils.dart';

@GenerateMocks([WeatherAPI])
void main() {
  const title = "droidtraining";
  const keyMinTemp = Key("weather_page_text_min_temp");
  const keyMaxTemp = Key("weather_page_text_max_temp");
  const keyButtonReload = Key("weather_page_button_reload");
  const keyDialogTitle = Key("error_dialog_text_title");
  const keyButtonDialogNegative = Key("error_dialog_button_negative");
  const keyButtonDialogPositive = Key("error_dialog_button_positive");

  const jsonStr = """
          {"coord":{"lon":139.6917,"lat":35.6895},"weather":[{"id":803,"main":"Clouds","description":"曇りがち","icon":"04n"}],"base":"stations","main":{"temp":17.48,"feels_like":16.88,"temp_min":15.97,"temp_max":18.13,"pressure":1015,"humidity":61},"visibility":10000,"wind":{"speed":6.17,"deg":200},"clouds":{"all":75},"dt":1650359863,"sys":{"type":2,"id":2038398,"country":"JP","sunrise":1650312233,"sunset":1650359798},"timezone":32400,"id":1850147,"name":"東京都","cod":200}
      """;
  final mockWeather = CurrentWeather.fromJson(json.decode(jsonStr));

  group("reload", () {
    final api = MockWeatherAPI();

    Future<void> _setupWidget(WidgetTester tester, bool portrait) async {
      if (portrait) {
        tester.binding.window.physicalSizeTestValue = const Size(1080, 1920);
      } else {
        tester.binding.window.physicalSizeTestValue = const Size(1920, 1080);
      }
      await tester.pumpWidget(ProviderScope(
        overrides: [
          weatherAPIProvider.overrideWithValue(api),
        ],
        child: const MaterialApp(
          title: title,
          home: WeatherPage(),
          localizationsDelegates: L10n.localizationsDelegates,
          supportedLocales: L10n.supportedLocales,
        ),
      ));
    }

    void _checkWeather(CurrentWeather? weather, bool dialogShown) {
      // check title
      expect(find.text(title), findsOneWidget);
      // not init yet
      expect(
        find.byKey(keyMinTemp),
        withText(formatTemperature(weather?.main.minTemperature)),
      );
      expect(
        find.byKey(keyMaxTemp),
        withText(formatTemperature(weather?.main.maxTemperature)),
      );
      // no progress indicator shown
      expect(
        find.byWidgetPredicate((widget) => widget is CircularProgressIndicator),
        findsNothing,
      );
      // dialog
      expect(
        find.byKey(keyDialogTitle),
        dialogShown ? findsOneWidget : findsNothing,
      );
    }

    Future<void> _checkReloading(WidgetTester tester, bool throwError) async {
      // setup mock api
      var latch = Latch();
      when(api.fetch(any)).thenAnswer((_) async {
        await latch.wait;
        if (throwError) {
          throw APIException("test");
        }
        return mockWeather;
      });

      // reload
      await tester.tap(find.byKey(keyButtonReload));
      await tester.pump();
      // progress indicator shown while loading
      expect(
        find.byWidgetPredicate((widget) => widget is CircularProgressIndicator),
        findsOneWidget,
      );
      // after checking, be sure to complete api#fetch
      latch.complete();
      await tester.pumpAndSettle();
    }

    testWidgets("success", (tester) async {
      await _setupWidget(tester, true);
      _checkWeather(null, false);
      await _checkReloading(tester, false);
      _checkWeather(mockWeather, false);
    });

    testWidgets("success - landscape", (tester) async {
      await _setupWidget(tester, false);
      _checkWeather(null, false);
      await _checkReloading(tester, false);
      _checkWeather(mockWeather, false);
    });

    testWidgets("error - close", (tester) async {
      await _setupWidget(tester, true);
      _checkWeather(null, false);
      await _checkReloading(tester, true);
      _checkWeather(null, true);

      // close
      await tester.tap(find.byKey(keyButtonDialogNegative));
      await tester.pumpAndSettle();

      _checkWeather(null, false);
    });
    testWidgets("error - reload", (tester) async {
      await _setupWidget(tester, true);
      _checkWeather(null, false);
      await _checkReloading(tester, true);
      _checkWeather(null, true);

      // setup mock
      when(api.fetch(any)).thenAnswer((_) async => mockWeather);

      // reload
      await tester.tap(find.byKey(keyButtonDialogPositive));
      await tester.pumpAndSettle();

      _checkWeather(mockWeather, false);
    });
  });
}
