import 'package:flutter_test/flutter_test.dart';
import 'package:watch_shelf/core/network/api_config.dart';
import 'package:watch_shelf/core/network/tmdb_api_client.dart';
import 'package:watch_shelf/features/discover/data/tmdb_media_repository.dart';
import 'package:watch_shelf/features/discover/domain/media_item.dart';

void main() {
  test('falls back to mock data when no API key is configured', () async {
    final repository = TmdbMediaRepository(
      TmdbApiClient(
        config: const ApiConfig(
          baseUrl: 'https://example.invalid',
          apiKey: '',
          imageBaseUrl: '',
        ),
      ),
    );

    final trending = await repository.trending();
    final search = await repository.search('dune');
    final details = await repository.details(MediaType.movie, 101);

    expect(trending, isNotEmpty);
    expect(search.single.title, contains('Dune'));
    expect(details.title, 'Dune: Part Two');
  });
}
