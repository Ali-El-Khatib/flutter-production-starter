# Feature Auth V2 (LEGO Replaceability Demonstration Package)

`feature_auth_v2` is intentionally included as an independent package to demonstrate **Package-Level LEGO Replaceability**.

It represents an alternative implementation of the authentication feature that satisfies the same [`auth_contract`](../auth_contract/) boundary.

---

## 🎯 Purpose

This package is **not** a second permanent production authentication system, nor is it a runtime version selector.

As an engineer, you can:
- **Keep `feature_auth`** and delete `feature_auth_v2`.
- **Replace `feature_auth` with `feature_auth_v2`** by simply adjusting the dependency in `apps/mobile/pubspec.yaml` and the DI registration.
- **Build another auth brick** (e.g. Supabase Auth, Firebase Auth, OAuth2/OIDC, Mock).
- **Remove both** and supply your own custom package satisfying `auth_contract`.

---

## 🔄 How to Swap to Feature Auth V2

1. In `apps/mobile/pubspec.yaml`, switch dependency from `feature_auth: ^0.0.1` to `feature_auth_v2: ^0.0.1`.
2. In `apps/mobile/lib/app/di/dependency_injection.dart`, call `registerAuthV2Feature(getIt)`.
3. Verify the rest of the application (Profile, Settings, Home, Route Guards, etc.) runs cleanly without a single line modified:
   ```bash
   dart run melos run analyze
   dart run melos run test
   ```
