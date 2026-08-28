# Auth V2 (LEGO Replaceability Demonstration)

`auth_v2` is intentionally included as a demonstration of the **LEGO Modular Architecture**.

It represents an alternative implementation of the authentication feature that can be evaluated and swapped without rewriting the rest of the application.

---

## 🎯 Purpose

This folder is **not** intended to remain permanently in every project, nor does it represent a multi-version runtime framework.

As a developer, you may:
- **Keep `auth`** and delete `auth_v2`.
- **Replace `auth` with `auth_v2`** by changing the DI registration binding.
- **Build another auth implementation** (e.g. Firebase, Supabase, OAuth2, Mock).
- **Remove both** and provide your own custom authentication brick.

The goal is to demonstrate architectural freedom and clean boundaries with a minimal blast radius.

---

## 🔄 How to Swap to Auth V2

To evaluate `auth_v2` in place of `auth`:

1. Open `apps/mobile/lib/features/auth/data/repositories/auth_repository_impl.dart` and remove or comment `@LazySingleton(as: AuthRepository)`.
2. Open `apps/mobile/lib/features/auth_v2/data/repositories/auth_v2_repository_impl.dart` and add `@LazySingleton(as: AuthRepository)`:
   ```dart
   import 'package:injectable/injectable.dart';

   @LazySingleton(as: AuthRepository)
   class AuthV2RepositoryImpl implements AuthRepository {
     ...
   }
   ```
3. Run code generation:
   ```bash
   melos run generate
   ```
4. Verify the rest of the application (screens, route guards, use cases, BLoCs) runs without a single line changed:
   ```bash
   melos run analyze
   melos run test
   melos run run:dev
   ```
