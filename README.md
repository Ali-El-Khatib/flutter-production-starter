# Flutter Production Starter Architecture

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-3.14%2B-02569B?logo=flutter)](https://flutter.dev)
[![Architecture: LEGO Monorepo](https://img.shields.io/badge/Architecture-Modular%20LEGO%20Clean-success)](./ARCHITECTURE.md)
[![Melos](https://img.shields.io/badge/Maintained%20with-Melos-24292e.svg)](https://melos.invertase.dev)

A scalable, production-oriented Flutter starter repository and architecture template designed for fast feature development, low coupling, high testability, and long-term maintainability.

---

## 🚀 Architecture Highlights

- **Dart 3.6+ Pub Workspaces + Melos**: Native multi-package resolution with shared lockfile and zero `path:` overrides, combined with Melos task orchestration.
- **Feature-First LEGO Modules**: Isolated business capabilities (`auth`, `profile`, `settings`, `home`) exposing intentional public APIs (`feature/feature.dart`).
- **Pragmatic Clean Architecture**: Lightweight presentation where simple, structured data/domain contracts where complexity requires them.
- **Declarative Routing**: Strongly-typed routing and route guards with [`kaisel: ^1.1.0`](https://pub.dev/packages/kaisel).
- **Reactive State Management**: Fine-grained signals with `bloc_signals`, `bloc_signals_flutter`, and `signals_flutter`.
- **Dependency Injection**: Constructor injection with `get_it` and `injectable`.
- **Centralized Networking**: Centralized `dio` with automatic retry, bearer token management, sensitive log sanitization, and strongly typed `Result<T>` mapping.
- **Predictable Error Pipeline**: Domain `Failure` taxonomy with `FailureMessageResolver` and presentation-layer `toastification: ^3.2.0`.
- **Dedicated Design System**: Standalone `design_system` package with tokens (`Spacing`, `Radius`, `Durations`), theme definitions (`AppTheme`), and reusable UI primitives.
- **LEGO Feature Replaceability**: Features can be replaced (e.g. `auth` ➔ `auth_v2`) via single-point DI binding without touching domain use cases, route guards, or UI callers. Read the [LEGO Features Guide](docs/architecture/lego_features.md).

---

## 📁 Repository Structure

```text
/
├── apps/
│   └── mobile/                # Main Flutter application (Bootstrap, DI, Routes, Features)
├── packages/
│   ├── app_core/              # Stable primitives (Result<T>, Failures, Exceptions, AppLogger)
│   ├── app_network/           # Centralized Dio, interceptors, error mappers, ApiClient
│   ├── app_storage/           # Storage contracts (SecureStorage, KeyValueStorage, MemoryCache)
│   ├── design_system/         # Tokens, theme, buttons, text fields, loaders, error states
│   └── app_lints/             # Shared strict analysis and linting configuration
├── melos.yaml                 # Monorepo task runner configuration
├── pubspec.yaml               # Root Pub Workspace configuration
├── ARCHITECTURE.md            # In-depth architectural rules and conventions
├── CHANGELOG.md               # Version history and release notes
└── LICENSE                    # Open Source MIT License
```

---

## 🛠️ Quick Start

### 1. Prerequisites
- Dart SDK `^3.6.0` / Flutter SDK `^3.27.0` (or higher)

### 2. Resolve Workspace Dependencies
Pub Workspaces natively links all workspace members with a single shared lockfile:
```bash
flutter pub get
```

### 3. Run the Mobile App
Run in any configured environment (`development`, `staging`, `production`):
```bash
# Development (default)
dart run melos run run:dev

# Staging
dart run melos run run:staging

# Production
dart run melos run run:prod

# Directly on connected emulator
dart run melos run run:emulator
```

---

## 📜 Monorepo Workspace Commands

Melos is pinned as a root dev dependency (`^6.0.0`) and is executed via `dart run melos`:

| Command | Action |
|---|---|
| `flutter pub get` | Resolve workspace dependencies natively across all packages |
| `dart run melos run format` | Format Dart code across the monorepo |
| `dart run melos run format:check` | Verify code formatting in CI |
| `dart run melos run analyze` | Run `flutter analyze` across all 6 packages |
| `dart run melos run test` | Run all test suites across all packages |
| `dart run melos run generate` | Run `build_runner` code generation (`injectable`, `freezed`) |
| `dart run melos run clean` | Clean all Flutter build outputs |
| `dart run melos run run:dev` | Run mobile app in development mode |
| `dart run melos run run:staging` | Run mobile app in staging mode |
| `dart run melos run run:prod` | Run mobile app in production mode |
| `dart run melos run run:emulator` | Run mobile app directly on active emulator (`emulator-5554`) |
| `dart run melos run devices` | List all connected devices |
| `dart run melos run emulators` | List all available emulators |
| `dart run melos run emulators:launch` | Launch Pixel 7 emulator |

---

## 🧩 Reference Features

1. **Settings** (`features/settings/`): Simple feature showcasing state without unnecessary data/domain ceremony.
2. **Profile** (`features/profile/`): Medium feature showcasing repository contracts, DTO mapping, and Dio communication.
3. **Authentication (Auth V1)** (`features/auth/`): Complete clean architecture demonstrating datasources, use cases, secure token persistence, and route guard integration.
4. **Auth V2 (LEGO Pluggability)** (`features/auth_v2/`): Proves interchangeable implementation behind the same contracts via DI.

---

## 🧪 Testing & Verification

Run the full verification suite across the entire repository:

```bash
flutter pub get
dart run melos run generate
dart run melos run format:check
dart run melos run analyze
dart run melos run test
```

---

## 🤝 Contributing

Contributions are welcome! Please ensure:
1. All changes adhere to [ARCHITECTURE.md](./ARCHITECTURE.md) and [AGENTS.md](./AGENTS.md).
2. All packages pass `dart run melos run format:check`, `dart run melos run analyze`, and `dart run melos run test`.
3. New features export their public API via a root barrel file.

---

## 👤 Author

Created and maintained by **Ali El-Khatib**.

---

## 📄 License

This project is licensed under the MIT License by Ali El-Khatib — see the [LICENSE](./LICENSE) file for details.
