import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/storage_providers.dart';
import '../../discover/data/media_providers.dart';
import '../../discover/domain/media_item.dart';
import '../domain/watchlist_repository.dart';
import 'local_watchlist_repository.dart';

final watchlistRepositoryProvider = Provider<WatchlistRepository>((ref) {
  return LocalWatchlistRepository(ref.watch(localStoreProvider));
});

final watchlistControllerProvider =
    AsyncNotifierProvider<WatchlistController, List<String>>(
      WatchlistController.new,
    );

final watchlistItemsProvider = FutureProvider<List<MediaItem>>((ref) async {
  final keys = await ref.watch(watchlistControllerProvider.future);
  final repository = ref.watch(mediaRepositoryProvider);

  final items = <MediaItem>[];
  for (final key in keys) {
    final parts = key.split(':');
    if (parts.length != 2) {
      continue;
    }
    final id = int.tryParse(parts[1]);
    if (id == null) {
      continue;
    }
    items.add(await repository.details(MediaTypeX.fromWire(parts[0]), id));
  }
  return items;
});

class WatchlistController extends AsyncNotifier<List<String>> {
  @override
  Future<List<String>> build() {
    return ref.watch(watchlistRepositoryProvider).loadKeys();
  }

  Future<void> add(MediaItem item) async {
    await ref.read(watchlistRepositoryProvider).add(item);
    final keys = [...?state.value];
    if (!keys.contains(item.storageKey)) {
      state = AsyncData([...keys, item.storageKey]);
    }
  }

  Future<void> remove(String mediaKey) async {
    await ref.read(watchlistRepositoryProvider).remove(mediaKey);
    state = AsyncData(
      [...?state.value].where((key) => key != mediaKey).toList(),
    );
  }
}
