# Mobile Application (`apps/mobile`)

The main Flutter client application for the starter architecture monorepo.

---

## 🏗️ Structure

```text
lib/
├── app/                      # Application Bootstrap, Config, DI, Router, Feedback
│   ├── bootstrap.dart
│   ├── app.dart
│   ├── config/               # AppEnvironment & AppConfig
│   ├── di/                   # GetIt & Injectable modules
│   ├── feedback/             # Toastification presentation feedback
│   └── router/               # Kaisel Router & Route Guards
├── features/                 # LEGO Modular Features
│   ├── auth/                 # Complex Clean Architecture Feature (UseCases, Repos, State)
│   ├── auth_v2/              # Pluggability Proof Feature (DI Substitution)
│   ├── home/                 # Application Dashboard
│   ├── profile/              # Medium Feature (Repository + DTO Mapping)
│   └── settings/             # Simple Feature (State & Preferences)
├── main.dart                 # Default entrypoint
├── main_development.dart     # Development environment entrypoint
├── main_staging.dart         # Staging environment entrypoint
└── main_production.dart      # Production environment entrypoint
```

---

## 🚀 Running the App

### By Environment
```bash
# Development (default)
flutter run -t lib/main_development.dart

# Staging
flutter run -t lib/main_staging.dart

# Production
flutter run -t lib/main_production.dart
```

### Targeting Specific Devices
```bash
flutter devices
flutter run -d <device_id> -t lib/main_development.dart
```

---

## 🛠️ Code Generation

Generate Dependency Injection and Freezed models:

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## 🧪 Testing

```bash
flutter test
```
