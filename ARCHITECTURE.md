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

## 9. Generated code

Injectable output is committed. Generator inputs are authoritative; generated
files are never edited manually.

```bash
dart run melos run generate
git diff --exit-code
```

CI performs both commands before analysis and tests.

## 10. Verification contract

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
