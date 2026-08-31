# Mobile Application

The mobile workspace member owns application bootstrap, environment selection,
DI composition, routing, and app-specific features.

```text
lib/
├── app/
│   ├── config/                 # development, staging, production, test
│   ├── di/                     # generated and manual composition
│   ├── feedback/               # presentation feedback implementation
│   └── router/                 # typed routes and authenticated guards
├── features/
│   ├── home/
│   ├── profile/
│   └── settings/
├── main_development.dart
├── main_staging.dart
└── main_production.dart
```

Authentication is consumed from `package:feature_auth`; stable entities and the
repository contract come from `package:auth_contract`.

## Run

From the repository root:

```bash
dart run melos run run:dev
dart run melos run run:staging
dart run melos run run:prod
```

Development explicitly enables sample adapters. Staging and production use real
API repositories and propagate backend failures honestly.

Before release, replace the example application ID and API URL and configure
signing through local or CI secrets.
