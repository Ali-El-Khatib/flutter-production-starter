# Design system assets

This directory is reserved for reusable visual resources owned by the design
system, such as generic icons or illustrations shared by multiple consumers.

Do not place product branding or feature-specific artwork here. Application
branding belongs in `apps/mobile/assets/app/`, and feature assets belong to the
feature that uses them.

When real assets are added:

1. Group them by purpose, for example `assets/icons/`.
2. Declare each non-empty directory in this package's `pubspec.yaml`.
3. Load the resource with the package name so ownership remains explicit.

```dart
const AssetImage(
  'assets/icons/empty_state.png',
  package: 'design_system',
);
```

Fonts follow Flutter's package-font convention and belong in
`packages/design_system/lib/fonts/`, not in this directory.
