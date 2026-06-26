import 'package:flutter/foundation.dart';
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

final selectedDiscoverTypeProvider =
    NotifierProvider<SelectedDiscoverTypeController, MediaType>(
      SelectedDiscoverTypeController.new,
    );

final discoverMediaProvider =
    AsyncNotifierProvider<DiscoverMediaController, DiscoverMediaState>(
      DiscoverMediaController.new,
    );

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

class SelectedDiscoverTypeController extends Notifier<MediaType> {
  @override
  MediaType build() => MediaType.movie;

  void select(MediaType value) {
    state = value;
  }
}

class DiscoverMediaState {
  const DiscoverMediaState({
    required this.items,
    required this.mediaType,
    required this.query,
    required this.page,
    required this.hasMore,
    this.isLoadingMore = false,
  });

  final List<MediaItem> items;
  final MediaType mediaType;
  final String query;
  final int page;
  final bool hasMore;
  final bool isLoadingMore;

  DiscoverMediaState copyWith({
    List<MediaItem>? items,
    MediaType? mediaType,
    String? query,
    int? page,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return DiscoverMediaState(
      items: items ?? this.items,
      mediaType: mediaType ?? this.mediaType,
      query: query ?? this.query,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class DiscoverMediaController extends AsyncNotifier<DiscoverMediaState> {
  @override
  Future<DiscoverMediaState> build() async {
    final mediaType = ref.watch(selectedDiscoverTypeProvider);
    final query = ref.watch(searchQueryProvider).trim();
    final items = await _loadPage(mediaType: mediaType, query: query, page: 1);

    return DiscoverMediaState(
      items: _dedupe(items),
      mediaType: mediaType,
      query: query,
      page: 1,
      hasMore: items.isNotEmpty,
    );
  }

  Future<void> loadNextPage() async {
    final current = state.value;
    if (current == null || current.isLoadingMore || !current.hasMore) {
      return;
    }

    state = AsyncData(current.copyWith(isLoadingMore: true));

    try {
      final nextPage = current.page + 1;
      final nextItems = await _loadPage(
        mediaType: current.mediaType,
        query: current.query,
        page: nextPage,
      );
      state = AsyncData(
        current.copyWith(
          items: _dedupe([...current.items, ...nextItems]),
          page: nextPage,
          hasMore: nextItems.isNotEmpty,
          isLoadingMore: false,
        ),
      );
    } catch (error, stackTrace) {
      state = AsyncData(current.copyWith(isLoadingMore: false, hasMore: false));
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'watch_shelf.discover',
          context: ErrorDescription('loading the next media page'),
        ),
      );
    }
  }

  Future<List<MediaItem>> _loadPage({
    required MediaType mediaType,
    required String query,
    required int page,
  }) {
    final repository = ref.read(mediaRepositoryProvider);
    return query.isEmpty
        ? repository.trending(mediaType: mediaType, page: page)
        : repository.search(query, mediaType: mediaType, page: page);
  }

  List<MediaItem> _dedupe(List<MediaItem> items) {
    final seen = <String>{};
    return [
      for (final item in items)
        if (seen.add(item.storageKey)) item,
    ];
  }
}
