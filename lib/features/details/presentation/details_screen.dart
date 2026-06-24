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
      navigationBar: const CupertinoNavigationBar(middle: Text('Details')),
      child: SafeArea(
        child: detailsState.when(
          data: (item) => _DetailsBody(item: item),
          error: (error, stackTrace) => ErrorStateView(
            message: 'Unable to load details.',
            onRetry: () => ref.invalidate(mediaDetailsProvider(identity)),
          ),
          loading: () => const LoadingView(),
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
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        DetailsHeader(item: item, personalRating: personalRating),
        DetailSection(
          title: 'Genres',
          child: GenreChips(genres: item.genres),
        ),
        const SizedBox(height: 20),
        WatchlistButton(
          isSaved: isSaved,
          onPressed: () {
            final controller = ref.read(watchlistControllerProvider.notifier);
            isSaved ? controller.remove(item.storageKey) : controller.add(item);
          },
        ),
        DetailSection(
          title: 'Personal rating',
          topSpacing: 18,
          child: RatingPicker(
            value: personalRating,
            onChanged: (rating) {
              ref
                  .read(ratingsControllerProvider.notifier)
                  .saveRating(item.storageKey, rating);
            },
          ),
        ),
        if (personalRating != null)
          CupertinoButton(
            onPressed: () {
              ref
                  .read(ratingsControllerProvider.notifier)
                  .removeRating(item.storageKey);
            },
            child: const Text('Clear Rating'),
          ),
        DetailSection(
          title: 'Overview',
          topSpacing: 16,
          child: Text(
            item.overview,
            style: const TextStyle(fontSize: 16, height: 1.35),
          ),
        ),
      ],
    );
  }
}
