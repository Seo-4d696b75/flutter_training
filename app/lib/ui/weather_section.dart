import 'package:api/model/current_weather.dart';
import 'package:api/model/weather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_flutter/gen/assets.gen.dart';
import 'package:intl/intl.dart';

class WeatherSection extends ConsumerWidget {
  const WeatherSection({
    Key? key,
    required this.imageSize,
    required this.weatherProvider,
  }) : super(key: key);

  final double imageSize;
  final ProviderListenable<CurrentWeather?> weatherProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint("render: weather, temperature");
    var weather = ref.watch(weatherProvider);
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
          child: getWeatherImage(weather?.weather)),
      Row(children: [
        Expanded(
          flex: 1,
          child: Text(formatTemperature(weather?.main.minTemperature),
              textAlign: TextAlign.center,
              key: const Key("weather_page_text_min_temp"),
              style: const TextStyle(color: Colors.blue)),
        ),
        Expanded(
          flex: 1,
          child: Text(formatTemperature(weather?.main.maxTemperature),
              textAlign: TextAlign.center,
              key: const Key("weather_page_text_max_temp"),
              style: const TextStyle(color: Colors.red)),
        ),
      ]),
    ]);
  }
}

Widget getWeatherImage(Weather? value) {
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

String formatTemperature(double? value) {
  var f = NumberFormat("0.0℃");
  return value == null ? "" : f.format(value);
}
