# Testing

## Coverage

The current suite covers:

- TMDB-style media model parsing for movies and TV shows
- Repository fallback behavior when no API key is configured
- Watchlist add/remove controller behavior
- Personal rating save/update controller behavior
- Discover screen rendering with trending media
- Watchlist screen rendering with saved media and personal ratings

## Run Tests

```sh
dart format .
flutter analyze
flutter test --coverage
```

Coverage output is written to `coverage/lcov.info`.

## Coverage Target

Target at least 70% line coverage for core domain, repository, and controller code. Widget tests should cover the main happy paths for user-facing screens.

## Known Untested Areas

- Live TMDB network success and failure branches with Dio mocks
- Details screen interaction flow for rating selection and watchlist toggling
- iOS simulator manual run and visual regression checks
- Edge cases for corrupt persisted JSON
