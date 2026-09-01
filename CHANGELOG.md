# Changelog

Notable changes follow [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)
and semantic versioning.

## [Unreleased]

### Added

- A beginner-friendly guide that explains how to run, navigate, modify, and
  contribute to the starter without requiring prior monorepo experience.
- Platform-backed secure token storage and asynchronous preferences storage.
- Bearer-token injection and runtime authentication route guards.
- Explicit development demo adapters with strict staging/production failures.
- Pure Dart analysis/test lanes and serial Flutter test orchestration.
- CI generated-code verification, coverage artifact, and production entry-point
  release build.
- An enforced 60% mobile line-coverage non-regression floor.
- Auth/profile contract validation through `DataContractFailure`.
- A first-party application identity wizard with interactive, flag-based, and
  dry-run modes for synchronized Android, iOS, and Flutter product naming.
- Root-level tests for application identity validation, native identifier
  replacement, Kotlin package relocation, escaping, and repeat configuration.
- Reproducible Android and iOS launch-screen generation through
  `flutter_native_splash` with committed native output.
- Explicit ownership guidance and standard locations for application assets,
  reusable design-system assets, licensed fonts, and documentation media.
- Contributor Covenant, security policy, structured bug/feature/documentation
  issue forms, and a repository-specific pull request template.

### Changed

- Authentication is a single package with a narrow public API.
- `app_core`, `app_network`, and `auth_contract` are pure Dart packages.
- Documentation now matches the actual hybrid workspace and environment model.
- Melos 8 configuration now lives in the root Pub workspace manifest, removing
  legacy `pubspec_overrides.yaml` generation.
- Flutter is pinned to `3.47.0` in CI.
- GitHub checkout and artifact-upload actions now use their Node 24-compatible
  `v7` releases.
- Root analysis and pure-Dart test commands now include first-party repository
  tooling.
- Workspace generation now refreshes both Injectable output and native splash
  resources from their authoritative configuration.
- Beginner, contribution, architecture, and release guidance now cover product
  identity setup, asset ownership, native splash customization, and private
  vulnerability reporting.

### Removed

- The duplicate experimental authentication implementation and substitutability
  demo.
- Hidden network-failure-to-success fallbacks.
- Unused code-generation, hydration, and transitive-only dependencies.
- Template calculator code from `app_lints`.

## [1.2.0] - 2026-08-29

### Added

- Extracted authentication contracts and implementation into workspace
  packages while retaining app-owned home, profile, and settings features.

## [1.1.0] - 2026-08-28

### Added

- Dart Pub Workspaces with a root workspace manifest and shared lockfile.
- Melos task orchestration for generation, formatting, analysis, and tests.

### Changed

- Replaced internal path overrides with native workspace resolution.

## [1.0.0] - 2026-08-28

### Added

- Initial feature-first Flutter monorepo.
- Shared core, network, storage, design-system, and lint packages.
- Authentication, profile, settings, and home reference features.
- GitHub Actions validation workflow.
