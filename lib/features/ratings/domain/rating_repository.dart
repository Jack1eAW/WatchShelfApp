abstract interface class RatingRepository {
  Future<Map<String, int>> loadRatings();

  Future<void> saveRating(String mediaKey, int rating);

  Future<void> removeRating(String mediaKey);
}
