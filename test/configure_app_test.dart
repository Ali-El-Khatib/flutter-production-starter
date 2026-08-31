import 'dart:io';

import 'package:test/test.dart';

import '../scripts/src/app_identity_configurator.dart';

void main() {
  late Directory temporaryRoot;

  setUp(() {
    temporaryRoot = Directory.systemTemp.createTempSync('configure_app_test_');
    _writeFixture(temporaryRoot);
  });

  tearDown(() {
    temporaryRoot.deleteSync(recursive: true);
  });

  test('dry-run planning does not mutate the starter', () {
    final gradle = _file(
      temporaryRoot,
      'apps/mobile/android/app/build.gradle.kts',
    );
    final before = gradle.readAsStringSync();

    final plan = AppIdentityConfigurator(temporaryRoot).createPlan(
      AppIdentity(name: 'Phoenix', applicationId: 'com.example.phoenix'),
    );

    expect(plan.hasChanges, isTrue);
    expect(plan.mainActivityMove, isNotNull);
    expect(
      plan.changedPaths,
      contains(
        'apps/mobile/android/app/build.gradle.kts',
      ),
    );
    expect(gradle.readAsStringSync(), before);
    expect(
      _file(
        temporaryRoot,
        'apps/mobile/android/app/src/main/kotlin/com/yourcompany/mobile/'
        'MainActivity.kt',
      ).existsSync(),
      isTrue,
    );
  });

  test('apply updates Android, iOS, Dart names, tests, and MainActivity', () {
    const applicationId = 'com.example.phoenix';
    const name = r"Chef's Table & $pecial";
    final identity = AppIdentity(name: name, applicationId: applicationId);
    final configurator = AppIdentityConfigurator(temporaryRoot);

    final plan = configurator.createPlan(identity);
    plan.apply();
    configurator.verify(identity);

    final gradle = _read(
      temporaryRoot,
      'apps/mobile/android/app/build.gradle.kts',
    );
    expect(gradle, contains('namespace = "$applicationId"'));
    expect(gradle, contains('applicationId = "$applicationId"'));

    final manifest = _read(
      temporaryRoot,
      'apps/mobile/android/app/src/main/AndroidManifest.xml',
    );
    expect(
        manifest, contains(r'android:label="Chef&apos;s Table &amp; $pecial"'));

    final oldActivity = _file(
      temporaryRoot,
      'apps/mobile/android/app/src/main/kotlin/com/yourcompany/mobile/'
      'MainActivity.kt',
    );
    final newActivity = _file(
      temporaryRoot,
      'apps/mobile/android/app/src/main/kotlin/com/example/phoenix/'
      'MainActivity.kt',
    );
    expect(oldActivity.existsSync(), isFalse);
    expect(newActivity.existsSync(), isTrue);
    expect(newActivity.readAsStringSync(), contains('package $applicationId'));

    final iosProject = _read(
      temporaryRoot,
      'apps/mobile/ios/Runner.xcodeproj/project.pbxproj',
    );
    expect(iosProject, contains('$applicationId;'));
    expect(iosProject, contains('$applicationId.RunnerTests;'));
    expect(iosProject, isNot(contains('com.yourcompany.mobile')));

    final plist = _read(temporaryRoot, 'apps/mobile/ios/Runner/Info.plist');
    expect(plist, contains(r'Chef&apos;s Table &amp; $pecial'));

    final appConfig = _read(
      temporaryRoot,
      'apps/mobile/lib/app/config/app_config.dart',
    );
    expect(appConfig, contains(r"appName: 'Chef\'s Table & \$pecial'"));
    expect(
      appConfig,
      contains(r"appName: 'Chef\'s Table & \$pecial (Dev)'"),
    );

    final smokeTest = _read(
      temporaryRoot,
      'apps/mobile/test/app/app_smoke_test.dart',
    );
    expect(smokeTest, contains(r"'Chef\'s Table & \$pecial (Test)'"));
  });

  test('invalid application IDs fail before a plan can be created', () {
    expect(
      () => AppIdentity(name: 'Phoenix', applicationId: 'Com.Example.App'),
      throwsFormatException,
    );
    expect(
      () => AppIdentity(name: 'Phoenix', applicationId: 'com.example.class'),
      throwsFormatException,
    );
  });

  test('configuration can be safely run again for a different identity', () {
    final configurator = AppIdentityConfigurator(temporaryRoot);
    final first = AppIdentity(
      name: 'Phoenix',
      applicationId: 'com.example.phoenix',
    );
    configurator.createPlan(first).apply();

    final second = AppIdentity(
      name: 'Orion',
      applicationId: 'io.example.orion',
    );
    configurator.createPlan(second).apply();
    configurator.verify(second);

    expect(
      _read(
        temporaryRoot,
        'apps/mobile/lib/features/home/presentation/pages/home_page.dart',
      ),
      contains("'Orion'"),
    );
    expect(
      _file(
        temporaryRoot,
        'apps/mobile/android/app/src/main/kotlin/io/example/orion/'
        'MainActivity.kt',
      ).existsSync(),
      isTrue,
    );
  });
}

void _writeFixture(Directory root) {
  _write(
    root,
    'apps/mobile/android/app/build.gradle.kts',
    '''
android {
    namespace = "com.yourcompany.mobile"
    defaultConfig {
        applicationId = "com.yourcompany.mobile"
    }
}
''',
  );
  _write(
    root,
    'apps/mobile/android/app/src/main/AndroidManifest.xml',
    '''
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
  <application android:label="mobile" />
</manifest>
''',
  );
  _write(
    root,
    'apps/mobile/android/app/src/main/kotlin/com/yourcompany/mobile/'
        'MainActivity.kt',
    '''
package com.yourcompany.mobile

class MainActivity
''',
  );
  _write(
    root,
    'apps/mobile/ios/Runner.xcodeproj/project.pbxproj',
    '''
PRODUCT_BUNDLE_IDENTIFIER = com.yourcompany.mobile;
PRODUCT_BUNDLE_IDENTIFIER = com.yourcompany.mobile.RunnerTests;
''',
  );
  _write(
    root,
    'apps/mobile/ios/Runner/Info.plist',
    '''
<plist>
  <dict>
    <key>CFBundleDisplayName</key>
    <string>Mobile</string>
    <key>CFBundleName</key>
    <string>mobile</string>
  </dict>
</plist>
''',
  );
  _write(
    root,
    'apps/mobile/lib/app/config/app_config.dart',
    '''
class AppConfig {
  factory AppConfig.development() {
    return const AppConfig(appName: 'Flutter Starter (Dev)');
  }

  factory AppConfig.staging() {
    return const AppConfig(appName: 'Flutter Starter (Staging)');
  }

  factory AppConfig.production() {
    return const AppConfig(appName: 'Flutter Starter');
  }

  factory AppConfig.test() {
    return const AppConfig(appName: 'Flutter Starter (Test)');
  }
}
''',
  );
  _write(
    root,
    'apps/mobile/lib/features/home/presentation/pages/home_page.dart',
    "const title = 'Flutter Starter Architecture';\n",
  );
  _write(
    root,
    'apps/mobile/test/app/app_smoke_test.dart',
    "const expectedTitle = 'Flutter Starter (Test)';\n",
  );
}

File _file(Directory root, String relativePath) {
  return File(
    [root.path, ...relativePath.split('/')].join(Platform.pathSeparator),
  );
}

String _read(Directory root, String relativePath) {
  return _file(root, relativePath).readAsStringSync();
}

void _write(Directory root, String relativePath, String content) {
  final file = _file(root, relativePath);
  file.parent.createSync(recursive: true);
  file.writeAsStringSync(content);
}
