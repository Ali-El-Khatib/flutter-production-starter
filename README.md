# Flutter Production Starter Architecture

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-3.14%2B-02569B?logo=flutter)](https://flutter.dev)
[![Architecture: LEGO Monorepo](https://img.shields.io/badge/Architecture-Modular%20LEGO%20Clean-success)](./ARCHITECTURE.md)
[![Melos](https://img.shields.io/badge/Maintained%20with-Melos-24292e.svg)](https://melos.invertase.dev)

A scalable, production-oriented Flutter starter repository and architecture template designed for fast feature development, low coupling, high testability, and long-term maintainability.

---

## 🚀 Architecture Highlights

- **Monorepo Architecture**: Managed with [Melos](https://melos.invertase.dev/) for cross-package linking, testing, and script execution.
- **Feature-First LEGO Modules**: Isolated business capabilities (`auth`, `profile`, `settings`, `home`) exposing intentional public APIs (`feature/feature.dart`).
- **Pragmatic Clean Architecture**: Lightweight presentation where simple, structured data/domain contracts where complexity requires them.
- **Declarative Routing**: Strongly-typed routing and route guards with [`kaisel: ^1.1.0`](https://pub.dev/packages/kaisel).
- **Reactive State Management**: Fine-grained signals with `bloc_signals`, `bloc_signals_flutter`, and `signals_flutter`.
- **Dependency Injection**: Constructor injection with `get_it` and `injectable`.
- **Centralized Networking**: Centralized `dio` with automatic retry, bearer token management, sensitive log sanitization, and strongly typed `Result<T>` mapping.
- **Predictable Error Pipeline**: Domain `Failure` taxonomy with `FailureMessageResolver` and presentation-layer `toastification: ^3.2.0`.
- **Dedicated Design System**: Standalone `design_system` package with tokens (`Spacing`, `Radius`, `Durations`), theme definitions (`AppTheme`), and reusable UI primitives.

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
├── melos.yaml                 # Monorepo workspace configuration
├── pubspec.yaml               # Root workspace pubspec
├── ARCHITECTURE.md            # In-depth architectural rules and conventions
└── LICENSE                    # Open Source MIT License
```

---

## 🛠️ Quick Start

### 1. Prerequisites
- Flutter SDK `^3.14.0` or higher
- Melos CLI:
```bash
dart pub global activate melos
```

### 2. Bootstrap Workspace
Link and resolve all monorepo packages:
```bash
melos bootstrap
```

### 3. Run the Mobile App
Run in any configured environment (`development`, `staging`, `production`):
```bash
# Development (default)
melos run run:dev

# Staging
melos run run:staging

# Production
melos run run:prod

# Directly on connected emulator
melos run run:emulator
```

---

## 📜 Monorepo Workspace Commands

| Command | Action |
|---|---|
| `melos bootstrap` | Link all packages and resolve dependencies |
| `melos run format` | Format Dart code across the monorepo |
| `melos run format:check` | Verify code formatting in CI |
| `melos run analyze` | Run `flutter analyze` across all 6 packages |
| `melos run test` | Run all test suites across all packages |
| `melos run generate` | Run `build_runner` code generation (`injectable`, `freezed`) |
| `melos run clean` | Clean all Flutter build outputs |
| `melos run run:dev` | Run mobile app in development mode |
| `melos run run:staging` | Run mobile app in staging mode |
| `melos run run:prod` | Run mobile app in production mode |
| `melos run run:emulator` | Run mobile app directly on active emulator (`emulator-5554`) |
| `melos run devices` | List all connected devices |
| `melos run emulators` | List all available emulators |
| `melos run emulators:launch` | Launch Pixel 7 emulator |

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
melos bootstrap
melos run generate
melos run format:check
melos run analyze
melos run test
```

---

## 🤝 Contributing

Contributions are welcome! Please ensure:
1. All changes adhere to [ARCHITECTURE.md](./ARCHITECTURE.md) and [AGENTS.md](./AGENTS.md).
2. All packages pass `melos run format:check`, `melos run analyze`, and `melos run test`.
3. New features export their public API via a root barrel file.

---

## 👤 Author

Created and maintained by **Ali El-Khatib**.

---

## 📄 License

This project is licensed under the MIT License by Ali El-Khatib — see the [LICENSE](./LICENSE) file for details.
