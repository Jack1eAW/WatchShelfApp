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
    expect(find.text('Severance'), findsWidgets);
    expect(find.byType(CupertinoSearchTextField), findsOneWidget);
  });
}
