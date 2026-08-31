# Architecture Guide

## 1. Hybrid monorepo

The repository combines two complementary tools:

```text
Pub Workspaces                     Melos
-------------------------------    --------------------------------
dependency resolution              command orchestration
native local package linking       generation, analysis, and tests
one shared lockfile                app environment commands
no path overrides                  CI-compatible workspace scripts
```

The root `pubspec.yaml` is the authoritative workspace inventory and contains
the Melos 8 script catalog. Every member uses `resolution: workspace`, so Melos
orchestrates the same native Pub workspace instead of creating path overrides.

## 2. Feature placement

Features begin inside `apps/mobile/lib/features/`. Extract a feature only when
there is evidence for independent ownership, reuse, lifecycle, or a stable
contract.

Current placement:

```text
apps/mobile/lib/features/
├── home/                       # application dashboard composition
├── profile/                    # app-owned profile capability
└── settings/                   # app-owned user preferences

packages/features/
├── auth_contract/              # pure Dart public domain contract
└── auth/                       # authentication implementation and UI
```

Authentication is one feature with one production implementation. Its contract
is separate so consumers and tests depend on stable entities and repository
behavior without importing data internals.

## 3. Dependency direction

```text
Presentation -> use cases/contracts <- data -> shared infrastructure
```

- Presentation never handles Dio exceptions.
- Domain contracts do not depend on Flutter UI.
- Shared packages never depend on application features.
- Cross-feature consumers use intentional public libraries.
- DTOs, data sources, repository implementations, and storage keys remain
  internal unless composition genuinely requires them.

The pure Dart base is:

```text
auth_contract -> app_core
app_network   -> app_core
```

Flutter-specific packages are `mobile`, `app_storage`, `design_system`, and
`feature_auth`.

## 4. Application composition

`apps/mobile/lib/app/` owns:

- environment configuration
- GetIt/Injectable initialization
- infrastructure adapters
- environment-specific demo selection
- bearer-token wiring
- authenticated route guards
- application routing and top-level widgets

Feature packages expose a narrow registration function where feature-owned DI
is clearer than placing every registration in generated application code.

## 5. Environment boundary

Development sample behavior is explicit composition, not error fallback:

```text
development -> DemoAuthRemoteDataSource + DemoProfileRepository
staging     -> real ApiClient implementations
production  -> real ApiClient implementations
test        -> demo data + in-memory storage
```

Therefore a timeout, 404, or server error in staging/production remains a typed
failure. It can never silently authenticate a user or fabricate profile data.

## 6. Authentication and storage

The application installs this path:

```text
FlutterSecureStorageAdapter
        -> auth repository session persistence
        -> TokenProvider
        -> Dio AuthInterceptor
```

The router reads the application-wide `AuthBloc` state through
`AuthRouteGuard`. Bootstrap restores auth and settings state before `runApp`.

Sensitive values use `flutter_secure_storage`. Non-sensitive preferences use
`SharedPreferencesAsync`. In-memory implementations are test-only and selected
by `AppConfig.test()`.

## 7. Error pipeline

```text
Dio / storage / payload error
            -> stable Failure
            -> Result<T>
            -> feature state
            -> FailureMessageResolver
            -> inline UI / feedback
```

`DataContractFailure` identifies structurally invalid backend payloads without
leaking raw data to users. Unexpected diagnostic context stays behind
`AppLogger` sanitization.

## 8. State management

Feature state uses `bloc_signals`. State belongs to the feature that owns the
behavior. Application-wide auth and settings state are shared intentionally;
screen-scoped profile state remains factory-created.

Persistence is explicit through storage contracts. Hydration is not installed
until a concrete restorable-state use case justifies it.

## 9. Asset and font ownership

Runtime resources follow the same ownership rules as source code. There is no
generic repository-level `shared/assets` directory.

| Resource | Owner |
|---|---|
| Product branding and application-wide artwork | `apps/mobile/assets/app/` |
| Assets for a feature inside the app | `apps/mobile/assets/features/<feature>/` |
| Reusable design-system icons and illustrations | `packages/design_system/assets/` |
| Assets for an extracted feature | That feature package's `assets/` directory |
| Licensed typography shared through the design system | `packages/design_system/lib/fonts/` |
| README screenshots and architecture diagrams | `docs/assets/` |
| Test fixtures and golden files | The owning package's `test/` directory |

Each Flutter package declares only its own non-empty asset directories. Package
assets are loaded with an explicit package name. Nested directories are listed
explicitly in the owning pubspec rather than relying on recursive inclusion.

The starter uses platform system fonts by default. A consuming product may add
licensed font files under `packages/design_system/lib/fonts/`, declare them from
the application pubspec with `packages/design_system/fonts/...` paths, and apply
the family centrally through `AppTheme`.

The README files inside the asset roots document the expected layout. Pubspec
entries and typed asset APIs are introduced only when real resources exist; the
starter does not ship placeholder images, fonts, or dead asset declarations.

Platform launcher icons and launch screens remain in their Android and iOS
resource catalogs. Static launch screens are generated from
`apps/mobile/flutter_native_splash.yaml`; manual platform customization is the
escape hatch for requirements the generator cannot represent. The generated
native files are committed and verified by the workspace generation gate.
Secrets and environment credentials are never assets.

## 10. Product identity setup

`scripts/configure_app.dart` is first-party, dependency-free onboarding
automation for the product name and native Android/iOS identifiers. It builds
and validates the complete change plan before writing, moves the Kotlin
`MainActivity` to match its new package, and preserves target suffixes such as
`.RunnerTests`.

The command requires a clean Git working tree by default and offers a dry-run
preview. It does not rename the internal Dart package `mobile`, edit signing
configuration, or run automatically during generation or CI. Those boundaries
keep one-time product setup separate from repeatable build automation.

## 11. Generated code

Injectable output and native launch-screen output are committed. Generator
inputs are authoritative; generated files are never edited manually unless a
documented product requirement has explicitly selected native ownership.

```bash
dart run melos run generate
git diff --exit-code
```

CI performs both commands before analysis and tests.

## 12. Verification contract

Required source-level gates:

```bash
flutter pub get
dart run melos run generate
dart run melos run format:check
dart run melos run analyze
dart run melos run test
dart run melos run coverage:mobile
```

CI additionally compiles the production entry point as a release APK. Store
signing, backend integration, physical-device testing, and product-specific
security review remain release responsibilities for the consuming application.
