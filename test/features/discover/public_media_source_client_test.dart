import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watch_shelf/features/discover/data/public_media_source_client.dart';
import 'package:watch_shelf/features/discover/domain/media_item.dart';

void main() {
  test('hydrates known catalog titles without IMDb requests', () async {
    final adapter = _FakeHttpClientAdapter({
      'https://api.sampleapis.com/movies/drama': [
        {
          'id': 1,
          'title': 'Lady Bird',
          'posterURL': 'https://example.com/lady-bird.jpg',
        },
        {
          'id': 2,
          'title': 'A Quiet Place',
          'posterURL': 'https://example.com/a-quiet-place.jpg',
        },
        {
          'id': 3,
          'title': 'Dunkirk',
          'posterURL': 'https://example.com/dunkirk.jpg',
        },
        {
          'id': 4,
          'title': 'Selma',
          'posterURL': 'https://example.com/selma.jpg',
        },
        {
          'id': 5,
          'title': 'Spotlight',
          'posterURL': 'https://example.com/spotlight.jpg',
        },
      ],
      'https://api.sampleapis.com/movies/comedy': [],
      'https://api.sampleapis.com/movies/animation': [],
      'https://api.sampleapis.com/movies/family': [],
      'https://api.sampleapis.com/movies/horror': [],
      'https://api.sampleapis.com/movies/mystery': [],
      'https://api.sampleapis.com/movies/western': [],
    });
    final dio = Dio()..httpClientAdapter = adapter;

    final items = await PublicMediaSourceClient(
      dio: dio,
    ).trendingMovies(page: 1);

    expect(_itemByTitle(items, 'Lady Bird').year, '2017');
    expect(_itemByTitle(items, 'Lady Bird').voteAverage, 7.4);
    expect(_itemByTitle(items, 'A Quiet Place').year, '2018');
    expect(_itemByTitle(items, 'A Quiet Place').voteAverage, 7.5);
    expect(_itemByTitle(items, 'Dunkirk').year, '2017');
    expect(_itemByTitle(items, 'Dunkirk').voteAverage, 7.8);
    expect(_itemByTitle(items, 'Selma').year, '2015');
    expect(_itemByTitle(items, 'Selma').voteAverage, 7.5);
    expect(_itemByTitle(items, 'Spotlight').year, '2015');
    expect(_itemByTitle(items, 'Spotlight').voteAverage, 8.1);
    expect(adapter.requestedUrls, everyElement(isNot(contains('imdbapi.dev'))));
  });
}

MediaItem _itemByTitle(List<MediaItem> items, String title) {
  return items.firstWhere((item) => item.title == title);
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
