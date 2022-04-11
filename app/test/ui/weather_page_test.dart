import 'package:api/api.dart';
import 'package:api/model/response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hello_flutter/data/strings.dart';
import 'package:hello_flutter/data/weather_api.dart';
import 'package:hello_flutter/data/weather_api_impl.dart';
import 'package:hello_flutter/ui/weather_page.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../data/weather_repository_test.mocks.dart';
import '../utils.dart';

@GenerateMocks([WeatherAPI])
void main() {
  const title = "test title";
  const keyMinTemp = Key("weather_page_text_min_temp");
  const keyMaxTemp = Key("weather_page_text_max_temp");
  const keyButtonReload = Key("weather_page_button_reload");
  const keyButtonDialogNegative = Key("error_dialog_button_negative");
  const keyButtonDialogPositive = Key("error_dialog_button_positive");
  final mockWeather = Response(
    weather: "sunny",
    maxTemp: 20,
    minTemp: 10,
    date: DateTime.now(),
  );
  group("reload", () {
    testWidgets("success", (tester) async {
      // TODO 現状だと縦長のレイアウトが必須
      tester.binding.window.physicalSizeTestValue = const Size(1080, 1920);

      final api = MockWeatherAPI();

      await tester.pumpWidget(ProviderScope(
        overrides: [
          weatherAPIProvider.overrideWithValue(api),
        ],
        child: const MaterialApp(
          title: title,
          home: WeatherPage(title: title),
        ),
      ));

      // check title
      expect(find.text(title), findsOneWidget);
      // not init yet
      expect(find.byKey(keyMinTemp), withText(""));
      expect(find.byKey(keyMaxTemp), withText(""));

      // setup mock api
      when(api.fetch(any)).thenReturn(mockWeather);

      // reload
      await tester.tap(find.byKey(keyButtonReload));
      await tester.pump();

      // check
      expect(find.byKey(keyMinTemp), withText("10℃"));
      expect(find.byKey(keyMaxTemp), withText("20℃"));
    });
    testWidgets("error - close", (tester) async {
      // TODO 現状だと縦長のレイアウトが必須
      tester.binding.window.physicalSizeTestValue = const Size(1080, 1920);

      final api = MockWeatherAPI();

      await tester.pumpWidget(ProviderScope(
        overrides: [
          weatherAPIProvider.overrideWithValue(api),
        ],
        child: const MaterialApp(
          title: title,
          home: WeatherPage(title: title),
        ),
      ));

      // setup mock
      final error = UnknownException("test");
      when(api.fetch(any)).thenThrow(error);

      // reload
      await tester.tap(find.byKey(keyButtonReload));
      await tester.pump();

      // check
      expect(find.byKey(keyMinTemp), withText(""));
      expect(find.byKey(keyMaxTemp), withText(""));
      expect(find.text(Strings.errorDialogMessage), findsOneWidget);

      // close
      await tester.tap(find.byKey(keyButtonDialogNegative));
      await tester.pump();

      // check
      expect(find.byKey(keyMinTemp), withText(""));
      expect(find.byKey(keyMaxTemp), withText(""));
      expect(find.text(Strings.errorDialogMessage), findsNothing);
    });
    testWidgets("error - close", (tester) async {
      // TODO 現状だと縦長のレイアウトが必須
      tester.binding.window.physicalSizeTestValue = const Size(1080, 1920);

      final api = MockWeatherAPI();

      await tester.pumpWidget(ProviderScope(
        overrides: [
          weatherAPIProvider.overrideWithValue(api),
        ],
        child: const MaterialApp(
          title: title,
          home: WeatherPage(title: title),
        ),
      ));

      // setup mock
      final error = UnknownException("test");
      when(api.fetch(any)).thenThrow(error);

      // reload
      await tester.tap(find.byKey(keyButtonReload));
      await tester.pump();

      // check
      expect(find.byKey(keyMinTemp), withText(""));
      expect(find.byKey(keyMaxTemp), withText(""));
      expect(find.text(Strings.errorDialogMessage), findsOneWidget);

      // setup mock
      when(api.fetch(any)).thenReturn(mockWeather);

      // reload
      await tester.tap(find.byKey(keyButtonDialogPositive));
      await tester.pump();

      // check
      expect(find.byKey(keyMinTemp), withText("10℃"));
      expect(find.byKey(keyMaxTemp), withText("20℃"));
      expect(find.text(Strings.errorDialogMessage), findsNothing);
    });
  });
}
