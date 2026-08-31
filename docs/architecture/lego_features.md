# Feature Packaging Guide

“LEGO” means clear ownership and a small public API. It does not mean creating
a package for every feature or maintaining duplicate implementations.

## Placement rule

Keep a feature in `apps/mobile/lib/features/` when it is app-specific, small, or
primarily composes other capabilities. Extract it under `packages/features/`
only when independent ownership, reuse, complexity, or a stable contract makes
the package boundary valuable.

## Current decisions

- `home`: app-owned navigation and dashboard composition.
- `settings`: app-owned preferences with durable storage.
- `profile`: app-owned domain/data/presentation example.
- `auth_contract`: pure Dart entities and `AuthRepository` contract.
- `feature_auth`: the single authentication package, including data, use cases,
  state, UI, and feature-owned DI.

## Public API rule

Public feature libraries expose only what application composition and consumers
need. DTOs, storage keys, data sources, and repository implementations remain
under `lib/src/`.

## Extraction checklist

Before extracting a feature, confirm:

1. The feature has a stable responsibility.
2. The package boundary reduces coupling or enables real reuse.
3. Dependencies still point toward contracts and infrastructure.
4. The feature can be tested independently.
5. Extraction does not duplicate application composition.

If those conditions are absent, keep the feature in the app.
