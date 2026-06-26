enum MediaType { movie, tv }

extension MediaTypeX on MediaType {
  String get wireName => switch (this) {
    MediaType.movie => 'movie',
    MediaType.tv => 'tv',
  };

  String get label => switch (this) {
    MediaType.movie => 'Movie',
    MediaType.tv => 'TV',
  };

  static MediaType fromWire(String value) {
    return value == 'tv' ? MediaType.tv : MediaType.movie;
  }
}

class MediaItem {
  const MediaItem({
    required this.id,
    required this.title,
    required this.overview,
    required this.releaseDate,
    required this.genres,
    required this.mediaType,
    this.voteAverage,
    this.posterPath,
    this.backdropPath,
    this.imdbId,
  });

  factory MediaItem.fromTmdbJson(Map<String, dynamic> json) {
    final type = MediaTypeX.fromWire(json['media_type'] as String? ?? 'movie');
    final title = type == MediaType.movie
        ? json['title'] as String? ?? 'Untitled movie'
        : json['name'] as String? ?? 'Untitled show';
    final date = type == MediaType.movie
        ? json['release_date'] as String? ?? ''
        : json['first_air_date'] as String? ?? '';

    return MediaItem(
      id: json['id'] as int,
      title: title,
      overview: json['overview'] as String? ?? '',
      releaseDate: date,
      genres: _parseGenres(json['genres'] ?? json['genre_names']),
      mediaType: type,
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
      posterPath: _firstString(json, const [
        'poster_path',
        'posterUrl',
        'poster_url',
        'cover_art_url',
      ]),
      backdropPath: _firstString(json, const [
        'backdrop_path',
        'backdropUrl',
        'backdrop_url',
      ]),
      imdbId: _firstString(json, const ['imdb_id', 'imdbId']),
    );
  }

  factory MediaItem.fromJson(Map<String, dynamic> json) {
    return MediaItem(
      id: json['id'] as int,
      title: json['title'] as String,
      overview: json['overview'] as String,
      releaseDate: json['releaseDate'] as String,
      genres: (json['genres'] as List<dynamic>).cast<String>(),
      mediaType: MediaTypeX.fromWire(json['mediaType'] as String),
      voteAverage: (json['voteAverage'] as num?)?.toDouble(),
      posterPath: json['posterPath'] as String?,
      backdropPath: json['backdropPath'] as String?,
      imdbId: json['imdbId'] as String?,
    );
  }

  final int id;
  final String title;
  final String overview;
  final String releaseDate;
  final List<String> genres;
  final MediaType mediaType;
  final double? voteAverage;
  final String? posterPath;
  final String? backdropPath;
  final String? imdbId;

  String get year {
    if (releaseDate.length < 4) {
      return 'TBA';
    }
    return releaseDate.substring(0, 4);
  }

  String get storageKey => '${mediaType.wireName}:$id';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'releaseDate': releaseDate,
      'genres': genres,
      'mediaType': mediaType.wireName,
      'voteAverage': voteAverage,
      'posterPath': posterPath,
      'backdropPath': backdropPath,
      'imdbId': imdbId,
    };
  }

  static List<String> _parseGenres(Object? value) {
    if (value is List) {
      if (value.isEmpty) {
        return const [];
      }
      if (value.first is Map) {
        return value
            .whereType<Map<String, dynamic>>()
            .map((genre) => genre['name'] as String? ?? '')
            .where((name) => name.isNotEmpty)
            .toList();
      }
      return value.whereType<String>().toList();
    }
    return const [];
  }

  static String? _firstString(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value is String && value.trim().isNotEmpty) {
        return value;
      }
    }
    return null;
  }
}
