import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watch_shelf/features/watchlist/data/watchlist_providers.dart';

import '../shared/fakes.dart';

void main() {
  test('adds and removes watchlist items', () async {
    final repository = MemoryWatchlistRepository();
    final container = ProviderContainer(
      overrides: [watchlistRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    await container.read(watchlistControllerProvider.future);
    await container.read(watchlistControllerProvider.notifier).add(testMovie);
    expect(container.read(watchlistControllerProvider).value, ['movie:1']);

    await container
        .read(watchlistControllerProvider.notifier)
        .remove(testMovie.storageKey);
    expect(container.read(watchlistControllerProvider).value, isEmpty);
  });
}
