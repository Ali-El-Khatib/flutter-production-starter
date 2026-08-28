# LEGO Feature Replaceability & Swapping Guide

This document explains the **LEGO Feature Architecture** and **Contract-Based Replaceability** model used in the Flutter Production Starter architecture.

---

## 🧭 Architectural Rule: In-App Features vs Feature Packages

Not every feature should automatically be a standalone Dart package. We follow a pragmatic split:

```text
small / simple feature (dashboard, settings, navigation shell)
    ↓
keep in apps/mobile/lib/features/

large / independent business capability (payments, orders, chat)
    ↓
promote to packages/features/<feature>/

needs swappable / multi-provider implementations (auth, payments, sync)
    ↓
extract pure contract into packages/features/<feature>_contract/
implementations into packages/features/<feature>_provider/
```

### Why keep `home` and `settings` in the app?
- **Home**: Often just dashboard composition, navigation shell, and feature launching. This is app-level assembly, not an independently swappable business capability.
- **Settings**: Primarily theme toggles, appearance options, and local preferences without heavy infrastructure. Keeping it in `apps/mobile/lib/features/settings` avoids unnecessary package ceremony.

### Why promote `auth` to package-level LEGO bricks?
- Real architectural weight (tokens, secure storage, Dio interceptors, clean domain models, route guards).
- Multiple distinct implementations can be developed and swapped (e.g. `feature_auth` REST vs `feature_auth_v2` Supabase/Mock) with **compiler-enforced isolation**.

---

## 🧱 The Package-Level LEGO Structure

```text
                               APPLICATION (apps/mobile)
                                         │
                                         ▼
                 ┌───────────────────────────────────────────────┐
                 │    packages/features/auth_contract            │
                 │    • User, AuthSession entities               │
                 │    • AuthRepository pure abstract interface   │
                 └───────────────────────▲───────────────────────┘
                                         │
                         ┌───────────────┴───────────────┐
                         │ implements                    │ implements
                         │                               │
         ┌───────────────────────────────┐ ┌───────────────────────────────┐
         │ packages/features/auth        │ │ packages/features/auth_v2     │
         │ • AuthRepositoryImpl (Dio)    │ │ • AuthV2RepositoryImpl        │
         │ • LoginUseCase, AuthBloc      │ │ • Zero dependency on auth     │
         │ • LoginPage, LoginForm UI     │ │ • Contract-only dependency    │
         └───────────────────────────────┘ └───────────────────────────────┘
```

---

## 🔄 Why Does `auth_v2` Exist?

`auth_v2` is included as a **demonstration brick**.

It proves that:
- You can develop an alternative authentication strategy in parallel.
- `auth_v2` has **zero dependency** on `feature_auth` — both depend exclusively on `auth_contract`.
- You can swap the active implementation via a single line in `apps/mobile/lib/app/di/injection.dart` without modifying route guards, use cases, or consumer UI.

---

## 🛠️ Step-by-Step: How to Swap a LEGO Feature Brick

Here is the exact exercise for switching between `feature_auth` and `feature_auth_v2`:

### Step 1: Switch DI Registration
Open `apps/mobile/lib/app/di/injection.dart`:
```dart
// To use feature_auth (Default):
import 'package:feature_auth/feature_auth.dart';
registerAuthFeature(getIt);

// To use feature_auth_v2:
// import 'package:feature_auth_v2/feature_auth_v2.dart';
// registerAuthV2Feature(getIt);
```

### Step 2: Validate the Application
Run static analysis and the test suite:
```bash
flutter pub get
dart run melos run analyze
dart run melos run test
```

### Step 3: Run the App
```bash
dart run melos run run:dev
```

---

## 🛡️ The Blast Radius Guarantee

When replacing or updating a LEGO brick, your Git diff is strictly contained:
- `packages/features/<feature>/`
- Single registration line in `apps/mobile/lib/app/di/injection.dart`

It will **never** force edits to:
- `packages/app_network`, `packages/app_storage`, `packages/design_system`
- In-app features (`home`, `profile`, `settings`)
- Application bootstrap and navigation guards
