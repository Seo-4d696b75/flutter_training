import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hello_flutter/data/model/weather.dart';
import 'package:hello_flutter/data/model/weather_forecast.dart';
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
  final mockWeather = WeatherForecast(
    weather: Weather.sunny,
    maxTemp: 20,
    minTemp: 10,
    date: DateTime.now(),
  );

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

    void _checkWeather(WeatherForecast? weather, bool dialogShown) {
      // check title
      expect(find.text(title), findsOneWidget);
      // not init yet
      expect(
        find.byKey(keyMinTemp),
        withText(weather?.minTemp.formatTemperature() ?? ""),
      );
      expect(
        find.byKey(keyMaxTemp),
        withText(weather?.maxTemp.formatTemperature() ?? ""),
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
          throw UnknownException("test");
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
