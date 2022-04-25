import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_flutter/app.dart';
import 'package:hello_flutter/l10n/l10n.dart';
import 'package:hello_flutter/ui/weather_list_viewmodel.dart';
import 'package:hello_flutter/ui/weather_page.dart';

class WeatherListPage extends ConsumerWidget {
  const WeatherListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      ref.read(weatherListViewModelProvider).reload();
    });
    debugPrint("WeatherListPage build");
    final l10n = L10n.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appName),
      ),
      body: Stack(
        children: [
          Consumer(builder: (ctx, ref, _) {
            final list = ref.watch(
              weatherListViewModelProvider.select((value) => value.weatherList),
            );
            debugPrint("render: weather list");
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (ctx, idx) {
                return list[idx].when(
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
                    onTap: () {
                      ref.read(weatherListViewModelProvider).selectCity(idx);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => wrapWithLocale(
                            const WeatherPage(),
                          ),
                        ),
                      );
                    },
                  ),
                  error: (error) => ListTile(
                    leading: SizedBox(
                      width: 80,
                      height: 80,
                      child: getWeatherImage(null),
                    ),
                    title: Text(l10n.errorListTileTitle),
                    subtitle: Text(l10n.errorListTileSubTitle),
                  ),
                  none: () => Container(
                    height: 0,
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
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.refresh),
        onPressed: () {
          ref.read(weatherListViewModelProvider).reload();
        },
      ),
    );
  }
}
