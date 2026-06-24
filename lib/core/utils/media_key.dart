import '../../features/discover/domain/media_item.dart';

String mediaKey(MediaType type, int id) => '${type.wireName}:$id';
