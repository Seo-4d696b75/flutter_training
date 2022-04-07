import 'package:flutter/material.dart';
import 'package:hello_flutter/weather_page.dart';

import 'strings.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // このwidgetはアプリのroot UI要素です
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Strings.appName,
      theme: ThemeData(
        // このアプリのテーマ（アプリ全般に適用させる統一的なUIデザインの設定情報）.
        primarySwatch: Colors.blue,
      ),
      home: const WeatherPage(title: Strings.appName),
    );
  }
}
