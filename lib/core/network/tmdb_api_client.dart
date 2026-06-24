import 'package:dio/dio.dart';

import '../errors/app_exception.dart';
import 'api_config.dart';
import 'tmdb_image_url_builder.dart';

class TmdbApiClient {
  TmdbApiClient({required ApiConfig config, Dio? dio})
    : _config = config,
      _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: config.baseUrl,
              connectTimeout: const Duration(seconds: 8),
              receiveTimeout: const Duration(seconds: 8),
            ),
          );

  final ApiConfig _config;
  final Dio _dio;

  bool get canUseLiveApi => _config.hasApiKey;

  String? imageUrl(String? path) {
    return TmdbImageUrlBuilder(_config.imageBaseUrl).build(path);
  }

  Future<Map<String, dynamic>> getJson(
    String path, {
    Map<String, dynamic> query = const {},
  }) async {
    if (!_config.hasApiKey) {
      throw const AppException('Missing TMDB API key.');
    }

    try {
      final response = await _dio.get<Map<String, dynamic>>(
        path,
        queryParameters: {'api_key': _config.apiKey, ...query},
      );
      return response.data ?? <String, dynamic>{};
    } on DioException catch (error) {
      throw AppException('TMDB request failed.', error);
    }
  }
}
