import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watch_shelf/app/app.dart';
import 'package:watch_shelf/features/discover/data/media_providers.dart';
import 'package:watch_shelf/features/ratings/data/rating_providers.dart';
import 'package:watch_shelf/features/watchlist/data/watchlist_providers.dart';

import '../shared/fakes.dart';

void main() {
  testWidgets('Details screen saves watchlist item and personal rating', (
    tester,
  ) async {
    final watchlistRepository = MemoryWatchlistRepository();
    final ratingRepository = MemoryRatingRepository();

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
    await tester.tap(find.text('Arrival').last);
    await tester.pumpAndSettle();

    expect(find.text('Overview'), findsOneWidget);
    expect(find.text('Add to Watchlist'), findsOneWidget);

    await tester.tap(find.text('Add to Watchlist'));
    await tester.pumpAndSettle();
    expect(watchlistRepository.keys, [testMovie.storageKey]);
    expect(find.text('Remove from Watchlist'), findsOneWidget);

    await tester.drag(
      find.byType(ListView).last,
      const Offset(-220, 0),
      touchSlopY: 0,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('8'));
    await tester.pumpAndSettle();

    expect(ratingRepository.ratings[testMovie.storageKey], 8);
    expect(find.text('Clear Rating'), findsOneWidget);
  });
}
