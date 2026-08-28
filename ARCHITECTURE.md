# Architecture Guide

This document details the architectural boundaries, principles, and conventions used across the Flutter Production Starter repository.

---

## 1. LEGO Module Boundaries

Features are isolated business modules colocated in `apps/mobile/lib/features/`:

```text
features/
├── auth/
│   ├── auth.dart                 # Public API (Contracts, Entities, Use Cases, Widgets)
│   ├── data/                     # Datasources, models, DTO mappers, repo implementations
│   ├── domain/                   # Entities, repository interfaces, use cases
│   └── presentation/             # BLoC signals, pages, widgets
├── profile/
└── settings/
```

### Boundary Rules
- **Public API Exports Only**: Consumers import via `import 'package:mobile/features/auth/auth.dart';`.
- **Never Deep Import**: Never import private internal paths of another feature (e.g. `../auth/data/...`).
- **No Circular Dependencies**: Feature dependencies must be strictly unidirectional.
- **Pluggability**: Features can be swapped via DI registration without touching other features.

---

## 2. Dependency Direction

```text
┌───────────────────────────────────────────────┐
│               PRESENTATION                    │
│      Pages • Widgets • BLoC Signals           │
└───────────────────────┬───────────────────────┘
                        │
                        ▼
┌───────────────────────────────────────────────┐
│                 DOMAIN                        │
│     Entities • Repository Interfaces • Cases  │
└───────────────────────┬───────────────────────┘
                        ▲
                        │ (implements)
┌───────────────────────┴───────────────────────┐
│                  DATA                         │
│  Repository Impls • Data Sources • DTO Mappers│
└───────────────────────┬───────────────────────┘
                        │
                        ▼
┌───────────────────────────────────────────────┐
│            CENTRALIZED PACKAGES               │
│    app_core • app_network • app_storage       │
└───────────────────────────────────────────────┘
```

- **Domain** is pure Dart and depends on nothing above or below it (except `app_core`).
- **Data** implements domain interfaces and talks to infrastructure (`ApiClient`, `SecureStorage`).
- **Presentation** talks to domain use cases or repository contracts, and consumes `design_system`.
- **No Raw Leaks**: Dio exceptions, HTTP codes, and raw database errors never reach the Presentation layer.

---

## 3. Error Pipeline

```text
Dio / Storage / Platform Error
             ↓
     typed AppException
             ↓
        ErrorMapper
             ↓
          Failure (Domain)
             ↓
         Result<T>
             ↓
    bloc_signals / Signal
             ↓
  FailureMessageResolver
             ↓
  Inline error / Toastification feedback
```

- **Diagnostic Branch**: Unexpected technical exceptions are logged via `AppLogger` with automatic token/credential sanitization.
- **User Facing**: Friendly messages are resolved exclusively through `FailureMessageResolver`.
- **Feedback Separation**: Toasts and snackbars stay in the Presentation layer using `AppFeedback` / `ToastificationFeedback`.

---

## 4. State Management with `bloc_signals`

- Feature state resides in `feature/presentation/state/`.
- State classes encapsulate immutable data.
- Widgets observe signals with `SignalBuilder` or `Watch` without redundant global state.
- Transient one-time effects (e.g. snackbars, toasts, dialogs) are handled via callbacks or state signals.

---

## 5. Dependency Injection

- Powered by `GetIt` + `Injectable`.
- Constructor injection is strictly preferred.
- Environments (`development`, `staging`, `production`) configure infrastructure parameters cleanly.
