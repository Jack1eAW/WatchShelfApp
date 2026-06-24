# WatchShelf

WatchShelf is an iOS-first Flutter app for browsing movies and TV shows, opening details, saving a local watchlist, and adding personal ratings. The app is inspired by Must and IMDb, with a clean Cupertino interface and feature-first architecture.

## Features

- Trending movie and TV discovery
- Search across movies and TV shows
- Details pages with poster, title, year, genres, overview, media type, and average rating
- Local watchlist add/remove
- Local personal ratings from 1 to 10
- Watchlist view with saved titles and personal rating badges
- Settings/About tab with data-source and version notes
- Mock fallback data so the app runs without live API setup

## Tech Stack

- Flutter 3.44+
- Dart 3.12+
- Cupertino widgets for iOS-style UI
- Riverpod for state management
- go_router for navigation
- Dio for TMDB-style networking
- shared_preferences for local persistence
- flutter_lints and mocktail for quality/testing

## Setup Requirements

Install Flutter and ensure the iOS toolchain is available:

```sh
flutter doctor
```

Install dependencies:

```sh
flutter pub get
```

## API Key Setup

WatchShelf reads TMDB-style configuration from compile-time environment values. No secrets are committed.

Run with a live TMDB API key:

```sh
flutter run --dart-define=TMDB_API_KEY=your_key_here
```

Optional overrides:

```sh
flutter run \
  --dart-define=TMDB_API_KEY=your_key_here \
  --dart-define=TMDB_BASE_URL=https://api.themoviedb.org/3 \
  --dart-define=TMDB_IMAGE_BASE_URL=https://image.tmdb.org/t/p/w500
```

If `TMDB_API_KEY` is omitted, the app uses bundled mock data.

## Build

```sh
flutter build ios
```

Android is scaffolded for portability, but the product direction and UI are iOS-first.

## Run

```sh
flutter run
```

The default run uses mock data. Add `--dart-define=TMDB_API_KEY=...` for live TMDB-style data.

## Test

```sh
dart format .
flutter analyze
flutter test --coverage
```

## Known Limitations

- Live API image URL normalization is minimal because mock data already stores full image URLs.
- Authentication, account sync, and remote watchlists are out of scope.
- Offline cache beyond local watchlist/ratings is not implemented.
- App version is displayed as a placeholder in the About screen.
