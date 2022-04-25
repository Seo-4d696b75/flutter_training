import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoadingProgress extends ConsumerWidget {
  const LoadingProgress({Key? key, required this.loadingProvider})
      : super(key: key);

  final ProviderListenable<bool> loadingProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(loadingProvider);
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
  }
}
