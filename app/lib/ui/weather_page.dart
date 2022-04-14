import 'dart:math';

import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_flutter/data/model/weather.dart';
import 'package:hello_flutter/gen/assets.gen.dart';
import 'package:hello_flutter/l10n/l10n.dart';
import 'package:hello_flutter/ui/empty_page.dart';
import 'package:hello_flutter/ui/error_dialog.dart';
import 'package:hello_flutter/ui/event.dart';
import 'package:hello_flutter/ui/weather_viewmodel.dart';

class WeatherPage extends ConsumerStatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _WeatherPageState();
  }
}

class _WeatherPageState extends ConsumerState<WeatherPage> {
  @override
  Widget build(BuildContext context) {
    ref.listenEvent<UnknownException>(
        weatherViewModelProvider.select((value) => value.error), (error) async {
      debugPrint("error callback: $error");
      var result = await showDialog<ErrorDialogResult?>(
        context: context,
        builder: (_) => const ErrorDialog(),
      );
      if (result == ErrorDialogResult.reload) {
        ref.read(weatherViewModelProvider).reload();
      }
    });
    debugPrint("WeatherPage build");
    final l10n = L10n.of(context)!;
    return Scaffold(
        appBar: AppBar(
          title: Text(l10n.appName),
        ),
        body: Stack(children: [
          LayoutBuilder(builder: (context, constraints) {
            const minContentHeight = 16.0 + 48.0; // text + button
            const minContentWidth = 200.0; // button, text * 2
            var contentWidth = 0.0;
            var imageSize = 0.0;
            var verticalButtonMargin = 0.0;
            var verticalContentMargin = 0.0;
            if (constraints.maxWidth * 0.5 + minContentHeight <=
                constraints.maxHeight) {
              contentWidth = constraints.maxWidth * 0.5;
              imageSize = constraints.maxWidth * 0.5;
              if (imageSize + minContentHeight + 80 <= constraints.maxHeight) {
                verticalButtonMargin = 80;
                verticalContentMargin =
                    (constraints.maxHeight - imageSize - minContentHeight) / 2;
              } else {
                verticalButtonMargin =
                    constraints.maxHeight - imageSize - minContentHeight;
                verticalContentMargin = 0;
              }
            } else {
              contentWidth = max(
                  minContentWidth, constraints.maxHeight - minContentHeight);
              imageSize = constraints.maxHeight - (16 + 48);
              verticalButtonMargin = 0;
              verticalContentMargin = 0;
            }
            return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(
                  width: contentWidth,
                  height: constraints.maxHeight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: verticalContentMargin,
                      ),
                      Consumer(builder: (ctx, ref, _) {
                        debugPrint("render: weather, temperature");
                        var weather = ref.watch(weatherViewModelProvider
                            .select((value) => value.weather));
                        return Column(children: [
                          Container(
                              width: imageSize,
                              height: imageSize,
                              padding: const EdgeInsets.all(5.0),
                              child: _getWeatherImage(weather?.weather)),
                          Row(children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                  weather?.minTemp.formatTemperature() ?? "",
                                  textAlign: TextAlign.center,
                                  key: const Key("weather_page_text_min_temp"),
                                  style: const TextStyle(color: Colors.blue)),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                  weather?.maxTemp.formatTemperature() ?? "",
                                  textAlign: TextAlign.center,
                                  key: const Key("weather_page_text_max_temp"),
                                  style: const TextStyle(color: Colors.red)),
                            ),
                          ]),
                        ]);
                      }),
                      Container(
                        height: verticalButtonMargin,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Center(
                              child: ElevatedButton(
                                onPressed:
                                    ref.read(weatherViewModelProvider).reload,
                                child: Text(l10n.buttonReload),
                                key: const Key("weather_page_button_reload"),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Center(
                              child: ElevatedButton(
                                onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) =>
                                            EmptyPage(title: l10n.appName))),
                                child: Text(l10n.buttonNext),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  )),
            ]);
          }),
          Consumer(builder: (ctx, ref, _) {
            final isLoading = ref.watch(
                weatherViewModelProvider.select((value) => value.loading));
            debugPrint("render: progress");
            return Visibility(
              visible: isLoading,
              child: Container(
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
                color: Colors.black.withOpacity(0.6),
              ),
            );
          }),
        ]));
  }
}

Widget _getWeatherImage(Weather? value) {
  switch (value) {
    case Weather.sunny:
      return Assets.images.sunny.svg(
        color: Colors.red,
      );
    case Weather.cloudy:
      return Assets.images.cloudy.svg(
        color: Colors.grey,
      );
    case Weather.rainy:
      return Assets.images.rainy.svg(
        color: Colors.blueAccent,
      );
    default:
      return const FittedBox(
        fit: BoxFit.fitWidth,
        child: Icon(
          Icons.image_not_supported_outlined,
          color: Colors.blueGrey,
        ),
      );
  }
}
