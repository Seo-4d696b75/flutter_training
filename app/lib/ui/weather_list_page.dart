import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_flutter/l10n/l10n.dart';
import 'package:hello_flutter/ui/weather_list_viewmodel.dart';
import 'package:hello_flutter/ui/weather_page.dart';

class WeatherListPage extends ConsumerWidget {
  const WeatherListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint("WeatherListPage build");
    final l10n = L10n.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appName),
      ),
      body: Stack(
        children: [
          Consumer(builder: (ctx, ref, _) {
            // reload data if needed
            ref.read(weatherListViewModelProvider).reload(lazy: true);
            final list = ref.watch(
              weatherListViewModelProvider.select((value) => value.weatherList),
            );
            debugPrint("render: weather list");
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (ctx, idx) {
                return list[idx].when(
                  success: (weather) => ListTile(
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
                  ),
                  failure: (error) => ListTile(
                    leading: SizedBox(
                      width: 80,
                      height: 80,
                      child: getWeatherImage(null),
                    ),
                    title: Text(l10n.errorListTileTitle),
                    subtitle: Text(l10n.errorListTileSubTitle),
                  ),
                );
              },
            );
          }),
          Consumer(builder: (ctx, ref, _) {
            final isLoading = ref.watch(
              weatherListViewModelProvider.select((value) => value.loading),
            );
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
        ],
      ),
    );
  }
}
