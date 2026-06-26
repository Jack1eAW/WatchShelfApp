import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../details/presentation/details_screen.dart';
import '../../discover/domain/media_item.dart';
import '../../discover/presentation/async_state_view.dart';
import '../../discover/presentation/media_list_tile.dart';
import '../../ratings/data/rating_providers.dart';
import '../data/watchlist_providers.dart';

class WatchlistScreen extends ConsumerWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsState = ref.watch(watchlistItemsProvider);
    final ratings = ref.watch(ratingsControllerProvider).value ?? {};

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Watchlist')),
      child: SafeArea(
        bottom: false,
        child: itemsState.when(
          data: (items) {
            if (items.isEmpty) {
              return const EmptyView(
                title: 'Your shelf is empty',
                message: 'Save a movie or show from Discover to see it here.',
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 116),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return MediaListTile(
                  item: item,
                  personalRating: ratings[item.storageKey],
                  onTap: () => _openDetails(context, item),
                  trailing: CupertinoButton(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(36, 36),
                    onPressed: () {
                      ref
                          .read(watchlistControllerProvider.notifier)
                          .remove(item.storageKey);
                    },
                    child: const Icon(CupertinoIcons.xmark_circle_fill),
                  ),
                );
              },
            );
          },
          error: (error, stackTrace) => ErrorStateView(
            message: 'Unable to load your watchlist.',
            onRetry: () => ref.invalidate(watchlistItemsProvider),
          ),
          loading: () => const LoadingView(),
        ),
      ),
    );
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
