import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_flutter/l10n/l10n.dart';
import 'package:hello_flutter/ui/weather_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // このwidgetはアプリのroot UI要素です
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
        child: MaterialApp(
            title: "droidtraining",
            theme: ThemeData(
              // このアプリのテーマ（アプリ全般に適用させる統一的なUIデザインの設定情報）.
              primarySwatch: Colors.blue,
            ),
            localizationsDelegates: L10n.localizationsDelegates,
            supportedLocales: L10n.supportedLocales,
            home: const WeatherPage()));
  }
}
