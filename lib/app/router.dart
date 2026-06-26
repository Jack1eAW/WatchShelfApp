import 'dart:ui';

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

class AppTabScaffold extends StatefulWidget {
  const AppTabScaffold({super.key});

  @override
  State<AppTabScaffold> createState() => _AppTabScaffoldState();
}

class _AppTabScaffoldState extends State<AppTabScaffold> {
  var _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Stack(
        children: [
          Positioned.fill(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                HeroMode(
                  enabled: _selectedIndex == 0,
                  child: const DiscoverScreen(),
                ),
                HeroMode(
                  enabled: _selectedIndex == 1,
                  child: const WatchlistScreen(),
                ),
                HeroMode(
                  enabled: _selectedIndex == 2,
                  child: const AboutScreen(),
                ),
              ],
            ),
          ),
          Positioned(
            left: 18,
            right: 18,
            bottom: MediaQuery.paddingOf(context).bottom + 10,
            child: _LiquidGlassTabBar(
              selectedIndex: _selectedIndex,
              onSelected: (index) => setState(() => _selectedIndex = index),
            ),
          ),
        ],
      ),
    );
  }
}

class _LiquidGlassTabBar extends StatelessWidget {
  const _LiquidGlassTabBar({
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 26, sigmaY: 26),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: CupertinoColors.systemBackground.withValues(alpha: 0.58),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: CupertinoColors.white.withValues(alpha: 0.72),
              width: 0.8,
            ),
            boxShadow: [
              BoxShadow(
                color: CupertinoColors.black.withValues(alpha: 0.12),
                blurRadius: 28,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(7),
            child: Row(
              children: [
                _LiquidGlassTabItem(
                  label: 'Discover',
                  icon: CupertinoIcons.film,
                  activeIcon: CupertinoIcons.film_fill,
                  selected: selectedIndex == 0,
                  onTap: () => onSelected(0),
                ),
                _LiquidGlassTabItem(
                  label: 'Watchlist',
                  icon: CupertinoIcons.bookmark,
                  activeIcon: CupertinoIcons.bookmark_fill,
                  selected: selectedIndex == 1,
                  onTap: () => onSelected(1),
                ),
                _LiquidGlassTabItem(
                  label: 'About',
                  icon: CupertinoIcons.info_circle,
                  activeIcon: CupertinoIcons.info_circle_fill,
                  selected: selectedIndex == 2,
                  onTap: () => onSelected(2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LiquidGlassTabItem extends StatelessWidget {
  const _LiquidGlassTabItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final IconData activeIcon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final activeColor = CupertinoTheme.of(context).primaryColor;
    return Expanded(
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        onPressed: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOutCubic,
          height: 50,
          decoration: BoxDecoration(
            color: selected
                ? CupertinoColors.white.withValues(alpha: 0.72)
                : CupertinoColors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: selected
                  ? CupertinoColors.white.withValues(alpha: 0.82)
                  : CupertinoColors.white.withValues(alpha: 0.18),
              width: 0.7,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                selected ? activeIcon : icon,
                size: 21,
                color: selected ? activeColor : CupertinoColors.secondaryLabel,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected
                      ? activeColor
                      : CupertinoColors.secondaryLabel,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
