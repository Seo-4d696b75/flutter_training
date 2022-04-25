import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_flutter/app.dart';
import 'package:hello_flutter/l10n/l10n.dart';
import 'package:hello_flutter/ui/weather_list_tile.dart';
import 'package:hello_flutter/ui/weather_list_viewmodel.dart';
import 'package:hello_flutter/ui/weather_page.dart';

class WeatherListPage extends ConsumerWidget {
  const WeatherListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final indicator = GlobalKey<RefreshIndicatorState>();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      indicator.currentState?.show();
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
            return RefreshIndicator(
              child: ListView.builder(
                itemCount: list.length,
                physics: const AlwaysScrollableScrollPhysics(),
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
              ),
              onRefresh: () async {
                await ref.read(weatherListViewModelProvider).reload();
              },
              key: indicator,
            );
          }),
        ],
      ),
    );
  }
}
