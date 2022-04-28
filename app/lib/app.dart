import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hello_flutter/l10n/l10n.dart';
import 'package:hello_flutter/ui/list/weather_list_page.dart';
import 'package:hello_flutter/ui/select/weather_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // このwidgetはアプリのroot UI要素です
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp.router(
        title: "droidtraining",
        theme: ThemeData(
          // このアプリのテーマ（アプリ全般に適用させる統一的なUIデザインの設定情報）.
          primarySwatch: Colors.blue,
        ),
        localizationsDelegates: L10n.localizationsDelegates,
        supportedLocales: L10n.supportedLocales,
        routerDelegate: goRouter.routerDelegate,
        routeInformationParser: goRouter.routeInformationParser,
      ),
    );
  }
}

final goRouter = GoRouter(
  initialLocation: "/",
  routes: [
    GoRoute(
      name: "main",
      path: "/",
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: wrapWithLocale(const WeatherPage()),
      ),
    ),
    GoRoute(
      name: "list",
      path: "/list",
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: wrapWithLocale(const WeatherListPage()),
      ),
      routes: [
        GoRoute(
          name: "select",
          path: "select",
          pageBuilder: (context, state) => MaterialPage(
            key: state.pageKey,
            child: wrapWithLocale(const WeatherPage()),
          ),
        ),
      ],
    ),
  ],
);

final localeProvider = Provider<Locale>((_) => const Locale("ja"));

// MaterialAppの内側でないとlocale情報をcontextから読み出せない
Widget wrapWithLocale(Widget child) {
  return Builder(
    builder: (context) {
      var l10n = L10n.of(context)!;
      var locale = Locale(l10n.localeName);
      debugPrint("locale: $locale");
      return ProviderScope(
        child: child,
        overrides: [
          localeProvider.overrideWithValue(locale),
        ],
      );
    },
  );
}
