import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hello_flutter/data/weather.dart';
import 'package:hello_flutter/ui/empty_page.dart';
import 'package:hello_flutter/ui/error_dialog.dart';
import 'package:hello_flutter/ui/event.dart';
import 'package:hello_flutter/ui/weather_viewmodel.dart';

class WeatherPage extends ConsumerStatefulWidget {
  const WeatherPage({Key? key, required this.title}) : super(key: key);

  final String title;

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
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Spacer(flex: 1),
          Expanded(
              flex: 2,
              child: Column(children: [
                const Spacer(flex: 1),
                Consumer(builder: (ctx, ref, _) {
                  debugPrint("render: weather, temperature");
                  var weather = ref.watch(weatherViewModelProvider
                      .select((value) => value.weather));
                  var minTemp = ref.watch(weatherViewModelProvider
                      .select((value) => value.minTemp));
                  var maxTemp = ref.watch(weatherViewModelProvider
                      .select((value) => value.maxTemp));
                  return Column(children: [
                    AspectRatio(
                        aspectRatio: 1.0, child: _getWeatherImage(weather)),
                    Row(children: [
                      Expanded(
                        flex: 1,
                        child: Text(minTemp != null ? "$minTemp℃" : "",
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.blue)),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(maxTemp != null ? "$maxTemp℃" : "",
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red)),
                      ),
                    ]),
                  ]);
                }),
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
                                  onPressed:
                                      ref.read(weatherViewModelProvider).reload,
                                  child: const Text("reload"),
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
                                              EmptyPage(title: widget.title))),
                                  child: const Text("next"),
                                ),
                              ),
                            )
                          ],
                        ),
                      ]),
                ),
              ])),
          const Spacer(flex: 1),
        ]));
  }
}

Widget _getWeatherImage(Weather? value) {
  switch (value) {
    case Weather.sunny:
      return SvgPicture.asset(
        "lib/assets/sunny.svg",
        color: Colors.red,
      );
    case Weather.cloudy:
      return SvgPicture.asset(
        "lib/assets/cloudy.svg",
        color: Colors.grey,
      );
    case Weather.rainy:
      return SvgPicture.asset(
        "lib/assets/rainy.svg",
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
