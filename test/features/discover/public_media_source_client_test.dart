import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watch_shelf/features/discover/data/public_media_source_client.dart';

void main() {
  test('enriches known catalog titles with IMDb ratings', () async {
    final adapter = _FakeHttpClientAdapter({
      'https://api.sampleapis.com/movies/drama': [
        {
          'id': 1,
          'title': 'Lady Bird',
          'posterURL': 'https://example.com/lady-bird.jpg',
        },
      ],
      'https://api.sampleapis.com/movies/comedy': [],
      'https://api.sampleapis.com/movies/animation': [],
      'https://api.sampleapis.com/movies/family': [],
      'https://api.sampleapis.com/movies/horror': [],
      'https://api.sampleapis.com/movies/mystery': [],
      'https://api.sampleapis.com/movies/western': [],
      'https://api.imdbapi.dev/titles/tt4925292': {
        'id': 'tt4925292',
        'type': 'movie',
        'primaryTitle': 'Lady Bird',
        'startYear': 2017,
        'rating': {'aggregateRating': 7.4},
        'primaryImage': {'url': 'https://example.com/imdb-lady-bird.jpg'},
      },
    });
    final dio = Dio()..httpClientAdapter = adapter;

    final items = await PublicMediaSourceClient(
      dio: dio,
    ).trendingMovies(page: 1);

    expect(items.single.title, 'Lady Bird');
    expect(items.single.year, '2017');
    expect(items.single.voteAverage, 7.4);
    expect(items.single.imdbId, 'tt4925292');
    expect(adapter.requestedUrls, isNot(contains(contains('/search/titles'))));
  });
}

class _FakeHttpClientAdapter implements HttpClientAdapter {
  _FakeHttpClientAdapter(this.responses);

  final Map<String, Object> responses;
  final List<String> requestedUrls = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final url = options.uri.toString();
    requestedUrls.add(url);
    final response = responses[url];
    if (response == null) {
      throw DioException(
        requestOptions: options,
        response: Response(requestOptions: options, statusCode: 404),
      );
    }
    return ResponseBody.fromString(
      jsonEncode(response),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
