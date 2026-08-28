# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.2.0] - 2026-08-29

### 🚀 Added
- **Package-Level LEGO Feature Extraction**: Promoted authentication to true standalone workspace packages:
  - `packages/features/auth_contract`: Pure domain contracts (`User`, `AuthSession`, `AuthRepository`).
  - `packages/features/auth`: Full Clean Architecture implementation with BLoC Signals, Dio, and secure storage.
  - `packages/features/auth_v2`: Alternative auth implementation with zero coupling to `feature_auth`, proving contract-level swappability.
- **In-App Feature Pragmatism**: Retained app-level composition (`home`), user preferences (`settings`), and domain profile (`profile`) within `apps/mobile/lib/features/` to prevent unnecessary package ceremony.
- **Architectural Rules Guide**: Updated `docs/architecture/lego_features.md` and `README.md` clarifying when to keep features in-app vs when to promote them to packages.

### 📦 Commits
- [`3d30031`](https://github.com/Ali-El-Khatib/flutter-production-starter/commit/3d30031) — `feat: extract auth to package-level LEGO bricks and retain in-app features`

---

## [1.1.0] - 2026-08-28

### 🚀 Added
- **Dart 3.6+ Pub Workspaces Support**: Native monorepo package resolution, shared lockfile (`pubspec.lock`), and unified `.dart_tool/` context at the workspace root.
- **LEGO Pluggability & Substitutability**: Added comprehensive contract tests (`auth_pluggability_test.dart`) and architectural documentation (`docs/architecture/lego_features.md` and `apps/mobile/lib/features/auth_v2/README.md`) demonstrating zero-blast-radius manual feature brick swapping.
- **Root Workspace Pubspec**: Added `workspace:` configuration in root `pubspec.yaml` declaring all 6 packages.

### 🔄 Changed
- **Package Linking**: Replaced all 11 internal `path: ../..` dependencies across member packages with standard workspace version constraints (`^0.0.1`).
- **Melos Optimization**: Removed legacy `usePubspecOverrides: true` in `melos.yaml`; Melos now focuses purely on task runner orchestration (`test`, `analyze`, `generate`, `format`).
- **Documentation**: Updated `README.md` and `ARCHITECTURE.md` to document the Pub Workspaces + Melos hybrid model and LEGO feature replaceability.

### 📦 Commits
- [`5688e71`](https://github.com/Ali-El-Khatib/flutter-production-starter/commit/5688e71) — `docs: standardize all workspace commands to flutter pub get and dart run melos`
- [`90f156d`](https://github.com/Ali-El-Khatib/flutter-production-starter/commit/90f156d) — `docs: update CHANGELOG.md with complete commit index`
- [`ce8cdf9`](https://github.com/Ali-El-Khatib/flutter-production-starter/commit/ce8cdf9) — `ci: resolve Pub Workspace natively with flutter pub get`
- [`a9f893b`](https://github.com/Ali-El-Khatib/flutter-production-starter/commit/a9f893b) — `docs: add LEGO feature replaceability guide and contract substitutability tests`
- [`b89f2d4`](https://github.com/Ali-El-Khatib/flutter-production-starter/commit/b89f2d4) — `docs: add CHANGELOG.md to repository tree in README.md`
- [`507a814`](https://github.com/Ali-El-Khatib/flutter-production-starter/commit/507a814) — `docs: add CHANGELOG.md with release history and commit references`
- [`21b5449`](https://github.com/Ali-El-Khatib/flutter-production-starter/commit/21b5449) — `feat: migrate monorepo to Dart 3.6+ Pub Workspaces + Melos hybrid`
- [`fa7845d`](https://github.com/Ali-El-Khatib/flutter-production-starter/commit/fa7845d) — `chore: remove residual desktop and web platform directories`

---

## [1.0.0] - 2026-08-28

### 🚀 Initial Release
- **Monorepo Architecture**: Melos-orchestrated monorepo containing `apps/mobile` and 5 shared packages (`app_core`, `app_network`, `app_storage`, `design_system`, `app_lints`).
- **Feature-First LEGO Modules**:
  - `features/auth/` (Complex Clean Architecture with Use Cases, DTOs, and Token Storage)
  - `features/auth_v2/` (Pluggable alternate implementation)
  - `features/profile/` (Medium Clean Architecture with Repository Contract)
  - `features/settings/` (Simple Presentation + State)
  - `features/home/` (Dashboard & navigation overview)
- **Infrastructure & Networking**:
  - Centralized `DioFactory` with retry logic, bearer token authorization, and sensitive payload redaction.
  - Functional `Result<T>` and domain `Failure` taxonomy with `FailureMessageResolver`.
  - Storage abstractions for `SecureStorage`, `KeyValueStorage`, and TTL-based `MemoryCache`.
- **UI & Presentation**:
  - Design System with design tokens (Spacing, Radius, Durations), Light/Dark themes, and reusable UI primitives.
  - Declarative routing and route guards with `kaisel: ^1.1.0`.
  - Reactive state management with `bloc_signals` + `signals_flutter`.
  - Presentation-only feedback with `toastification: ^3.2.0`.
- **Quality Gates**: 100% test coverage and GitHub Actions CI workflow (`.github/workflows/ci.yml`).

### 📦 Commits
- [`8784599`](https://github.com/Ali-El-Khatib/flutter-production-starter/commit/8784599) — `feat: initial commit of production-grade Flutter starter monorepo`
