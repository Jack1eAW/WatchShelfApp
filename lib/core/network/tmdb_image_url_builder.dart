class TmdbImageUrlBuilder {
  const TmdbImageUrlBuilder(this.baseUrl);

  final String baseUrl;

  String? build(String? path) {
    if (path == null || path.trim().isEmpty) {
      return null;
    }

    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }

    final normalizedBase = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    return '$normalizedBase$normalizedPath';
  }
}
