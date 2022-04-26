import 'dart:math';

import 'package:api/open_weather_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hello_flutter/l10n/l10n.dart';
import 'package:hello_flutter/ui/error_dialog.dart';
import 'package:hello_flutter/ui/event.dart';
import 'package:hello_flutter/ui/loading_progress.dart';
import 'package:hello_flutter/ui/weather_section.dart';
import 'package:hello_flutter/ui/weather_viewmodel.dart';

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
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: contentWidth,
                  height: constraints.maxHeight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: verticalContentMargin,
                      ),
                      WeatherSection(
                        imageSize: imageSize,
                        weatherProvider: weatherViewModelProvider
                            .select((value) => value.weather),
                      ),
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
                                onPressed: () {
                                  GoRouter.of(context).go("/list");
                                },
                                child: Text(l10n.buttonNext),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
          LoadingProgress(
            loadingProvider:
                weatherViewModelProvider.select((value) => value.loading),
          ),
        ]));
  }
}
