import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hello_flutter/weather.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  Weather? _weather;
  final _api = YumemiWeather();

  void _fetchWeather() {
    setState(() {
      final value = parseWeather(_api.fetchSimpleWeather());
      _weather = value;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                      aspectRatio: 1.0, child: _getWeatherImage(_weather)),
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
                            const Expanded(
                              flex: 1,
                              child: Center(
                                child: ElevatedButton(
                                  onPressed: null,
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
