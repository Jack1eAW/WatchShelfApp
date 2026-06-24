import '../../discover/domain/media_item.dart';

abstract interface class WatchlistRepository {
  Future<List<String>> loadKeys();

  Future<void> add(MediaItem item);

  Future<void> remove(String mediaKey);
}
