import 'package:flutter_test/flutter_test.dart';
import 'package:watch_shelf/core/network/tmdb_image_url_builder.dart';

void main() {
  const builder = TmdbImageUrlBuilder('https://image.tmdb.org/t/p/w500');

  test('keeps absolute image URLs unchanged', () {
    expect(
      builder.build('https://cdn.example.com/poster.jpg'),
      'https://cdn.example.com/poster.jpg',
    );
  });

  test('converts relative TMDB paths to absolute URLs', () {
    expect(
      builder.build('/poster.jpg'),
      'https://image.tmdb.org/t/p/w500/poster.jpg',
    );
    expect(
      builder.build('backdrop.jpg'),
      'https://image.tmdb.org/t/p/w500/backdrop.jpg',
    );
  });

  test('returns null for blank image paths', () {
    expect(builder.build(null), isNull);
    expect(builder.build(''), isNull);
    expect(builder.build('   '), isNull);
  });
}
