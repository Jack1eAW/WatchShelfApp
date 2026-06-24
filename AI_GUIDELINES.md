# AI Guidelines

These rules apply to future AI-assisted changes in WatchShelf.

## General Rules

- Keep the feature-first structure intact.
- Prefer small, cohesive files over large multi-purpose files.
- Keep business logic out of widgets.
- Do not hardcode secrets or API keys.
- Preserve the mock fallback path so the app runs without live API setup.
- Add comments only when they clarify non-obvious intent.

## Permitted Changes

- Add new features inside the relevant `features/*` module.
- Add repository methods through domain interfaces first.
- Add focused tests for new controllers, repositories, and screens.
- Refine Cupertino styling while preserving iOS-first interaction patterns.

## High-Risk Areas

- Routing changes in `lib/app/router.dart`
- Persistence schema changes in `LocalStore`
- API client behavior and environment configuration
- Watchlist and rating key format
- Cross-feature provider dependencies

## Mandatory Checks Before Committing

```sh
dart format .
flutter analyze
flutter test --coverage
```

Also perform a manual simulator run before merging user-facing UI changes.

## Review Requirements

Require code review for architecture, persistence, routing, and API changes. Include migration notes for any persistence schema change.
