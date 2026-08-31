# A Friendly Start for Beginners

Welcome. If this repository looks like a lot at first, that reaction is normal.

You do **not** need to understand every package, architectural layer, or tool
before you run the app or change your first screen. This starter is structured
to support large applications later, but you can begin with one small feature
today.

This guide is intentionally practical. Follow only the section that matches
what you are trying to do.

## What You Need Before Starting

- Flutter `3.47.0`
- Git
- An editor such as VS Code or Android Studio
- An Android emulator, iOS simulator, desktop target, or connected device

Check your Flutter installation:

```bash
flutter --version
flutter doctor
flutter devices
```

Do not worry if `flutter doctor` reports a platform you do not plan to use. For
example, you do not need the Android toolchain to work only on Flutter web.

## Your First Ten Minutes

From the repository root, run:

```bash
flutter pub get
dart run melos bootstrap
dart run melos run generate
dart run melos run run:dev
```

The development environment uses explicit demo implementations, so you can
explore authentication and profile behavior without connecting a backend.

If Flutter asks you to select a device, list the available choices with:

```bash
flutter devices
```

You have completed the first step when the development app opens. You do not
need to read the entire architecture guide before continuing.

## The Smallest Useful Mental Model

Think about the repository as three areas:

```text
apps/mobile/        The application you run
packages/           Reusable building blocks used by the application
pubspec.yaml        Workspace membership and shared Melos commands
```

Inside the mobile application:

```text
apps/mobile/lib/app/         App startup, routing, configuration, and DI
apps/mobile/lib/features/    Home, profile, settings, and future app features
```

Most beginners adding normal product functionality should start in:

```text
apps/mobile/lib/features/
```

You probably do not need to create a package.

## Where Should My Code Go?

Use these examples as a starting point:

| You want to... | Start here |
|---|---|
| Change the home screen | `apps/mobile/lib/features/home/presentation/pages/home_page.dart` |
| Change settings | `apps/mobile/lib/features/settings/` |
| Add profile behavior | `apps/mobile/lib/features/profile/` |
| Change login UI or behavior | `packages/features/auth/` |
| Add a reusable button or input | `packages/design_system/` |
| Change HTTP configuration | `packages/app_network/` and app DI |
| Store a token or preference | `packages/app_storage/` |
| Add a new app-specific feature | `apps/mobile/lib/features/<feature_name>/` |

Keep a feature inside the app unless you have a real reason to reuse or own it
independently. A folder does not need `data`, `domain`, and `presentation`
layers when the feature is still simple.

## A Safe First Change

Try changing a piece of text or a widget in:

```text
apps/mobile/lib/features/home/presentation/pages/home_page.dart
```

Then format and analyze your change:

```bash
dart run melos run format
dart run melos run analyze
```

Run the development app again and confirm what changed. This small loop—edit,
format, analyze, run—is enough while you are learning the repository.

## Adding a New Feature Without Overthinking It

Begin with the smallest structure that works:

```text
apps/mobile/lib/features/tasks/
├── presentation/
│   └── pages/
│       └── tasks_page.dart
└── tasks.dart
```

The `tasks.dart` file is the feature's public entry point. Export only what
other features or the application router need.

Add state, repositories, data sources, and domain contracts only when the
feature develops behavior that needs them. Architecture should help you manage
complexity; it should not make a simple screen difficult to create.

## Turning This Starter Into Your Application

You do not need to customize everything on the first day. Work through this
checklist gradually:

1. Choose your product name and supported platforms.
2. From a clean Git working tree, run the guided setup:

   ```bash
   dart run scripts/configure_app.dart
   ```

   It asks for the product name and one application ID such as
   `com.yourcompany.your_product`, previews the files it will update, and waits
   for confirmation. It updates the Android namespace/application ID and
   launcher label, moves `MainActivity`, updates iOS bundle identifiers and
   names, and keeps the environment-specific app names consistent.
3. Replace the example API URLs in
   `apps/mobile/lib/app/config/app_config.dart`.
4. Add product splash artwork under `apps/mobile/assets/app/branding/`, update
   `apps/mobile/flutter_native_splash.yaml`, and run
   `dart run melos run generate`.
5. Connect one development API flow before connecting every feature.
6. Keep the demo implementations available only in development and test.
7. Remove sample features only after you understand whether they provide a
   useful reference for your team.
8. Configure signing credentials through local or CI secrets; never commit
   private keys or passwords.
9. Run staging on a real device before treating the application as release
   ready.

It is fine to keep the architecture and replace the example product behavior
one feature at a time. A starter should reduce your decisions, not force you to
finish every setup task before building something useful.

For a repeatable non-interactive setup, use:

```bash
dart run scripts/configure_app.dart --name "Your Product" --id com.yourcompany.your_product
```

Add `--dry-run` whenever you want to see the complete plan without changing
anything. The script intentionally leaves the Dart package name `mobile`
alone; that is an internal workspace name and does not appear as the installed
application identity.

## Words You Will See in This Repository

You do not need to memorize these definitions.

- **Feature**: code that belongs to one product capability, such as profile or
  authentication.
- **Package**: a reusable or independently owned Dart/Flutter building block.
- **Contract**: a stable interface describing what behavior is available.
- **Repository**: code that provides domain data without exposing HTTP or
  storage details to the UI.
- **Dependency injection (DI)**: constructing objects and supplying their
  dependencies in one controlled composition area.
- **Barrel file**: a small public Dart file such as `profile.dart` that exports
  only the feature API consumers should use.
- **Pub Workspace**: Dart's native way of resolving the packages in this
  repository with one lockfile.
- **Melos**: the tool that runs the same command across the correct workspace
  members.
- **Generated file**: source created by a generator. Do not edit files ending
  in `.g.dart`, `.freezed.dart`, or `.config.dart` manually.

## Development, Staging, Production, and Test

The environments intentionally behave differently:

| Environment | What to expect |
|---|---|
| Development | Demo auth/profile behavior so the starter works without a backend |
| Staging | Real API behavior and honest failures |
| Production | Real API behavior with production logging disabled |
| Test | Deterministic in-memory storage and demo implementations |

Do not add a fallback that turns a failed staging or production request into
fake success data. If you need sample behavior, add an explicit demo
implementation and select it through configuration.

## Before Opening a Pull Request

Run the same core checks used by CI:

```bash
dart run melos run generate
dart run melos run format:check
dart run melos run analyze
dart run melos run test
```

If you changed mobile behavior, it is also helpful to run:

```bash
dart run melos run coverage:mobile
dart run melos run coverage:check
```

Do not manually change generated files to make a check pass. Change the source
or annotation and run generation again.

## Common Problems

### `flutter` is not recognized

Flutter is not installed or its `bin` directory is missing from your system
`PATH`. Follow the official Flutter installation guide for your operating
system, restart the terminal, and run `flutter doctor`.

### Dependency resolution fails

Confirm that you are at the repository root and using the supported Flutter
version. Then retry:

```bash
flutter pub get
dart run melos bootstrap
```

Network, proxy, or TLS errors can come from the package server rather than your
code. Read the complete error before changing a `pubspec.yaml` constraint.

### Code generation reports stale or conflicting output

Run:

```bash
dart run melos run generate
```

If it still fails, include the full generator message when asking for help.

### A test cannot use secure storage or preferences

Use the test configuration and in-memory storage adapters. Widget and unit
tests should not depend on native platform plugins unless they are integration
tests designed for a real device.

### The architecture still feels confusing

Start from the page you can see on screen and follow its imports one step at a
time. You are not expected to understand the entire dependency graph before
making a focused contribution.

## How to Ask for Help

Questions are welcome. A useful issue or discussion includes:

- What you were trying to do.
- The command you ran.
- The complete error message.
- Your output from `flutter --version`.
- Your operating system and target platform.
- What you already tried.

There is no shame in asking about routing, state, DI, tests, Git, or where a
file belongs. Everyone who understands these tools today had a first day with
them.

## When You Are Ready to Go Deeper

Read these documents in this order:

1. [README.md](README.md) for commands and workspace behavior.
2. [ARCHITECTURE.md](ARCHITECTURE.md) for dependency direction and boundaries.
3. [docs/architecture/lego_features.md](docs/architecture/lego_features.md) for
   deciding whether a feature belongs in the app or a package.
4. [CONTRIBUTING.md](CONTRIBUTING.md) before submitting a pull request.

Take it one feature at a time. Clear, tested, understandable code is more
valuable than using every architectural pattern at once.
