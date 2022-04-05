import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      home: const MyHomePage(title: Strings.appName),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Spacer(flex: 1),
          Expanded(
              flex: 2,
              child: Column(children: [
                const Spacer(flex: 1),
                Column(children: [
                  AspectRatio(
                      aspectRatio: 1.0,
                      child: SvgPicture.asset(
                        "lib/assets/sunny.svg",
                        color: Colors.red,
                      )),
                  Row(children: const [
                    Expanded(
                      flex: 1,
                      child: Text("text", textAlign: TextAlign.center),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text("text", textAlign: TextAlign.center),
                    )
                  ])
                ]),
                Expanded(
                  flex: 1,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(height: 80),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Center(
                                child: ElevatedButton(
                                  onPressed: () => {},
                                  child: const Text("button"),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Center(
                                child: ElevatedButton(
                                  onPressed: () => {},
                                  child: const Text("button"),
                                ),
                              ),
                            )
                          ],
                        )
                      ]),
                )
              ])),
          const Spacer(flex: 1),
        ]));
  }
}
