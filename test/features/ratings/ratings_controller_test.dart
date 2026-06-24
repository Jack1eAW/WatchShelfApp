import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watch_shelf/features/ratings/data/rating_providers.dart';

import '../shared/fakes.dart';

void main() {
  test('saves and updates personal ratings', () async {
    final repository = MemoryRatingRepository();
    final container = ProviderContainer(
      overrides: [ratingRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    await container.read(ratingsControllerProvider.future);
    await container
        .read(ratingsControllerProvider.notifier)
        .saveRating(testMovie.storageKey, 8);
    await container
        .read(ratingsControllerProvider.notifier)
        .saveRating(testMovie.storageKey, 9);

    expect(container.read(ratingsControllerProvider).value, {'movie:1': 9});
  });
}
