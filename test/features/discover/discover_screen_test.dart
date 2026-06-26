import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watch_shelf/app/app.dart';
import 'package:watch_shelf/features/discover/data/media_providers.dart';
import 'package:watch_shelf/features/ratings/data/rating_providers.dart';
import 'package:watch_shelf/features/watchlist/data/watchlist_providers.dart';

import '../shared/fakes.dart';

void main() {
  testWidgets('Discover screen lists trending media', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          mediaRepositoryProvider.overrideWithValue(
            FakeMediaRepository([testMovie, testShow]),
          ),
          watchlistRepositoryProvider.overrideWithValue(
            MemoryWatchlistRepository(),
          ),
          ratingRepositoryProvider.overrideWithValue(MemoryRatingRepository()),
        ],
        child: const WatchShelfApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Discover'), findsWidgets);
    expect(find.text('Arrival'), findsWidgets);
    expect(find.text('IMDb 7.6'), findsOneWidget);
    expect(find.text('Severance'), findsNothing);
    expect(find.byType(CupertinoSearchTextField), findsOneWidget);
    expect(find.text('Movies'), findsOneWidget);
    expect(find.text('TV Shows'), findsOneWidget);
  });

  testWidgets('Discover screen switches to TV shows and searches', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          mediaRepositoryProvider.overrideWithValue(
            FakeMediaRepository([testMovie, testShow]),
          ),
          watchlistRepositoryProvider.overrideWithValue(
            MemoryWatchlistRepository(),
          ),
          ratingRepositoryProvider.overrideWithValue(MemoryRatingRepository()),
        ],
        child: const WatchShelfApp(),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.text('TV Shows'));
    await tester.pumpAndSettle();

    expect(find.text('Severance'), findsWidgets);
    expect(find.text('TV rating 8.4'), findsOneWidget);
    expect(find.text('Arrival'), findsNothing);

    await tester.enterText(find.byType(CupertinoSearchTextField), 'sever');
    await tester.pumpAndSettle();

    expect(find.text('Severance'), findsWidgets);
  });
}
