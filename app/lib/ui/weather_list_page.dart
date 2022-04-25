import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_flutter/app.dart';
import 'package:hello_flutter/l10n/l10n.dart';
import 'package:hello_flutter/ui/loading_progress.dart';
import 'package:hello_flutter/ui/weather_list_tile.dart';
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
              itemBuilder: (ctx, idx) => WeatherListTile(
                index: idx,
                data: list[idx],
                onSelectedCallback: () {
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
                onItemReloadCallback: () {
                  ref.read(weatherListViewModelProvider).reload(index: idx);
                },
              ),
            );
          }),
          LoadingProgress(
            loadingProvider:
                weatherListViewModelProvider.select((value) => value.loading),
          ),
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
