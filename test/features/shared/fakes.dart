import 'package:watch_shelf/features/discover/domain/media_item.dart';
import 'package:watch_shelf/features/discover/domain/media_repository.dart';
import 'package:watch_shelf/features/ratings/domain/rating_repository.dart';
import 'package:watch_shelf/features/watchlist/domain/watchlist_repository.dart';

class FakeMediaRepository implements MediaRepository {
  FakeMediaRepository(this.items);

  final List<MediaItem> items;

  @override
  Future<MediaItem> details(MediaType mediaType, int id) async {
    return items.firstWhere(
      (item) => item.mediaType == mediaType && item.id == id,
    );
  }

  @override
  Future<List<MediaItem>> search(String query) async {
    final lower = query.toLowerCase();
    return items
        .where((item) => item.title.toLowerCase().contains(lower))
        .toList();
  }

  @override
  Future<List<MediaItem>> trending() async => items;
}

class MemoryWatchlistRepository implements WatchlistRepository {
  final List<String> keys = [];

  @override
  Future<void> add(MediaItem item) async {
    if (!keys.contains(item.storageKey)) {
      keys.add(item.storageKey);
    }
  }

  @override
  Future<List<String>> loadKeys() async => [...keys];

  @override
  Future<void> remove(String mediaKey) async {
    keys.remove(mediaKey);
  }
}

class MemoryRatingRepository implements RatingRepository {
  final Map<String, int> ratings = {};

  @override
  Future<Map<String, int>> loadRatings() async => {...ratings};

  @override
  Future<void> removeRating(String mediaKey) async {
    ratings.remove(mediaKey);
  }

  @override
  Future<void> saveRating(String mediaKey, int rating) async {
    ratings[mediaKey] = rating;
  }
}

const testMovie = MediaItem(
  id: 1,
  title: 'Arrival',
  overview: 'A linguist works with the military to communicate with visitors.',
  releaseDate: '2016-11-11',
  genres: ['Science Fiction', 'Drama'],
  mediaType: MediaType.movie,
  voteAverage: 7.6,
);

const testShow = MediaItem(
  id: 2,
  title: 'Severance',
  overview: 'Employees separate work memories from personal lives.',
  releaseDate: '2022-02-18',
  genres: ['Mystery'],
  mediaType: MediaType.tv,
  voteAverage: 8.4,
);
