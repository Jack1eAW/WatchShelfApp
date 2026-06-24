import 'media_item.dart';

abstract interface class MediaRepository {
  Future<List<MediaItem>> trending();

  Future<List<MediaItem>> search(String query);

  Future<MediaItem> details(MediaType mediaType, int id);
}
