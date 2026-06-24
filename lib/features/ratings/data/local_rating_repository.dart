import '../../../core/storage/local_store.dart';
import '../domain/rating_repository.dart';

class LocalRatingRepository implements RatingRepository {
  LocalRatingRepository(this._store);

  final LocalStore _store;

  @override
  Future<Map<String, int>> loadRatings() {
    return _store.loadRatings();
  }

  @override
  Future<void> saveRating(String mediaKey, int rating) async {
    final ratings = await _store.loadRatings();
    ratings[mediaKey] = rating;
    await _store.saveRatings(ratings);
  }

  @override
  Future<void> removeRating(String mediaKey) async {
    final ratings = await _store.loadRatings();
    ratings.remove(mediaKey);
    await _store.saveRatings(ratings);
  }
}
