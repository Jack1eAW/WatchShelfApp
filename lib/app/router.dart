import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/details/presentation/details_screen.dart';
import '../features/discover/domain/media_item.dart';
import '../features/discover/presentation/discover_screen.dart';
import '../features/settings/presentation/about_screen.dart';
import '../features/watchlist/presentation/watchlist_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const AppTabScaffold(),
        routes: [
          GoRoute(
            path: 'details/:mediaType/:id',
            name: DetailsScreen.routeName,
            builder: (context, state) {
              final mediaType = MediaTypeX.fromWire(
                state.pathParameters['mediaType'] ?? 'movie',
              );
              final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
              return DetailsScreen(mediaId: id, mediaType: mediaType);
            },
          ),
        ],
      ),
    ],
  );
});

class AppTabScaffold extends StatelessWidget {
  const AppTabScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.film),
            activeIcon: Icon(CupertinoIcons.film_fill),
            label: 'Discover',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.bookmark),
            activeIcon: Icon(CupertinoIcons.bookmark_fill),
            label: 'Watchlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.info_circle),
            activeIcon: Icon(CupertinoIcons.info_circle_fill),
            label: 'About',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        return CupertinoTabView(
          builder: (context) {
            return switch (index) {
              0 => const DiscoverScreen(),
              1 => const WatchlistScreen(),
              _ => const AboutScreen(),
            };
          },
        );
      },
    );
  }
}
