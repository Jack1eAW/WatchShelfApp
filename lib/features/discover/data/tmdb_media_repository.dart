import '../../../core/errors/app_exception.dart';
import '../../../core/network/tmdb_api_client.dart';
import '../domain/media_item.dart';
import '../domain/media_repository.dart';
import 'mock_media_data.dart';
import 'public_media_source_client.dart';

class TmdbMediaRepository implements MediaRepository {
  TmdbMediaRepository(this._client, {PublicMediaSourceClient? publicSource})
    : _publicSource = publicSource ?? PublicMediaSourceClient();

  final TmdbApiClient _client;
  final PublicMediaSourceClient _publicSource;

  @override
  Future<List<MediaItem>> trending({
    required MediaType mediaType,
    int page = 1,
  }) async {
    if (!_client.canUseLiveApi) {
      return _publicTrending(mediaType: mediaType, page: page);
    }

    try {
      final json = await _client.getJson(
        '/trending/${mediaType.wireName}/week',
        query: {'page': page},
      );
      return _itemsFromResults(
        json['results'] as List<dynamic>?,
        fallbackType: mediaType,
      );
    } on AppException {
      return _publicTrending(mediaType: mediaType, page: page);
    }
  }

  @override
  Future<List<MediaItem>> search(
    String query, {
    required MediaType mediaType,
    int page = 1,
  }) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      return trending(mediaType: mediaType, page: page);
    }

    if (!_client.canUseLiveApi) {
      return _publicSearch(trimmed, mediaType: mediaType, page: page);
    }

    try {
      final json = await _client.getJson(
        '/search/${mediaType.wireName}',
        query: {'query': trimmed, 'include_adult': false, 'page': page},
      );
      return _itemsFromResults(
        json['results'] as List<dynamic>?,
        fallbackType: mediaType,
      );
    } on AppException {
      return _publicSearch(trimmed, mediaType: mediaType, page: page);
    }
  }

  @override
  Future<MediaItem> details(MediaType mediaType, int id) async {
    if (!_client.canUseLiveApi) {
      return _publicDetails(mediaType, id);
    }

    try {
      final json = await _client.getJson('/${mediaType.wireName}/$id');
      return MediaItem.fromTmdbJson(
        _withImageUrls({...json, 'media_type': mediaType.wireName}),
      );
    } on AppException {
      return _publicDetails(mediaType, id);
    }
  }

  Future<List<MediaItem>> _publicTrending({
    required MediaType mediaType,
    required int page,
  }) async {
    try {
      return switch (mediaType) {
        MediaType.movie => _publicSource.trendingMovies(page: page),
        MediaType.tv => _publicSource.trendingShows(page: page),
      };
    } on AppException {
      return _mockPage(mediaType: mediaType, page: page);
    }
  }

  Future<List<MediaItem>> _publicSearch(
    String query, {
    required MediaType mediaType,
    required int page,
  }) async {
    try {
      return switch (mediaType) {
        MediaType.movie => _publicSource.searchMovies(query, page: page),
        MediaType.tv => _publicSource.searchShows(query, page: page),
      };
    } on AppException {
      return _searchMock(query, mediaType: mediaType, page: page);
    }
  }

  Future<MediaItem> _publicDetails(MediaType mediaType, int id) async {
    try {
      return switch (mediaType) {
        MediaType.movie => _publicSource.movieDetails(id),
        MediaType.tv => _publicSource.showDetails(id),
      };
    } on AppException {
      return _mockById(mediaType, id);
    }
  }

  List<MediaItem> _itemsFromResults(
    List<dynamic>? results, {
    required MediaType fallbackType,
  }) {
    return (results ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(
          (json) => MediaItem.fromTmdbJson(
            _withImageUrls({
              ...json,
              'media_type': json['media_type'] ?? fallbackType.wireName,
            }),
          ),
        )
        .toList();
  }

  Map<String, dynamic> _withImageUrls(Map<String, dynamic> json) {
    return {
      ...json,
      'poster_path': _client.imageUrl(_firstImagePath(json, 'poster')),
      'backdrop_path': _client.imageUrl(_firstImagePath(json, 'backdrop')),
    };
  }

  String? _firstImagePath(Map<String, dynamic> json, String kind) {
    final keys = switch (kind) {
      'poster' => ['poster_path', 'posterUrl', 'poster_url', 'cover_art_url'],
      'backdrop' => ['backdrop_path', 'backdropUrl', 'backdrop_url'],
      _ => <String>[],
    };

    for (final key in keys) {
      final value = json[key];
      if (value is String && value.trim().isNotEmpty) {
        return value;
      }
    }
    return null;
  }

  List<MediaItem> _mockPage({required MediaType mediaType, required int page}) {
    final typedItems = mockMediaItems
        .where((item) => item.mediaType == mediaType)
        .toList(growable: false);
    return _pageSlice(typedItems, page);
  }

  List<MediaItem> _searchMock(
    String query, {
    required MediaType mediaType,
    required int page,
  }) {
    final lower = query.toLowerCase();
    final results = mockMediaItems
        .where(
          (item) =>
              item.mediaType == mediaType &&
              (item.title.toLowerCase().contains(lower) ||
                  item.genres.any(
                    (genre) => genre.toLowerCase().contains(lower),
                  )),
        )
        .toList(growable: false);
    return _pageSlice(results, page);
  }

  List<MediaItem> _pageSlice(List<MediaItem> items, int page) {
    if (page < 1) {
      return const [];
    }

    final start = (page - 1) * mockMediaPageSize;
    if (start >= items.length) {
      return const [];
    }

    final end = (start + mockMediaPageSize).clamp(0, items.length);
    return items.sublist(start, end);
  }

  MediaItem _mockById(MediaType type, int id) {
    return mockMediaItems.firstWhere(
      (item) => item.id == id && item.mediaType == type,
      orElse: () => throw AppException('Media item $type/$id not found.'),
    );
  }
}
