class ApiConfig {
  const ApiConfig({
    required this.baseUrl,
    required this.apiKey,
    required this.imageBaseUrl,
  });

  factory ApiConfig.fromEnvironment() {
    return const ApiConfig(
      baseUrl: String.fromEnvironment(
        'TMDB_BASE_URL',
        defaultValue: 'https://api.themoviedb.org/3',
      ),
      apiKey: String.fromEnvironment('TMDB_API_KEY'),
      imageBaseUrl: String.fromEnvironment(
        'TMDB_IMAGE_BASE_URL',
        defaultValue: 'https://image.tmdb.org/t/p/w500',
      ),
    );
  }

  final String baseUrl;
  final String apiKey;
  final String imageBaseUrl;

  bool get hasApiKey => apiKey.trim().isNotEmpty;
}
