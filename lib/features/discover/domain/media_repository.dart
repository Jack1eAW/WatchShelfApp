import 'media_item.dart';

abstract interface class MediaRepository {
  Future<List<MediaItem>> trending({
    required MediaType mediaType,
    int page = 1,
  });

  Future<List<MediaItem>> search(
    String query, {
    required MediaType mediaType,
    int page = 1,
  });

  Future<MediaItem> details(MediaType mediaType, int id);
}
