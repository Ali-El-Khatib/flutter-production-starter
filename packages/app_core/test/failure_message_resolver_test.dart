import 'package:app_core/app_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FailureMessageResolver', () {
    const resolver = FailureMessageResolver();

    test('resolves ConnectivityFailure cleanly', () {
      const failure = ConnectivityFailure();
      expect(resolver.resolve(failure), contains('offline'));
    });

    test('resolves TimeoutFailure cleanly', () {
      const failure = TimeoutFailure();
      expect(resolver.resolve(failure), contains('too long'));
    });

    test('resolves UnauthorizedFailure cleanly', () {
      const failure = UnauthorizedFailure();
      expect(resolver.resolve(failure), contains('session has expired'));
    });

    test('resolves ValidationFailure with specific field message', () {
      const failure = ValidationFailure(
        fieldErrors: {
          'email': ['Email format is invalid'],
        },
      );
      expect(resolver.resolve(failure), equals('Email format is invalid'));
    });

    test('resolves UnknownFailure cleanly without raw leaks', () {
      const failure = UnknownFailure();
      expect(resolver.resolve(failure),
          equals('Something went wrong. Please try again.'));
    });
  });
}
