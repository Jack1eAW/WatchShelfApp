import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router.dart';
import 'theme.dart';

class WatchShelfApp extends ConsumerWidget {
  const WatchShelfApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return CupertinoApp.router(
      title: 'WatchShelf',
      debugShowCheckedModeBanner: false,
      theme: WatchShelfTheme.light,
      routerConfig: router,
    );
  }
}
