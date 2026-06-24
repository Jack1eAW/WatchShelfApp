import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../details/presentation/details_screen.dart';
import '../../ratings/data/rating_providers.dart';
import '../data/media_providers.dart';
import '../domain/media_item.dart';
import 'async_state_view.dart';
import 'media_list_tile.dart';

class DiscoverScreen extends ConsumerWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaState = ref.watch(discoverMediaProvider);
    final ratings = ref.watch(ratingsControllerProvider).value ?? {};

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Discover')),
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
                child: CupertinoSearchTextField(
                  placeholder: 'Search movies and shows',
                  onChanged: (value) {
                    ref.read(searchQueryProvider.notifier).setQuery(value);
                  },
                ),
              ),
            ),
            mediaState.when(
              data: (items) {
                if (items.isEmpty) {
                  return const SliverFillRemaining(
                    child: EmptyView(
                      title: 'No results',
                      message: 'Try searching for another title or genre.',
                    ),
                  );
                }

                return SliverList.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return MediaListTile(
                      item: item,
                      personalRating: ratings[item.storageKey],
                      onTap: () => _openDetails(context, item),
                    );
                  },
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
