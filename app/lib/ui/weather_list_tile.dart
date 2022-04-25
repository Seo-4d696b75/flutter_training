import 'package:api/model/current_weather.dart';
import 'package:api/open_weather_map.dart';
import 'package:flutter/material.dart';
import 'package:hello_flutter/data/stateful_value.dart';
import 'package:hello_flutter/l10n/l10n.dart';
import 'package:hello_flutter/ui/weather_section.dart';

class WeatherListTile extends StatelessWidget {
  const WeatherListTile({
    Key? key,
    required this.index,
    required this.data,
    required this.onSelectedCallback,
    required this.onItemReloadCallback,
  }) : super(key: key);

  final StatefulValue<CurrentWeather, APIException> data;
  final int index;
  final void Function() onSelectedCallback;
  final void Function() onItemReloadCallback;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context)!;
    return data.when(
      data: (weather) => ListTile(
        leading: SizedBox(
          width: 80,
          height: 80,
          child: getWeatherImage(weather.weather),
        ),
        title: Text(weather.cityName),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              formatTemperature(weather.main.minTemperature),
              style: const TextStyle(color: Colors.blue),
            ),
            const Text("/"),
            Text(
              formatTemperature(weather.main.maxTemperature),
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
        onTap: onSelectedCallback,
      ),
      error: (error) => ListTile(
        leading: const SizedBox(
          width: 80,
          height: 80,
          child: FittedBox(
            fit: BoxFit.fitHeight,
            child: Icon(
              Icons.error_outline,
              color: Colors.blueGrey,
            ),
          ),
        ),
        title: Text(l10n.errorListTileTitle),
        subtitle: Text(l10n.errorListTileSubTitle),
        trailing: IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: onItemReloadCallback,
          iconSize: 30,
        ),
      ),
      none: () => ListTile(
        leading: const SizedBox(
          width: 80,
          height: 80,
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Icon(
              Icons.image_not_supported_outlined,
              color: Colors.blueGrey,
            ),
          ),
        ),
        title: Text(l10n.noneListTileTitle),
        subtitle: Text(l10n.noneListTileSubTitle),
        trailing: IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: onItemReloadCallback,
          iconSize: 30,
        ),
      ),
    );
  }
}
