# Mobile application assets

This directory owns runtime assets that belong to the mobile application rather
than to a reusable package.

Create only the directories required by the product:

```text
assets/
├── app/
│   ├── branding/       # Product logos and brand marks
│   └── illustrations/  # Application-wide artwork and empty states
└── features/
    └── <feature>/      # Assets owned by an in-app feature
```

## Rules

- Keep feature-specific assets with their owning feature namespace.
- Place native splash artwork in `assets/app/branding/`, update
  `flutter_native_splash.yaml`, and run the workspace `generate` script.
- Move an asset with its feature if that feature is extracted into a package.
- Declare only non-empty asset directories in `apps/mobile/pubspec.yaml`.
- List nested directories explicitly; Flutter directory declarations are not
  generally recursive.
- Use lowercase `snake_case` filenames without spaces.
- Optimize images before committing them and provide accessible semantics in
  the widget that renders them.
- Never place secrets, environment credentials, test fixtures, golden files, or
  repository documentation media here.

Example declaration after real files have been added:

```yaml
flutter:
  assets:
    - assets/app/branding/
    - assets/features/profile/
```

The starter intentionally has no placeholder runtime assets, so its pubspec
contains no asset entries yet.
