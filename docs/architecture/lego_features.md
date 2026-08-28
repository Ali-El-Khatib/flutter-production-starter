# LEGO Feature Replaceability & Swapping Guide

This document explains the **LEGO Feature Replaceability** model used in the Flutter Production Starter architecture.

---

## 🧱 What is a LEGO Feature Brick?

A LEGO feature brick is an isolated business capability (e.g. `auth`, `profile`, `settings`) with:
1. **A clear public contract**: Exported through `lib/features/<feature>/<feature>.dart`.
2. **Internal encapsulation**: Data sources, DTOs, mappers, and private widgets remain completely private to the feature.
3. **Substitutability**: The entire feature implementation can be replaced with a different brick without modifying the rest of the application.

```text
                    APPLICATION
                         │
                         ▼
                  Feature Contract (e.g. AuthRepository)
                         ▲
                         │
              ┌──────────┴──────────┐
              │                     │
         auth (V1)             auth_v2 (Demo)
        Current Brick         Alternative Brick
              │                     │
              └────── Developer ────┘
                   chooses one
```

---

## 🔄 Why Does `auth_v2` Exist?

`auth_v2` is intentionally included as a **demonstration brick**.

It proves that:
- You can develop and test an alternative authentication strategy (e.g. Supabase, Firebase, OAuth2/PKCE, Mock) in parallel.
- You can evaluate the replacement without modifying domain use cases, route guards, or UI pages.
- You can delete the unused implementation whenever you're ready with zero residual impact.

> **Important**: `auth_v2` is NOT a runtime multi-version selector or feature flag system. In a production app, exactly **one** implementation is active at a time.

---

## 🛠️ Step-by-Step: How to Manually Swap a Feature Brick

Here is the exact exercise for replacing `auth` with `auth_v2`:

### Step 1: Remove Active DI Registration from V1
Open `apps/mobile/lib/features/auth/data/repositories/auth_repository_impl.dart`:
```dart
// Remove or comment out:
// @LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository { ... }
```

### Step 2: Register the Replacement Brick (V2)
Open `apps/mobile/lib/features/auth_v2/data/repositories/auth_v2_repository_impl.dart`:
```dart
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuthRepository)
class AuthV2RepositoryImpl implements AuthRepository { ... }
```

### Step 3: Re-run Code Generation
```bash
melos run generate
```

### Step 4: Validate the Application
Run static analysis and the test suite:
```bash
melos run analyze
melos run test
```

### Step 5: Test the App
Launch the app with the new brick active:
```bash
melos run run:dev
```

### Step 6: Delete or Promote
- If V2 is your new permanent authentication system: delete `apps/mobile/lib/features/auth/` and promote `auth_v2` to `auth`.
- If you want to revert: re-enable `@LazySingleton(as: AuthRepository)` on `AuthRepositoryImpl` and run `melos run generate`.

---

## 🛡️ The Blast Radius Guarantee

When replacing a LEGO brick, your Git diff should only touch:
- The feature folders (`features/auth/`, `features/auth_v2/`)
- The generated DI configuration (`injection.config.dart`)
- Feature-specific tests

It will **never** force edits to:
- `packages/app_network`, `packages/app_storage`, `packages/design_system`
- Other features (`profile`, `settings`, `home`)
- Shared routing and global application bootstrap
