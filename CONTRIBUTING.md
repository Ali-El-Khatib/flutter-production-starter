# Contributing to Flutter Starter Architecture

Thank you for contributing to this production-oriented Flutter starter architecture.

If this is your first Flutter monorepo contribution, please start with
[A Friendly Start for Beginners](./Instructions_For_Beginners.md). You are not
expected to understand every package before making a focused change.

---

## 🏛️ Architectural Principles

Before contributing, please read [ARCHITECTURE.md](./ARCHITECTURE.md):
1. **LEGO Module Boundaries**: Features in `apps/mobile/lib/features/` must be self-contained and export their public API only via `feature/feature.dart`.
2. **One-Directional Dependencies**: Shared packages (`packages/*`) must never depend on application features.
3. **Constructor Injection**: Use GetIt + Injectable with constructor injection. Avoid global service location in domain/data.
4. **No Premature Abstraction**: Simple features should stay simple. Avoid unnecessary use cases or datasources unless justified.

---

## 🛠️ Development Workflow

### 1. Resolve Workspace Dependencies
```bash
flutter pub get
```

### 2. Code Generation (if using Injectable or Freezed)
```bash
dart run melos run generate
```

### 3. Verification Gates
Before submitting a PR, ensure all checks pass:
```bash
dart run melos run format:check
dart run melos run analyze
dart run melos run test
```

---

## 📝 Pull Request Guidelines

1. Fork the repo and create your branch from `main`.
2. Ensure new features or packages have unit/widget tests.
3. Run `dart run melos run format` to ensure standard formatting.
4. Submit your Pull Request with a clear summary of changes.

Generated source must be current. CI runs generation followed by
`git diff --exit-code`, so generator inputs and committed output cannot drift.
