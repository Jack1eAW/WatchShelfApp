import '../../../core/errors/app_exception.dart';
import '../../../core/network/tmdb_api_client.dart';
import '../domain/media_item.dart';
import '../domain/media_repository.dart';
import 'mock_media_data.dart';

class TmdbMediaRepository implements MediaRepository {
  TmdbMediaRepository(this._client);

  final TmdbApiClient _client;

  @override
  Future<List<MediaItem>> trending() async {
    if (!_client.canUseLiveApi) {
      return mockMediaItems;
    }

    try {
      final json = await _client.getJson('/trending/all/week');
      return _itemsFromResults(json['results'] as List<dynamic>?);
    } on AppException {
      return mockMediaItems;
    }
  }

  @override
  Future<List<MediaItem>> search(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      return trending();
    }

    if (!_client.canUseLiveApi) {
      return _searchMock(trimmed);
    }

    try {
      final json = await _client.getJson(
        '/search/multi',
        query: {'query': trimmed, 'include_adult': false},
      );
      return _itemsFromResults(json['results'] as List<dynamic>?);
    } on AppException {
      return _searchMock(trimmed);
    }
  }

  @override
  Future<MediaItem> details(MediaType mediaType, int id) async {
    if (!_client.canUseLiveApi) {
      return _mockById(mediaType, id);
    }

    try {
      final json = await _client.getJson('/${mediaType.wireName}/$id');
      return MediaItem.fromTmdbJson(
        _withImageUrls({...json, 'media_type': mediaType.wireName}),
      );
    } on AppException {
      return _mockById(mediaType, id);
    }
  }

  List<MediaItem> _itemsFromResults(List<dynamic>? results) {
    return (results ?? const [])
        .whereType<Map<String, dynamic>>()
        .where((json) {
          final type = json['media_type'];
          return type == 'movie' || type == 'tv';
        })
        .map((json) => MediaItem.fromTmdbJson(_withImageUrls(json)))
        .toList();
  }

  Map<String, dynamic> _withImageUrls(Map<String, dynamic> json) {
    return {
      ...json,
      'poster_path': _client.imageUrl(json['poster_path'] as String?),
      'backdrop_path': _client.imageUrl(json['backdrop_path'] as String?),
    };
  }

  List<MediaItem> _searchMock(String query) {
    final lower = query.toLowerCase();
    return mockMediaItems
        .where(
          (item) =>
              item.title.toLowerCase().contains(lower) ||
              item.genres.any((genre) => genre.toLowerCase().contains(lower)),
        )
        .toList();
  }

  MediaItem _mockById(MediaType type, int id) {
    return mockMediaItems.firstWhere(
      (item) => item.id == id && item.mediaType == type,
      orElse: () => throw AppException('Media item $type/$id not found.'),
    );
  }
}
