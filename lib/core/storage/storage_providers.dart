import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'local_store.dart';

final localStoreProvider = Provider<LocalStore>((ref) {
  return LocalStore(SharedPreferencesAsync());
});
