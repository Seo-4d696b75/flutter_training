import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hello_flutter/l10n/l10n.dart';
import 'package:hello_flutter/ui/list/weather_list_tile.dart';
import 'package:hello_flutter/ui/list/weather_list_viewmodel.dart';

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
              weatherListViewModelProvider.select((value) => value.list),
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
                    ref
                        .read(weatherListViewModelProvider.notifier)
                        .selectCity(idx);
                    GoRouter.of(ctx).go("/list/select");
                  },
                  onItemReloadCallback: () {
                    ref.read(weatherListViewModelProvider.notifier).reload(
                          index: idx,
                        );
                  },
                ),
              ),
              onRefresh: () async {
                await ref.read(weatherListViewModelProvider.notifier).reload();
              },
              key: indicator,
            );
          }),
        ],
      ),
    );
  }
}
