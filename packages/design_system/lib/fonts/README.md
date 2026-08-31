# Design system fonts

The starter uses each platform's system font by default. Add font files here
only when a consuming product has an intentional, licensed typography family.

Recommended layout:

```text
lib/fonts/
├── AppSans-Regular.ttf
├── AppSans-Medium.ttf
├── AppSans-SemiBold.ttf
├── AppSans-Bold.ttf
└── LICENSE.txt
```

Declare package fonts from the consuming application's `pubspec.yaml`:

```yaml
flutter:
  fonts:
    - family: AppSans
      fonts:
        - asset: packages/design_system/fonts/AppSans-Regular.ttf
          weight: 400
        - asset: packages/design_system/fonts/AppSans-Medium.ttf
          weight: 500
        - asset: packages/design_system/fonts/AppSans-SemiBold.ttf
          weight: 600
        - asset: packages/design_system/fonts/AppSans-Bold.ttf
          weight: 700
```

Then apply the family centrally through `AppTheme` rather than setting it in
individual widgets.

## Rules

- Commit the font's license beside the files and verify redistribution rights.
- Bundle fonts locally for deterministic and offline builds.
- Include only the weights and styles the typography system uses.
- Configure appropriate fallbacks for every supported writing system.
- Do not add a font dependency merely to replace a deliberate system-font
  default.
