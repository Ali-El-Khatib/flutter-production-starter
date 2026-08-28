# App Core (`package:app_core`)

A stable, feature-agnostic foundational package providing core functional abstractions, domain failure taxonomies, error mapping contracts, and secure logging for Flutter and Dart applications.

---

## 📦 Features

- **`Result<T>` Monad**: Predictable functional error handling (`Result.success`, `Result.failure`, `guard`, `fold`, `map`, `flatMap`).
- **Domain `Failure` Hierarchy**: Strongly-typed business failures (`ConnectivityFailure`, `TimeoutFailure`, `UnauthorizedFailure`, `ForbiddenFailure`, `ValidationFailure`, `NotFoundFailure`, `ConflictFailure`, `RateLimitFailure`, `ServerFailure`, `CacheFailure`, `CancelledFailure`, `UnknownFailure`).
- **Technical Exceptions**: Standardized base `AppException` and category-specific exceptions (`NetworkException`, `StorageException`, `ValidationException`).
- **Sanitizing `AppLogger`**: Production logging abstraction that automatically filters and redacts sensitive parameters (`password`, `token`, `secret`, `authorization`, `bearer`).
- **`FailureMessageResolver`**: Centralized mapping of technical domain failures to localized, user-friendly presentation messages.
- **`ErrorMapper<E, F>` Contract**: Interface for converting low-level infrastructure exceptions into domain failures.

---

## 🚀 Usage

### Functional Result Handling

```dart
import 'package:app_core/app_core.dart';

Future<Result<User>> fetchUser(String id) async {
  return Result.guard(() async {
    final response = await remoteSource.get('/users/$id');
    return User.fromJson(response);
  }, (error, stackTrace) => errorMapper.map(error, stackTrace));
}

// Consuming the Result
final result = await fetchUser('123');

result.fold(
  onSuccess: (user) => print('Welcome, ${user.name}'),
  onFailure: (failure) => print(resolver.resolve(failure)),
);
```

### Sanitized Logging

```dart
final logger = LoggerAppLogger();

// Automatically redacts sensitive fields
logger.info('Authenticating user: email=dev@test.com, password=secretPassword123');
// Output: Authenticating user: email=dev@test.com, password=***REDACTED***
```

---

## 🧪 Testing

```bash
flutter test
```
