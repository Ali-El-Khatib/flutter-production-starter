import 'package:app_core/app_core.dart';
import 'package:app_network/app_network.dart';
import 'package:dio/dio.dart';
import 'package:test/test.dart';

void main() {
  group('NetworkErrorMapper', () {
    const mapper = NetworkErrorMapper();

    test('maps connection timeout to TimeoutFailure', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.connectionTimeout,
      );

      final failure = mapper.map(dioException);
      expect(failure, isA<TimeoutFailure>());
    });

    test('maps connection error to ConnectivityFailure', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.connectionError,
      );

      final failure = mapper.map(dioException);
      expect(failure, isA<ConnectivityFailure>());
    });

    test('maps 401 response to UnauthorizedFailure', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 401,
          data: {'message': 'Token expired'},
        ),
      );

      final failure = mapper.map(dioException);
      expect(failure, isA<UnauthorizedFailure>());
      expect(failure.message, equals('Token expired'));
    });

    test('maps 422 response to ValidationFailure with fieldErrors', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 422,
          data: {
            'message': 'Invalid input',
            'errors': {
              'email': ['Email already taken'],
            },
          },
        ),
      );

      final failure = mapper.map(dioException);
      expect(failure, isA<ValidationFailure>());
      final validationFailure = failure as ValidationFailure;
      expect(validationFailure.fieldErrors['email'],
          equals(['Email already taken']));
    });

    test('maps 500 response to ServerFailure', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 500,
        ),
      );

      final failure = mapper.map(dioException);
      expect(failure, isA<ServerFailure>());
    });
  });
}
