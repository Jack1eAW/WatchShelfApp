import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_config.dart';
import '../../../core/network/tmdb_api_client.dart';
import '../domain/media_item.dart';
import '../domain/media_repository.dart';
import 'tmdb_media_repository.dart';

final apiConfigProvider = Provider<ApiConfig>((ref) {
  return ApiConfig.fromEnvironment();
});

final tmdbApiClientProvider = Provider<TmdbApiClient>((ref) {
  return TmdbApiClient(config: ref.watch(apiConfigProvider));
});

final mediaRepositoryProvider = Provider<MediaRepository>((ref) {
  return TmdbMediaRepository(ref.watch(tmdbApiClientProvider));
});

final searchQueryProvider = NotifierProvider<SearchQueryController, String>(
  SearchQueryController.new,
);

final discoverMediaProvider = FutureProvider<List<MediaItem>>((ref) {
  final repository = ref.watch(mediaRepositoryProvider);
  final query = ref.watch(searchQueryProvider);
  return query.trim().isEmpty
      ? repository.trending()
      : repository.search(query);
});

final mediaDetailsProvider = FutureProvider.family<MediaItem, MediaIdentity>((
  ref,
  identity,
) {
  return ref
      .watch(mediaRepositoryProvider)
      .details(identity.mediaType, identity.id);
});

class MediaIdentity {
  const MediaIdentity({required this.mediaType, required this.id});

  final MediaType mediaType;
  final int id;

  @override
  bool operator ==(Object other) {
    return other is MediaIdentity &&
        other.mediaType == mediaType &&
        other.id == id;
  }

  @override
  int get hashCode => Object.hash(mediaType, id);
}

class SearchQueryController extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String value) {
    state = value;
  }
}
