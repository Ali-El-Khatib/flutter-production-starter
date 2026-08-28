# Design System (`package:design_system`)

A reusable Flutter design system providing design tokens, themes, typography, and foundational UI primitives.

---

## 🎨 Design Tokens

- **`AppColors`**: Curated dark and light palettes, brand primaries, accents, backgrounds, surfaces, text, and semantic status colors (`success`, `warning`, `error`, `info`).
- **`AppSpacing`**: Harmonious scale (`xxs: 2.0`, `xs: 4.0`, `sm: 8.0`, `md: 16.0`, `lg: 24.0`, `xl: 32.0`, `xxl: 48.0`, `xxxl: 64.0`), standard paddings, and gap widgets (`gapH16`, `gapV16`, etc.).
- **`AppRadius`**: Consistent corner radiuses (`sm: 6.0`, `md: 12.0`, `lg: 18.0`, `xl: 24.0`, `full: 999.0`).
- **`AppDurations`**: Micro-interaction timings (`fast: 150ms`, `normal: 250ms`, `slow: 400ms`).
- **`AppTypography`**: Modern typography hierarchy with clean font weights and line heights.

---

## 🧩 UI Components

- **`AppButton`**: Primary, secondary, text, and outlined buttons with integrated loading states and icon support.
- **`AppTextField`**: Polished text input supporting labels, hints, error texts, password toggling, prefix/suffix widgets, and multi-line modes.
- **`AppLoader`**: Aesthetic animated spinner with optional progress message.
- **`AppErrorView`**: Full-state or inline error presentation with retry action support.
- **`AppTheme`**: Pre-configured `lightTheme` and `darkTheme` with Material 3 styling.

---

## 🚀 Usage

```dart
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class ExampleView extends StatelessWidget {
  const ExampleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextField(
          label: 'Email',
          hintText: 'user@example.com',
          prefixIcon: Icons.email_outlined,
        ),
        AppSpacing.gapV16,
        AppButton(
          text: 'Submit',
          onPressed: () {},
        ),
      ],
    );
  }
}
```

---

## 🧪 Testing

```bash
flutter test
```
