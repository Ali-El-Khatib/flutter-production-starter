import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/app/app.dart';
import 'package:mobile/app/config/app_config.dart';
import 'package:mobile/app/di/injection.dart';

void main() {
  testWidgets('App renders Home dashboard and navigates across modules',
      (tester) async {
    // Configure DI for test environment
    await configureDependencies(AppConfig.development());

    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    // Verify Home Page title and modules
    expect(find.text('Flutter Starter (Dev)'), findsOneWidget);
    expect(find.text('Explore Modules'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);

    // Navigate to Settings
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    expect(find.text('Appearance'), findsOneWidget);
    expect(find.text('Dark Theme'), findsOneWidget);
  });
}
