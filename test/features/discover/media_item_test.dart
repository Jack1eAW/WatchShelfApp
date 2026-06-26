import 'package:flutter_test/flutter_test.dart';
import 'package:watch_shelf/features/discover/domain/media_item.dart';

void main() {
  test('parses TMDB movie JSON', () {
    final item = MediaItem.fromTmdbJson({
      'id': 55,
      'media_type': 'movie',
      'title': 'The Matrix',
      'overview': 'A hacker discovers the truth.',
      'release_date': '1999-03-31',
      'genres': [
        {'name': 'Action'},
        {'name': 'Science Fiction'},
      ],
      'vote_average': 8.2,
      'poster_path': '/poster.jpg',
    });

    expect(item.id, 55);
    expect(item.title, 'The Matrix');
    expect(item.mediaType, MediaType.movie);
    expect(item.year, '1999');
    expect(item.genres, ['Action', 'Science Fiction']);
    expect(item.voteAverage, 8.2);
  });

  test('parses TMDB TV JSON', () {
    final item = MediaItem.fromTmdbJson({
      'id': 77,
      'media_type': 'tv',
      'name': 'Station Eleven',
      'overview': 'Artists rebuild after a pandemic.',
      'first_air_date': '2021-12-16',
      'genre_names': ['Drama'],
      'vote_average': 7.9,
    });

    expect(item.title, 'Station Eleven');
    expect(item.mediaType, MediaType.tv);
    expect(item.storageKey, 'tv:77');
  });

  test('parses cover art URL aliases', () {
    final item = MediaItem.fromTmdbJson({
      'id': 88,
      'media_type': 'movie',
      'title': 'Cover Story',
      'overview': '',
      'release_date': '2026-01-01',
      'cover_art_url': 'https://cdn.example.com/cover.jpg',
      'backdrop_url': 'https://cdn.example.com/backdrop.jpg',
      'vote_average': 6.5,
    });

    expect(item.posterPath, 'https://cdn.example.com/cover.jpg');
    expect(item.backdropPath, 'https://cdn.example.com/backdrop.jpg');
  });

  test('preserves missing source rating as null', () {
    final item = MediaItem.fromTmdbJson({
      'id': 99,
      'media_type': 'movie',
      'title': 'Unrated Story',
      'overview': '',
      'release_date': '2026-01-01',
    });

    expect(item.voteAverage, isNull);
  });
}
