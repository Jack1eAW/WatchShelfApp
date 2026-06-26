import 'package:flutter_test/flutter_test.dart';
import 'package:watch_shelf/core/network/api_config.dart';
import 'package:watch_shelf/core/network/tmdb_api_client.dart';
import 'package:watch_shelf/features/discover/data/public_media_source_client.dart';
import 'package:watch_shelf/features/discover/data/tmdb_media_repository.dart';
import 'package:watch_shelf/features/discover/domain/media_item.dart';

void main() {
  test('uses public source data when no API key is configured', () async {
    final repository = _repository(publicSource: _FakePublicSource());

    final trending = await repository.trending(mediaType: MediaType.movie);
    final search = await repository.search('dune', mediaType: MediaType.movie);
    final details = await repository.details(MediaType.movie, 101);

    expect(trending, isNotEmpty);
    expect(search.single.title, contains('Dune'));
    expect(details.title, 'Dune: Part Two');
    expect(details.posterPath, contains('yts.mx'));
  });

  test('returns separate movie and TV pages from public source', () async {
    final repository = _repository(publicSource: _FakePublicSource());

    final movies = await repository.trending(mediaType: MediaType.movie);
    final shows = await repository.trending(mediaType: MediaType.tv);
    final secondMoviePage = await repository.trending(
      mediaType: MediaType.movie,
      page: 2,
    );
    final emptyMoviePage = await repository.trending(
      mediaType: MediaType.movie,
      page: 99,
    );

    expect(
      movies,
      everyElement((MediaItem item) => item.mediaType == MediaType.movie),
    );
    expect(
      shows,
      everyElement((MediaItem item) => item.mediaType == MediaType.tv),
    );
    expect(secondMoviePage, isNotEmpty);
    expect(emptyMoviePage, isEmpty);
  });
}

TmdbMediaRepository _repository({
  required PublicMediaSourceClient publicSource,
}) {
  return TmdbMediaRepository(
    TmdbApiClient(
      config: const ApiConfig(
        baseUrl: 'https://example.invalid',
        apiKey: '',
        imageBaseUrl: '',
      ),
    ),
    publicSource: publicSource,
  );
}

class _FakePublicSource extends PublicMediaSourceClient {
  _FakePublicSource();

  @override
  Future<MediaItem> movieDetails(int id) async => _movie(id, 'Dune: Part Two');

  @override
  Future<List<MediaItem>> searchMovies(
    String query, {
    required int page,
  }) async {
    return page == 1 ? [_movie(101, 'Dune: Part Two')] : const [];
  }

  @override
  Future<List<MediaItem>> searchShows(String query, {required int page}) async {
    return page == 1 ? [_show(201, 'Shogun')] : const [];
  }

  @override
  Future<MediaItem> showDetails(int id) async => _show(id, 'Shogun');

  @override
  Future<List<MediaItem>> trendingMovies({required int page}) async {
    return switch (page) {
      1 => [_movie(101, 'Dune: Part Two'), _movie(102, 'Oppenheimer')],
      2 => [_movie(103, 'Past Lives')],
      _ => const [],
    };
  }

  @override
  Future<List<MediaItem>> trendingShows({required int page}) async {
    return switch (page) {
      1 => [_show(201, 'Shogun'), _show(202, 'Severance')],
      2 => [_show(203, 'The Bear')],
      _ => const [],
    };
  }

  MediaItem _movie(int id, String title) {
    return MediaItem(
      id: id,
      title: title,
      overview: '',
      releaseDate: '2024-01-01',
      genres: const ['Drama'],
      mediaType: MediaType.movie,
      voteAverage: 8,
      posterPath: 'https://img.yts.mx/assets/images/movies/$id/poster.jpg',
    );
  }

  MediaItem _show(int id, String title) {
    return MediaItem(
      id: id,
      title: title,
      overview: '',
      releaseDate: '2024-01-01',
      genres: const ['Drama'],
      mediaType: MediaType.tv,
      voteAverage: 8,
      posterPath: 'https://static.tvmaze.com/uploads/images/original/$id.jpg',
    );
  }
}
