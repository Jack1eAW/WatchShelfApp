# Architecture

WatchShelf uses a feature-first clean architecture. UI code depends on providers and domain abstractions; repositories isolate API and persistence details.

## Modules

- `lib/app`: app bootstrap, Cupertino theme, and go_router routes
- `lib/core/errors`: shared exception type
- `lib/core/network`: TMDB-style API config and Dio client
- `lib/core/storage`: shared_preferences wrapper and provider
- `lib/core/utils`: small cross-feature helpers
- `lib/features/discover`: media model, page-aware repository contract, TMDB/public-source repository, tabbed search/trending UI
- `lib/features/details`: media detail screen and user actions
- `lib/features/watchlist`: local watchlist repository, controller, and watchlist UI
- `lib/features/ratings`: local rating repository and controller

## Data Flow

1. Presentation widgets read Riverpod providers.
2. Providers call domain repository interfaces.
3. Data repositories call Dio for live TMDB-style responses or public fallback sources.
4. Discover requests include media type and page number for tabbed infinite scrolling.
5. Watchlist and rating repositories persist local values through `LocalStore`.
6. Controllers update Riverpod state after persistence succeeds.

## State Management

Riverpod owns app state:

- `selectedDiscoverTypeProvider` owns the Movies/TV Shows segment.
- `searchQueryProvider` owns the current search text.
- `discoverMediaProvider` loads typed trending or search pages and appends more results as the list nears the bottom.
Search input is debounced in the Discover screen before updating provider state, which prevents a burst of network calls for every keystroke.
- `mediaDetailsProvider` loads a single media item.
- `watchlistControllerProvider` owns saved media keys.
- `watchlistItemsProvider` resolves saved keys into media details.
- `ratingsControllerProvider` owns personal rating values.

Widgets stay focused on rendering and user intent. Business rules live in repositories and controllers.

## Image Handling

TMDB relative poster and backdrop paths are normalized through `TmdbImageUrlBuilder`. The media model also accepts common cover-art aliases such as `cover_art_url`, `posterUrl`, `poster_url`, and public-source `posterURL` variants so fallback or TMDB-style payload variants still render posters. Movie fallback search and details use IMDbAPI title ids so broad searches such as `Spider-Man` can return real posters and IMDb aggregate ratings.

## Persistence

Watchlist keys and ratings are stored with `shared_preferences`.

- Watchlist values use media keys such as `movie:101`.
- Ratings are stored as a JSON map from media key to integer rating.
- Data remains local to the device.

## Navigation

`go_router` provides a root route with a Cupertino tab scaffold and nested details route:

- `/`: Discover, Watchlist, and About tabs
- `/details/:mediaType/:id`: details page for a movie or TV show

Tabs are rendered with `CupertinoTabScaffold` and `CupertinoTabView` for an iOS-style navigation feel.
