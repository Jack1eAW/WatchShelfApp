import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/storage_providers.dart';
import '../domain/rating_repository.dart';
import 'local_rating_repository.dart';

final ratingRepositoryProvider = Provider<RatingRepository>((ref) {
  return LocalRatingRepository(ref.watch(localStoreProvider));
});

final ratingsControllerProvider =
    AsyncNotifierProvider<RatingsController, Map<String, int>>(
      RatingsController.new,
    );

class RatingsController extends AsyncNotifier<Map<String, int>> {
  @override
  Future<Map<String, int>> build() {
    return ref.watch(ratingRepositoryProvider).loadRatings();
  }

  Future<void> saveRating(String mediaKey, int rating) async {
    final boundedRating = rating.clamp(1, 10);
    await ref
        .read(ratingRepositoryProvider)
        .saveRating(mediaKey, boundedRating);
    state = AsyncData({...?state.value, mediaKey: boundedRating});
  }

  Future<void> removeRating(String mediaKey) async {
    await ref.read(ratingRepositoryProvider).removeRating(mediaKey);
    final updated = {...?state.value}..remove(mediaKey);
    state = AsyncData(updated);
  }
}
