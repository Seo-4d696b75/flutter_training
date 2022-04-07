import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hello_flutter/empty_page.dart';
import 'package:hello_flutter/error_dialog.dart';
import 'package:hello_flutter/weather.dart';

final weatherProvider = StateProvider<Weather?>((ref) => null);

class WeatherPage extends ConsumerStatefulWidget {
  const WeatherPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  ConsumerState<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends ConsumerState<WeatherPage> {
  final _api = YumemiWeather();

  void _fetchWeather() async {
    try {
      final value = parseWeather(_api.fetchThrowWeather());
      ref.read(weatherProvider.notifier).state = value;
    } on UnknownException {
      var result = await showDialog<ErrorDialogResult?>(
        context: context,
        builder: (_) => const ErrorDialog(),
      );
      if (result == ErrorDialogResult.reload) {
        _fetchWeather();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final weather = ref.watch(weatherProvider);
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
                Column(children: [
                  AspectRatio(
                      aspectRatio: 1.0, child: _getWeatherImage(weather)),
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
                                  onPressed: _fetchWeather,
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
                        )
                      ]),
                )
              ])),
          const Spacer(flex: 1),
        ]));
  }
}

Widget _getWeatherImage(Weather? value) {
  switch (value) {
    case Weather.Sunny:
      return SvgPicture.asset(
        "lib/assets/sunny.svg",
        color: Colors.red,
      );
    case Weather.Cloudy:
      return SvgPicture.asset(
        "lib/assets/cloudy.svg",
        color: Colors.grey,
      );
    case Weather.Rainy:
      return SvgPicture.asset(
        "lib/assets/rainy.svg",
        color: Colors.blueAccent,
      );
    default:
      return const Image(
          image: NetworkImage("https://storage.googleapis"
              ".com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png"));
  }
}
