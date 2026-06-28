import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../details/presentation/details_screen.dart';
import '../../ratings/data/rating_providers.dart';
import '../data/media_providers.dart';
import '../domain/media_item.dart';
import 'async_state_view.dart';
import 'media_list_tile.dart';

class DiscoverScreen extends ConsumerStatefulWidget {
  const DiscoverScreen({super.key});

  @override
  ConsumerState<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends ConsumerState<DiscoverScreen> {
  late final ScrollController _scrollController;
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaState = ref.watch(discoverMediaProvider);
    final ratings = ref.watch(ratingsControllerProvider).value ?? {};
    final selectedType = ref.watch(selectedDiscoverTypeProvider);

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFF7FA),
              CupertinoColors.systemGroupedBackground,
              Color(0xFFF2F8F8),
            ],
            stops: [0, 0.48, 1],
          ),
        ),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            CupertinoSliverNavigationBar(
              largeTitle: const Text('Discover'),
              border: null,
              backgroundColor: CupertinoColors.systemBackground.withValues(
                alpha: 0.72,
              ),
              stretch: true,
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 8, 14, 12),
                child: _DiscoverControls(
                  selectedType: selectedType,
                  onSearchChanged: _onSearchChanged,
                  onTypeChanged: (value) {
                    ref
                        .read(selectedDiscoverTypeProvider.notifier)
                        .select(value);
                    _scrollController.jumpTo(0);
                  },
                ),
              ),
            ),
            mediaState.when(
              data: (discoverState) {
                final items = discoverState.items;
                if (items.isEmpty) {
                  return SliverFillRemaining(
                    child: EmptyView(
                      title: discoverState.query.isEmpty
                          ? 'Nothing trending yet'
                          : 'No results',
                      message: discoverState.query.isEmpty
                          ? 'Try again in a moment.'
                          : 'Try another title, creator, or genre.',
                    ),
                  );
                }

                return SliverMainAxisGroup(
                  slivers: [
                    SliverList.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return MediaListTile(
                          item: item,
                          personalRating: ratings[item.storageKey],
                          onTap: () => _openDetails(context, item),
                        );
                      },
                    ),
                    SliverToBoxAdapter(
                      child: _LoadMoreFooter(state: discoverState),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 108)),
                  ],
                );
              },
              error: (error, stackTrace) => SliverFillRemaining(
                child: ErrorStateView(
                  message: 'Unable to load media right now.',
                  onRetry: () => ref.invalidate(discoverMediaProvider),
                ),
              ),
              loading: () => const SliverFillRemaining(child: LoadingView()),
            ),
          ],
        ),
      ),
    );
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 350), () {
      if (!mounted) {
        return;
      }
      ref.read(searchQueryProvider.notifier).setQuery(value);
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
    });
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final position = _scrollController.position;
    final distanceToEnd = position.maxScrollExtent - position.pixels;
    if (distanceToEnd < 360) {
      ref.read(discoverMediaProvider.notifier).loadNextPage();
    }
  }

  void _openDetails(BuildContext context, MediaItem item) {
    context.pushNamed(
      DetailsScreen.routeName,
      pathParameters: {
        'mediaType': item.mediaType.wireName,
        'id': '${item.id}',
      },
    );
  }
}

class _DiscoverControls extends StatelessWidget {
  const _DiscoverControls({
    required this.selectedType,
    required this.onSearchChanged,
    required this.onTypeChanged,
  });

  final MediaType selectedType;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<MediaType> onTypeChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.black.withValues(alpha: 0.08),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: CupertinoColors.systemBackground.withValues(alpha: 0.68),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: CupertinoColors.white.withValues(alpha: 0.74),
                width: 0.8,
              ),
            ),
            child: Column(
              children: [
                CupertinoSearchTextField(
                  placeholder: 'Search movies and shows',
                  backgroundColor: CupertinoColors.systemGrey6.withValues(
                    alpha: 0.72,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 11,
                  ),
                  onChanged: onSearchChanged,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: CupertinoSlidingSegmentedControl<MediaType>(
                    groupValue: selectedType,
                    backgroundColor: CupertinoColors.systemGrey5.withValues(
                      alpha: 0.56,
                    ),
                    thumbColor: CupertinoColors.systemBackground.withValues(
                      alpha: 0.92,
                    ),
                    children: const {
                      MediaType.movie: Padding(
                        padding: EdgeInsets.symmetric(vertical: 7),
                        child: Text('Movies'),
                      ),
                      MediaType.tv: Padding(
                        padding: EdgeInsets.symmetric(vertical: 7),
                        child: Text('TV Shows'),
                      ),
                    },
                    onValueChanged: (value) {
                      if (value != null) {
                        onTypeChanged(value);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoadMoreFooter extends StatelessWidget {
  const _LoadMoreFooter({required this.state});

  final DiscoverMediaState state;

  @override
  Widget build(BuildContext context) {
    if (state.isLoadingMore) {
      return const Shimmer(
        child: Column(
          children: [MediaListSkeletonTile(), MediaListSkeletonTile()],
        ),
      );
    }

    if (!state.hasMore) {
      return const SizedBox(height: 18);
    }

    return const SizedBox(height: 44);
  }
}
