import '../../../core/storage/local_store.dart';
import '../domain/watchlist_repository.dart';
import '../../discover/domain/media_item.dart';

class LocalWatchlistRepository implements WatchlistRepository {
  LocalWatchlistRepository(this._store);

  final LocalStore _store;

  @override
  Future<List<String>> loadKeys() {
    return _store.loadWatchlistKeys();
  }

  @override
  Future<void> add(MediaItem item) async {
    final keys = await _store.loadWatchlistKeys();
    if (!keys.contains(item.storageKey)) {
      await _store.saveWatchlistKeys([...keys, item.storageKey]);
    }
  }

  @override
  Future<void> remove(String mediaKey) async {
    final keys = await _store.loadWatchlistKeys();
    await _store.saveWatchlistKeys(
      keys.where((key) => key != mediaKey).toList(),
    );
  }
}
