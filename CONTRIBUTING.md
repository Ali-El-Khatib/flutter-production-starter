# Contributing to Flutter Starter Architecture

Thank you for your interest in contributing! This project is maintained by **Ali El-Khatib** as a reusable, production-ready Flutter starter architecture.

---

## 🏛️ Architectural Principles

Before contributing, please read [ARCHITECTURE.md](./ARCHITECTURE.md) and [AGENTS.md](./AGENTS.md):
1. **LEGO Module Boundaries**: Features in `apps/mobile/lib/features/` must be self-contained and export their public API only via `feature/feature.dart`.
2. **One-Directional Dependencies**: Shared packages (`packages/*`) must never depend on application features.
3. **Constructor Injection**: Use GetIt + Injectable with constructor injection. Avoid global service location in domain/data.
4. **No Premature Abstraction**: Simple features should stay simple. Avoid unnecessary use cases or datasources unless justified.

---

## 🛠️ Development Workflow

### 1. Bootstrap
```bash
melos bootstrap
```

### 2. Code Generation (if using Injectable or Freezed)
```bash
melos run generate
```

### 3. Verification Gates
Before submitting a PR, ensure all checks pass:
```bash
melos run format:check
melos run analyze
melos run test
```

---

## 📝 Pull Request Guidelines

1. Fork the repo and create your branch from `main`.
2. Ensure new features or packages have unit/widget tests.
3. Run `melos run format` to ensure standard formatting.
4. Submit your Pull Request with a clear summary of changes.
