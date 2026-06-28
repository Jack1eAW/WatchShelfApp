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
            left: 12,
            right: 12,
            bottom: MediaQuery.paddingOf(context).bottom + 6,
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
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.black.withValues(alpha: 0.16),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: CupertinoColors.systemBackground.withValues(alpha: 0.72),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: CupertinoColors.white.withValues(alpha: 0.68),
                width: 0.8,
              ),
            ),
            child: SizedBox(
              height: 62,
              child: Row(
                children: [
                  _LiquidGlassTabItem(
                    label: 'Discover',
                    icon: CupertinoIcons.play_circle,
                    activeIcon: CupertinoIcons.play_circle_fill,
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
    const activeColor = CupertinoColors.systemPink;
    return Expanded(
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        onPressed: onTap,
        child: Semantics(
          selected: selected,
          label: '$label tab',
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 34,
                height: 30,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedScale(
                      scale: selected ? 1 : 0.72,
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      child: AnimatedOpacity(
                        opacity: selected ? 1 : 0,
                        duration: const Duration(milliseconds: 180),
                        child: Container(
                          width: 32,
                          height: 28,
                          decoration: BoxDecoration(
                            color: activeColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: CupertinoColors.white.withValues(
                                alpha: 0.62,
                              ),
                              width: 0.6,
                            ),
                          ),
                        ),
                      ),
                    ),
                    AnimatedScale(
                      scale: selected ? 1.06 : 1,
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutBack,
                      child: Icon(
                        selected ? activeIcon : icon,
                        size: 22,
                        color: selected
                            ? activeColor
                            : CupertinoColors.secondaryLabel,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 1),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10.5,
                  letterSpacing: 0,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
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
