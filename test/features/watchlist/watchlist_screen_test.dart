import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watch_shelf/app/app.dart';
import 'package:watch_shelf/features/discover/data/media_providers.dart';
import 'package:watch_shelf/features/ratings/data/rating_providers.dart';
import 'package:watch_shelf/features/watchlist/data/watchlist_providers.dart';

import '../shared/fakes.dart';

void main() {
  testWidgets('Watchlist screen shows saved media and personal rating', (
    tester,
  ) async {
    final watchlistRepository = MemoryWatchlistRepository()
      ..keys.add(testMovie.storageKey);
    final ratingRepository = MemoryRatingRepository()
      ..ratings[testMovie.storageKey] = 9;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          mediaRepositoryProvider.overrideWithValue(
            FakeMediaRepository([testMovie, testShow]),
          ),
          watchlistRepositoryProvider.overrideWithValue(watchlistRepository),
          ratingRepositoryProvider.overrideWithValue(ratingRepository),
        ],
        child: const WatchShelfApp(),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(CupertinoIcons.bookmark));
    await tester.pumpAndSettle();

    expect(find.text('Watchlist'), findsWidgets);
    expect(find.text('Arrival'), findsWidgets);
    expect(find.text('9/10'), findsOneWidget);
  });
}
