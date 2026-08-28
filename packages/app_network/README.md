# App Network (`package:app_network`)

Centralized HTTP networking infrastructure built on top of [Dio](https://pub.dev/packages/dio).

---

## 📦 Features

- **`DioFactory`**: Centralized builder configuring timeouts, base URLs, content types, and interceptors.
- **`AuthInterceptor`**: Automatic Bearer token injection and transparent 401 token refresh callbacks.
- **`NetworkLoggingInterceptor`**: Request/response logging with automatic redaction of sensitive headers (`Authorization`, `Cookie`, `X-Auth-Token`) and sensitive body parameters.
- **`RetryInterceptor`**: Automatic retry with exponential backoff on transient connection failures and 5xx server errors.
- **`NetworkErrorMapper`**: Maps low-level `DioException` instances into strongly-typed `Failure` instances from `package:app_core`.
- **`ApiClient`**: High-level typed HTTP wrapper around `Dio` returning `Result<T>` with built-in error handling.

---

## 🚀 Usage

### Initializing Network Client
```dart
import 'package:app_network/app_network.dart';

final dio = DioFactory.create(
  options: const DioNetworkOptions(
    baseUrl: 'https://api.example.com',
    connectTimeout: Duration(seconds: 15),
    receiveTimeout: Duration(seconds: 15),
  ),
  authInterceptor: AuthInterceptor(
    tokenProvider: () async => await secureStorage.read('jwt_token'),
  ),
  loggingInterceptor: const NetworkLoggingInterceptor(),
  retryInterceptor: const RetryInterceptor(maxRetries: 3),
);

final apiClient = ApiClient(dio, const NetworkErrorMapper());
```

### Performing Requests
```dart
final result = await apiClient.get<Map<String, dynamic>>('/v1/profile');

result.fold(
  onSuccess: (data) => print('Profile data: $data'),
  onFailure: (failure) => print('Error: ${failure.message}'),
);
```

---

## 🧪 Testing

```bash
flutter test
```
