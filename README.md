# Flutter Production Starter Architecture

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-3.47.0-02569B?logo=flutter)](https://flutter.dev)
[![Architecture](https://img.shields.io/badge/Architecture-Hybrid%20Monorepo-success)](ARCHITECTURE.md)
[![CI](https://github.com/Ali-El-Khatib/flutter-production-starter/actions/workflows/ci.yml/badge.svg)](https://github.com/Ali-El-Khatib/flutter-production-starter/actions/workflows/ci.yml)

A production-oriented Flutter starter that combines Dart Pub Workspaces for
native package resolution with Melos for repeatable workspace automation.

New to Flutter architecture or monorepos? Start with
[A Friendly Start for Beginners](Instructions_For_Beginners.md). You can run
and modify the development app without understanding every package first.

## Architecture

- **Pub Workspaces** provide native local linking and one shared lockfile.
- **Melos** orchestrates formatting, generation, analysis, tests, coverage, and
  application commands.
- **Feature-first ownership** keeps small features inside the mobile app.
- **Package extraction is selective**: authentication is packaged because it
  has an independent contract, infrastructure, state, and UI boundary.
- **Centralized infrastructure** owns Dio, secure storage, preferences, errors,
  logging, and design primitives.
- **Production-safe composition** installs bearer-token injection, authenticated
  route guards, platform secure storage, and durable preferences.
- **Honest demo behavior** is selected only by development configuration; failed
  staging and production requests remain failures.

See [ARCHITECTURE.md](ARCHITECTURE.md) and the
[feature packaging guide](docs/architecture/lego_features.md).

## Workspace layout

```text
/
├── apps/mobile/                    # Flutter application and in-app features
├── packages/
│   ├── app_core/                   # Pure Dart result, failure, and logging APIs
│   ├── app_lints/                  # Shared strict analyzer configuration
│   ├── app_network/                # Pure Dart Dio infrastructure
│   ├── app_storage/                # Secure storage, preferences, and memory cache
│   ├── design_system/              # Flutter tokens, themes, and UI primitives
│   └── features/
│       ├── auth_contract/          # Pure Dart auth entities and repository contract
│       └── auth/                   # Auth data, use cases, state, UI, and DI
├── .github/workflows/ci.yml
├── pubspec.yaml                     # Pub workspace and Melos 8 configuration
└── pubspec.lock
```

Melos orchestrates eight members: the mobile application and seven packages.
`dart pub workspace list` also reports the root configuration package, which
owns the shared lockfile and Melos script catalog.

## Requirements

- Flutter `3.47.0`
- Dart version bundled with Flutter `3.47.0`
- Android API 23 or newer

CI pins Flutter `3.47.0`. Use the same SDK locally for reproducible results.

## Quick start

```bash
flutter pub get
dart run melos run generate
dart run melos run format:check
dart run melos run analyze
dart run melos run test
dart run melos run run:dev
```

Development uses explicit sample adapters so the starter can be explored
without a backend. Staging and production use the configured APIs and never
convert transport/server failures into sample success data.

Replace the reserved example base URLs in
`apps/mobile/lib/app/config/app_config.dart` before connecting a backend.

## Workspace commands

| Command | Purpose |
|---|---|
| `flutter pub get --enforce-lockfile` | Resolve the native Pub Workspace reproducibly |
| `dart run melos bootstrap --enforce-lockfile` | Verify Melos sees and bootstraps all members |
| `dart run melos run generate` | Regenerate committed source files |
| `dart run melos run format:check` | Verify formatting |
| `dart run melos run analyze` | Analyze all members with Dart analyzer |
| `dart run melos run test` | Run pure Dart and Flutter suites correctly |
| `dart run melos run coverage:mobile` | Generate mobile LCOV coverage |
| `dart run melos run coverage:check` | Enforce the 60% mobile line-coverage floor |
| `dart run melos run run:dev` | Run the development entry point |
| `dart run melos run run:staging` | Run the staging entry point |
| `dart run melos run run:prod` | Run the production entry point |

Flutter test processes run serially because the Flutter SDK uses a global
startup lock on Windows. Pure Dart analysis and tests remain parallelizable.

## Environment behavior

| Environment | Demo data | Storage | Network logging |
|---|---:|---|---:|
| Development | Yes, explicit adapters | Platform-backed | On |
| Staging | No | Platform-backed | On |
| Production | No | Platform-backed | Off |
| Test | Yes | In-memory fakes | Off |

Tokens are stored through `flutter_secure_storage`; preferences use the modern
asynchronous `shared_preferences` API. Both adapters namespace owned keys.

## Release preparation

The starter deliberately does not commit release signing credentials. Before
shipping an application:

1. Replace `com.yourcompany.mobile` with the product application ID.
2. Configure Android and iOS signing through local/CI secrets.
3. Replace the example API URLs.
4. Run the complete verification suite and a signed release build.
5. Perform device, accessibility, security, and backend integration testing.

## Contributing

If this is your first contribution, begin with
[Instructions_For_Beginners.md](Instructions_For_Beginners.md). Then read
[CONTRIBUTING.md](CONTRIBUTING.md) and [ARCHITECTURE.md](ARCHITECTURE.md).
Pull requests must keep generated code current and pass the same checks as CI.

## License

MIT License. See [LICENSE](LICENSE).
