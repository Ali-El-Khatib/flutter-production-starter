import 'package:app_core/app_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('AppLogger can be instantiated with LoggerAppLogger', () {
    final AppLogger logger = LoggerAppLogger();
    expect(logger, isNotNull);
  });
}
