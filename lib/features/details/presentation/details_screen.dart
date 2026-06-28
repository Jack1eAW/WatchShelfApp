import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../discover/data/media_providers.dart';
import '../../discover/domain/media_item.dart';
import '../../discover/presentation/async_state_view.dart';
import '../../ratings/data/rating_providers.dart';
import '../../watchlist/data/watchlist_providers.dart';
import 'widgets/detail_section.dart';
import 'widgets/details_header.dart';
import 'widgets/genre_chips.dart';
import 'widgets/rating_picker.dart';
import 'widgets/watchlist_button.dart';

class DetailsScreen extends ConsumerWidget {
  const DetailsScreen({
    required this.mediaType,
    required this.mediaId,
    super.key,
  });

  static const routeName = 'details';

  final MediaType mediaType;
  final int mediaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final identity = MediaIdentity(mediaType: mediaType, id: mediaId);
    final detailsState = ref.watch(mediaDetailsProvider(identity));

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Details'),
        border: null,
        backgroundColor: CupertinoColors.systemBackground.withValues(
          alpha: 0.72,
        ),
      ),
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
        child: detailsState.when(
          data: (item) => _DetailsBody(item: item),
          error: (error, stackTrace) => ErrorStateView(
            message: 'Unable to load details.',
            onRetry: () => ref.invalidate(mediaDetailsProvider(identity)),
          ),
          loading: () => const LoadingView(style: LoadingViewStyle.details),
        ),
      ),
    );
  }
}

class _DetailsBody extends ConsumerWidget {
  const _DetailsBody({required this.item});

  final MediaItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final watchlist = ref.watch(watchlistControllerProvider).value ?? [];
    final ratings = ref.watch(ratingsControllerProvider).value ?? {};
    final isSaved = watchlist.contains(item.storageKey);
    final personalRating = ratings[item.storageKey];

    return ListView(
      padding: const EdgeInsets.only(bottom: 40),
      children: [
        DetailsHeader(item: item, personalRating: personalRating),
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 4, 14, 0),
          child: Column(
            children: [
              WatchlistButton(
                isSaved: isSaved,
                onPressed: () {
                  final controller = ref.read(
                    watchlistControllerProvider.notifier,
                  );
                  isSaved
                      ? controller.remove(item.storageKey)
                      : controller.add(item);
                },
              ),
              DetailSection(
                title: 'Genres',
                child: GenreChips(genres: item.genres),
              ),
              DetailSection(
                title: 'Personal rating',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RatingPicker(
                      value: personalRating,
                      onChanged: (rating) {
                        ref
                            .read(ratingsControllerProvider.notifier)
                            .saveRating(item.storageKey, rating);
                      },
                    ),
                    if (personalRating != null)
                      CupertinoButton(
                        padding: const EdgeInsets.only(top: 12),
                        minimumSize: Size.zero,
                        onPressed: () {
                          ref
                              .read(ratingsControllerProvider.notifier)
                              .removeRating(item.storageKey);
                        },
                        child: const Text('Clear Rating'),
                      ),
                  ],
                ),
              ),
              DetailSection(
                title: 'Overview',
                child: Text(
                  item.overview.isEmpty
                      ? 'No overview is available for this title.'
                      : item.overview,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.42,
                    letterSpacing: 0,
                    color: CupertinoColors.label,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
