import 'package:app_core/app_core.dart';
import 'package:test/test.dart';

void main() {
  group('Result', () {
    test('Success holds data and returns true for isSuccess', () {
      const result = Result.success(42);

      expect(result.isSuccess, isTrue);
      expect(result.isFailure, isFalse);
      expect(result.dataOrNull, equals(42));
      expect(result.failureOrNull, isNull);
    });

    test('FailureResult holds failure and returns true for isFailure', () {
      const failure = NotFoundFailure(message: 'User missing');
      const result = Result<int>.failure(failure);

      expect(result.isSuccess, isFalse);
      expect(result.isFailure, isTrue);
      expect(result.dataOrNull, isNull);
      expect(result.failureOrNull, equals(failure));
    });

    test('map transforms success value and preserves failure', () {
      const success = Result.success(10);
      final mappedSuccess = success.map((x) => x * 2);
      expect(mappedSuccess.dataOrNull, equals(20));

      const failure = Result<int>.failure(ServerFailure());
      final mappedFailure = failure.map((x) => x * 2);
      expect(mappedFailure.isFailure, isTrue);
      expect(mappedFailure.failureOrNull, isA<ServerFailure>());
    });

    test('guard catches exceptions and returns FailureResult', () async {
      final successResult = await Result.guard<String>(
        () async => 'hello',
        onError: (e, st) => const UnknownFailure(),
      );
      expect(successResult.dataOrNull, equals('hello'));

      final failureResult = await Result.guard<String>(
        () async => throw Exception('error'),
        onError: (e, st) => const ServerFailure(message: 'error occurred'),
      );
      expect(failureResult.isFailure, isTrue);
      expect(failureResult.failureOrNull?.message, equals('error occurred'));
    });
  });
}
