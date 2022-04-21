import 'dart:math';

import 'package:api/model/weather.dart';
import 'package:api/open_weather_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_flutter/gen/assets.gen.dart';
import 'package:hello_flutter/l10n/l10n.dart';
import 'package:hello_flutter/ui/empty_page.dart';
import 'package:hello_flutter/ui/error_dialog.dart';
import 'package:hello_flutter/ui/event.dart';
import 'package:hello_flutter/ui/weather_viewmodel.dart';
import 'package:intl/intl.dart';

class WeatherPage extends ConsumerWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listenEvent<APIException>(
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
            // maxWidth > 200 && maxHeight > 100 以上を想定
            // 任意のアスペクト比に対応
            const textHeight = 18.0 + 28.0;
            const buttonHeight = 48.0;
            const minContentWidth = 200.0; // button, text * 2
            var contentWidth = 0.0;
            var imageSize = 0.0;
            var verticalButtonMargin = 0.0;
            var verticalContentMargin = 0.0;
            if (constraints.maxWidth * 0.5 + textHeight + buttonHeight <=
                constraints.maxHeight) {
              // 画像の大きさ = width/2 が設定可能
              contentWidth = constraints.maxWidth * 0.5;
              imageSize = constraints.maxWidth * 0.5;
              if (imageSize + textHeight + (buttonHeight + 80) * 2 <=
                  constraints.maxHeight) {
                // 元の指示通りのレイアウトが可能
                // https://github.com/yumemi/droid-training/blob/master/Documentation/Layout.md
                verticalContentMargin =
                    (constraints.maxHeight - imageSize - textHeight) / 2;
                verticalButtonMargin = 80;
              } else if (imageSize + textHeight + buttonHeight * 2 <=
                  constraints.maxHeight) {
                // 高さ不十分
                // button - text 間の80pxを縮小させる
                verticalContentMargin =
                    (constraints.maxHeight - imageSize - textHeight) / 2;
                verticalButtonMargin = verticalContentMargin - buttonHeight;
              } else {
                // 高さがさらに不十分
                // button - text 間を0px, 画像上端のmarginを縮小させる
                verticalContentMargin = constraints.maxHeight -
                    imageSize -
                    textHeight -
                    buttonHeight;
                verticalButtonMargin = 0;
              }
            } else {
              // 高さ不十分
              // 画像サイズを縮小 ただしbutton,text表示のため最小限の幅は確保
              contentWidth = max(
                minContentWidth,
                constraints.maxHeight - textHeight - buttonHeight,
              );
              imageSize = constraints.maxHeight - textHeight - buttonHeight;
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
                          Center(
                            child: Text(
                              weather?.cityName ?? "",
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                          Container(
                              width: imageSize,
                              height: imageSize,
                              padding: const EdgeInsets.all(5.0),
                              child: _getWeatherImage(weather?.weather)),
                          Row(children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                  formatTemperature(
                                      weather?.main.minTemperature),
                                  textAlign: TextAlign.center,
                                  key: const Key("weather_page_text_min_temp"),
                                  style: const TextStyle(color: Colors.blue)),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                  formatTemperature(
                                      weather?.main.maxTemperature),
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

String formatTemperature(double? value) {
  var f = NumberFormat("0.0℃");
  return value == null ? "" : f.format(value);
}

Widget _getWeatherImage(Weather? value) {
  switch (value?.icon) {
    case WeatherIcon.clearSky:
      return Assets.images.clearSky.svg();
    case WeatherIcon.fewClouds:
      return Assets.images.fewClouds.svg();
    case WeatherIcon.scatteredClouds:
      return Assets.images.scatteredClouds.svg();
    case WeatherIcon.brokenClouds:
      return Assets.images.brokenClouds.svg();
    case WeatherIcon.showerRain:
    case WeatherIcon.rain:
      return Assets.images.rain.svg();
    case WeatherIcon.thunderstorm:
      return Assets.images.thunderstorm.svg();
    case WeatherIcon.snow:
      return Assets.images.snow.svg();
    case WeatherIcon.mist:
      return Assets.images.mist.svg();
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
