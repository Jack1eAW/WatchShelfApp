import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watch_shelf/features/discover/data/media_providers.dart';
import 'package:watch_shelf/features/discover/domain/media_item.dart';
import 'package:watch_shelf/features/discover/domain/media_repository.dart';

void main() {
  test('loads the next page and appends unique media items', () async {
    final repository = _PagedMediaRepository();
    final container = ProviderContainer(
      overrides: [mediaRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    final initial = await container.read(discoverMediaProvider.future);
    expect(initial.items.map((item) => item.title), ['First Movie']);

    await container.read(discoverMediaProvider.notifier).loadNextPage();
    final updated = container.read(discoverMediaProvider).value!;

    expect(updated.items.map((item) => item.title), [
      'First Movie',
      'Second Movie',
    ]);
    expect(updated.page, 2);
    expect(updated.hasMore, isTrue);
  });
}

class _PagedMediaRepository implements MediaRepository {
  @override
  Future<MediaItem> details(MediaType mediaType, int id) {
    throw UnimplementedError();
  }

  @override
  Future<List<MediaItem>> search(
    String query, {
    required MediaType mediaType,
    int page = 1,
  }) {
    return trending(mediaType: mediaType, page: page);
  }

  @override
  Future<List<MediaItem>> trending({
    required MediaType mediaType,
    int page = 1,
  }) async {
    return switch (page) {
      1 => [_item(1, 'First Movie')],
      2 => [_item(1, 'First Movie'), _item(2, 'Second Movie')],
      _ => const [],
    };
  }

  MediaItem _item(int id, String title) {
    return MediaItem(
      id: id,
      title: title,
      overview: '',
      releaseDate: '2026-01-01',
      genres: const [],
      mediaType: MediaType.movie,
      voteAverage: 7,
    );
  }
}
