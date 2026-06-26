import 'package:dio/dio.dart';

import '../../../core/errors/app_exception.dart';
import '../domain/media_item.dart';

class PublicMediaSourceClient {
  PublicMediaSourceClient({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 8),
              receiveTimeout: const Duration(seconds: 8),
            ),
          );

  static const _pageSize = 20;
  static const _movieCategories = [
    'drama',
    'comedy',
    'animation',
    'family',
    'horror',
    'mystery',
    'western',
  ];
  static const _knownMovieImdbIds = {
    'black panther': 'tt1825683',
    'lady bird': 'tt4925292',
    'citizen kane': 'tt0033467',
    'blackkklansman': 'tt7349662',
    'moonlight': 'tt4975722',
    'wonder woman': 'tt0451279',
  };

  final Dio _dio;
  final Map<String, Future<MediaItem>> _movieDetailsCache = {};
  final Map<String, Future<MediaItem>> _movieTitleSearchCache = {};

  Future<List<MediaItem>> trendingMovies({required int page}) async {
    final movies = await _movieCatalog();
    return _enrichMoviesWithImdbRatings(_pageSlice(movies, page));
  }

  Future<List<MediaItem>> searchMovies(
    String query, {
    required int page,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        'https://api.imdbapi.dev/search/titles',
        queryParameters: {'query': query},
      );
      final titles = response.data?['titles'] as List<dynamic>? ?? const [];
      final movies = titles
          .whereType<Map<String, dynamic>>()
          .where((json) => json['type'] == 'movie')
          .map(_movieFromImdbJson)
          .toList(growable: false);
      return _pageSlice(movies, page);
    } on DioException catch (error) {
      throw AppException('IMDb movie search failed.', error);
    }
  }

  Future<MediaItem> movieDetails(int id) async {
    try {
      return await _movieFromNumericImdbId(id);
    } on AppException {
      final movies = await _movieCatalog();
      return movies.firstWhere(
        (movie) => movie.id == id,
        orElse: () {
          throw AppException('Movie $id not found in public source.');
        },
      );
    }
  }

  Future<List<MediaItem>> trendingShows({required int page}) async {
    final tvMazePage = (page - 1).clamp(0, 9999);
    try {
      final response = await _dio.get<List<dynamic>>(
        'https://api.tvmaze.com/shows',
        queryParameters: {'page': tvMazePage},
      );
      return (response.data ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(_showFromTvMaze)
          .toList(growable: false);
    } on DioException catch (error) {
      throw AppException('Public TV source request failed.', error);
    }
  }

  Future<List<MediaItem>> searchShows(String query, {required int page}) async {
    try {
      final response = await _dio.get<List<dynamic>>(
        'https://api.tvmaze.com/search/shows',
        queryParameters: {'q': query},
      );
      final allResults = (response.data ?? const [])
          .whereType<Map<String, dynamic>>()
          .map((result) => result['show'])
          .whereType<Map<String, dynamic>>()
          .map(_showFromTvMaze)
          .toList(growable: false);
      return _pageSlice(allResults, page);
    } on DioException catch (error) {
      throw AppException('Public TV search request failed.', error);
    }
  }

  Future<MediaItem> showDetails(int id) async {
    final json = await _getJson('https://api.tvmaze.com/shows/$id');
    return _showFromTvMaze(json);
  }

  Future<List<MediaItem>> _movieCatalog() async {
    try {
      final responses = await Future.wait(
        _movieCategories.map((category) async {
          final response = await _dio.get<List<dynamic>>(
            'https://api.sampleapis.com/movies/$category',
          );
          return MapEntry(category, response.data ?? const []);
        }),
      );

      final items = <MediaItem>[];
      final seenTitles = <String>{};
      for (
        var categoryIndex = 0;
        categoryIndex < responses.length;
        categoryIndex++
      ) {
        final category = responses[categoryIndex].key;
        final rows = responses[categoryIndex].value;
        for (final row in rows.whereType<Map<String, dynamic>>()) {
          final title = row['title'] as String? ?? 'Movie';
          if (!seenTitles.add(title.toLowerCase())) {
            continue;
          }
          items.add(_movieFromSampleApi(row, category, categoryIndex));
        }
      }
      return items;
    } on DioException catch (error) {
      throw AppException('Public movie source request failed.', error);
    }
  }

  Future<Map<String, dynamic>> _getJson(String url) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(url);
      return response.data ?? <String, dynamic>{};
    } on DioException catch (error) {
      throw AppException('Public media source request failed.', error);
    }
  }

  Future<MediaItem> _movieFromNumericImdbId(
    int id, {
    MediaItem? fallback,
  }) async {
    final imdbId = _imdbIdFromInt(id);
    return _movieFromImdbId(imdbId, fallback: fallback);
  }

  Future<MediaItem> _movieFromImdbId(
    String imdbId, {
    MediaItem? fallback,
  }) async {
    try {
      return await _movieDetailsCache.putIfAbsent(imdbId, () async {
        final json = await _getJson('https://api.imdbapi.dev/titles/$imdbId');
        return _movieFromImdbJson(json, fallback: fallback);
      });
    } on AppException catch (error) {
      if (fallback != null) {
        return fallback;
      }
      throw AppException('IMDb movie $imdbId not found.', error);
    }
  }

  MediaItem _movieFromSampleApi(
    Map<String, dynamic> json,
    String category,
    int categoryIndex,
  ) {
    final imdbId = json['imdbId'] as String?;
    final title = json['title'] as String? ?? 'Movie';
    final sourceId =
        _idFromImdbId(imdbId ?? _knownMovieImdbIds[_titleKey(title)]) ??
        ((categoryIndex + 1) * 10000 +
            (json['id'] as int? ?? _stableId(json['title'] as String?)));

    return MediaItem(
      id: sourceId,
      title: title,
      overview:
          'A ${_categoryLabel(category).toLowerCase()} film from the '
          'public movie catalog.',
      releaseDate: '',
      genres: [_categoryLabel(category)],
      mediaType: MediaType.movie,
      posterPath: json['posterURL'] as String?,
      imdbId: imdbId ?? _knownMovieImdbIds[_titleKey(title)],
    );
  }

  MediaItem _movieFromImdbJson(
    Map<String, dynamic> json, {
    MediaItem? fallback,
  }) {
    final imdbId = json['id'] as String?;
    final image = json['primaryImage'] as Map<String, dynamic>?;
    final rating = json['rating'] as Map<String, dynamic>?;
    final year = json['startYear'] as int?;
    final title =
        json['primaryTitle'] as String? ??
        json['originalTitle'] as String? ??
        fallback?.title ??
        'Movie';

    return MediaItem(
      id: _idFromImdbId(imdbId) ?? fallback?.id ?? _stableId(title),
      title: title,
      overview: json['plot'] as String? ?? fallback?.overview ?? '',
      releaseDate: year == null ? fallback?.releaseDate ?? '' : '$year-01-01',
      genres: (json['genres'] as List<dynamic>? ?? fallback?.genres ?? const [])
          .whereType<String>()
          .toList(growable: false),
      mediaType: MediaType.movie,
      voteAverage:
          (rating?['aggregateRating'] as num?)?.toDouble() ??
          fallback?.voteAverage,
      posterPath: fallback?.posterPath ?? image?['url'] as String?,
      backdropPath: fallback?.backdropPath,
      imdbId: imdbId ?? fallback?.imdbId,
    );
  }

  Future<List<MediaItem>> _enrichMoviesWithImdbRatings(List<MediaItem> movies) {
    return _mapInBatches(
      movies,
      batchSize: 4,
      mapper: (movie) {
        if (movie.voteAverage != null) {
          return Future.value(movie);
        }
        return _movieFromImdbReference(
          movie,
        ).timeout(const Duration(seconds: 4), onTimeout: () => movie);
      },
    );
  }

  Future<MediaItem> _movieFromImdbReference(MediaItem movie) {
    final imdbId = movie.imdbId;
    if (imdbId != null) {
      return _movieFromImdbId(imdbId, fallback: movie);
    }

    final cacheKey = _titleKey(movie.title);
    return _movieTitleSearchCache.putIfAbsent(cacheKey, () async {
      try {
        final response = await _dio.get<Map<String, dynamic>>(
          'https://api.imdbapi.dev/search/titles',
          queryParameters: {'query': movie.title},
        );
        final titles = response.data?['titles'] as List<dynamic>? ?? const [];
        final candidates = titles
            .whereType<Map<String, dynamic>>()
            .where((json) => json['type'] == 'movie')
            .toList(growable: false);
        if (candidates.isEmpty) {
          return movie;
        }

        final match = candidates.firstWhere(
          (json) => _sameTitle(json['primaryTitle'], movie.title),
          orElse: () => candidates.firstWhere(
            (json) => _sameTitle(json['originalTitle'], movie.title),
            orElse: () => candidates.first,
          ),
        );
        final matchedImdbId = match['id'] as String?;
        if (matchedImdbId == null) {
          return movie;
        }
        return _movieFromImdbId(matchedImdbId, fallback: movie);
      } on AppException {
        return movie;
      } on DioException {
        return movie;
      }
    });
  }

  MediaItem _showFromTvMaze(Map<String, dynamic> json) {
    final image = json['image'] as Map<String, dynamic>?;
    final rating = json['rating'] as Map<String, dynamic>?;

    return MediaItem(
      id: json['id'] as int,
      title: json['name'] as String? ?? 'TV Show',
      overview: _stripHtml(json['summary'] as String? ?? ''),
      releaseDate: json['premiered'] as String? ?? '',
      genres: (json['genres'] as List<dynamic>? ?? const [])
          .whereType<String>()
          .toList(growable: false),
      mediaType: MediaType.tv,
      voteAverage: (rating?['average'] as num?)?.toDouble(),
      posterPath: image?['original'] as String? ?? image?['medium'] as String?,
      backdropPath:
          image?['original'] as String? ?? image?['medium'] as String?,
    );
  }

  List<MediaItem> _pageSlice(List<MediaItem> items, int page) {
    if (page < 1) {
      return const [];
    }
    final start = (page - 1) * _pageSize;
    if (start >= items.length) {
      return const [];
    }
    final end = (start + _pageSize).clamp(0, items.length);
    return items.sublist(start, end);
  }

  int _stableId(String? value) {
    return (value ?? 'movie').codeUnits.fold<int>(
      0,
      (previous, element) => previous + element,
    );
  }

  int? _idFromImdbId(String? imdbId) {
    if (imdbId == null || !imdbId.startsWith('tt')) {
      return null;
    }
    return int.tryParse(imdbId.substring(2));
  }

  String _imdbIdFromInt(int id) {
    return 'tt${id.toString().padLeft(7, '0')}';
  }

  String _categoryLabel(String category) {
    return category[0].toUpperCase() + category.substring(1);
  }

  String _stripHtml(String value) {
    return value
        .replaceAll(RegExp('<[^>]+>'), ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  bool _sameTitle(Object? candidate, String title) {
    return candidate is String && _titleKey(candidate) == _titleKey(title);
  }

  String _titleKey(String value) {
    return value.trim().toLowerCase();
  }

  Future<List<T>> _mapInBatches<T>(
    List<T> items, {
    required int batchSize,
    required Future<T> Function(T item) mapper,
  }) async {
    final results = <T>[];
    for (var start = 0; start < items.length; start += batchSize) {
      final end = (start + batchSize).clamp(0, items.length);
      results.addAll(await Future.wait(items.sublist(start, end).map(mapper)));
    }
    return results;
  }
}
