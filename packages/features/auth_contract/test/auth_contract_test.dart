import 'package:auth_contract/auth_contract.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthContract Entities', () {
    test('User equality and props', () {
      const u1 = User(id: '1', email: 'a@b.com', name: 'A', role: 'admin');
      const u2 = User(id: '1', email: 'a@b.com', name: 'A', role: 'admin');
      const u3 = User(id: '2', email: 'b@b.com', name: 'B', role: 'user');

      expect(u1, equals(u2));
      expect(u1.hashCode, equals(u2.hashCode));
      expect(u1, isNot(equals(u3)));
    });

    test('AuthSession protects sensitive token in toString', () {
      const user = User(id: '1', email: 'a@b.com', name: 'A', role: 'admin');
      const session = AuthSession(
        user: user,
        token: 'super_secret_jwt',
        refreshToken: 'super_secret_refresh',
      );

      final str = session.toString();
      expect(str.contains('super_secret_jwt'), isFalse);
      expect(str.contains('super_secret_refresh'), isFalse);
      expect(str.contains('[PROTECTED]'), isTrue);
    });
  });
}
