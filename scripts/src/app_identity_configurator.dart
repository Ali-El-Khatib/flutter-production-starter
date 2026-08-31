import 'dart:io';

/// Product identity supplied by the application developer.
final class AppIdentity {
  AppIdentity({required this.name, required this.applicationId}) {
    _validateName(name);
    _validateApplicationId(applicationId);
  }

  final String name;
  final String applicationId;

  static final RegExp _applicationIdPattern = RegExp(
    r'^[a-z][a-z0-9_]*(\.[a-z][a-z0-9_]*){2,}$',
  );

  static const Set<String> _reservedSegments = {
    'as',
    'break',
    'class',
    'continue',
    'do',
    'else',
    'false',
    'for',
    'fun',
    'if',
    'in',
    'interface',
    'is',
    'null',
    'object',
    'package',
    'return',
    'super',
    'this',
    'throw',
    'true',
    'try',
    'typealias',
    'typeof',
    'val',
    'var',
    'when',
    'while',
  };

  static void _validateName(String value) {
    if (value.trim() != value || value.isEmpty) {
      throw const FormatException(
        'The app name must be non-empty and have no leading or trailing spaces.',
      );
    }
    if (value.length > 50) {
      throw const FormatException(
          'The app name must be 50 characters or less.');
    }
    if (value.contains(RegExp(r'[\r\n\x00]'))) {
      throw const FormatException(
        'The app name cannot contain line breaks or null characters.',
      );
    }
  }

  static void _validateApplicationId(String value) {
    if (value.length > 255 || !_applicationIdPattern.hasMatch(value)) {
      throw FormatException(
        'Invalid application ID "$value". Use at least three lowercase '
        'dot-separated segments, for example com.example.my_app.',
      );
    }

    final reserved =
        value.split('.').where(_reservedSegments.contains).toList();
    if (reserved.isNotEmpty) {
      throw FormatException(
        'Application ID segment "${reserved.first}" is a Kotlin keyword.',
      );
    }
  }
}

/// A validated, complete set of changes that can be previewed before writing.
final class AppIdentityPlan {
  AppIdentityPlan._({
    required this.root,
    required this.previousIdentity,
    required this.identity,
    required List<FileUpdate> updates,
    required this.mainActivityMove,
  }) : updates = List.unmodifiable(updates);

  final Directory root;
  final AppIdentity previousIdentity;
  final AppIdentity identity;
  final List<FileUpdate> updates;
  final FileMove? mainActivityMove;

  Iterable<String> get changedPaths sync* {
    for (final update in updates) {
      yield _relativePath(root, update.file);
    }
    final move = mainActivityMove;
    if (move != null) {
      yield '${_relativePath(root, move.source)} -> '
          '${_relativePath(root, move.destination)}';
    }
  }

  bool get hasChanges => updates.isNotEmpty || mainActivityMove != null;

  void apply() {
    for (final update in updates) {
      update.file.writeAsStringSync(update.after);
    }

    final move = mainActivityMove;
    if (move != null) {
      move.destination.parent.createSync(recursive: true);
      move.destination.writeAsStringSync(move.after);
      move.source.deleteSync();
      _removeEmptyParents(move.source.parent, stopAt: move.kotlinRoot);
    }
  }
}

final class FileUpdate {
  const FileUpdate({
    required this.file,
    required this.before,
    required this.after,
  });

  final File file;
  final String before;
  final String after;
}

final class FileMove {
  const FileMove({
    required this.source,
    required this.destination,
    required this.after,
    required this.kotlinRoot,
  });

  final File source;
  final File destination;
  final String after;
  final Directory kotlinRoot;
}

/// Creates and verifies the repository-specific application identity plan.
final class AppIdentityConfigurator {
  AppIdentityConfigurator(Directory root) : root = root.absolute;

  final Directory root;

  AppIdentityPlan createPlan(AppIdentity identity) {
    final androidGradle =
        _requiredFile('apps/mobile/android/app/build.gradle.kts');
    final androidManifest =
        _requiredFile('apps/mobile/android/app/src/main/AndroidManifest.xml');
    final kotlinRoot =
        _requiredDirectory('apps/mobile/android/app/src/main/kotlin');
    final iosProject =
        _requiredFile('apps/mobile/ios/Runner.xcodeproj/project.pbxproj');
    final iosPlist = _requiredFile('apps/mobile/ios/Runner/Info.plist');
    final appConfig =
        _requiredFile('apps/mobile/lib/app/config/app_config.dart');
    final homePage = _requiredFile(
      'apps/mobile/lib/features/home/presentation/pages/home_page.dart',
    );

    final gradleBefore = androidGradle.readAsStringSync();
    final oldApplicationId = _readSingleMatch(
      gradleBefore,
      RegExp(r'applicationId\s*=\s*"([^"]+)"'),
      'Android applicationId',
    );
    final oldNamespace = _readSingleMatch(
      gradleBefore,
      RegExp(r'namespace\s*=\s*"([^"]+)"'),
      'Android namespace',
    );
    if (oldNamespace != oldApplicationId) {
      throw StateError(
        'Android namespace "$oldNamespace" does not match applicationId '
        '"$oldApplicationId". Resolve that difference before running setup.',
      );
    }

    final appConfigBefore = appConfig.readAsStringSync();
    final oldNameLiteral = _readSingleMatch(
      appConfigBefore,
      RegExp(
        r"factory AppConfig\.production\(\)[\s\S]*?appName:\s*'((?:\\.|[^'])*)'",
      ),
      'production app name',
    );
    final oldName = _decodeDartSingleQuoted(oldNameLiteral);
    final previousIdentity = AppIdentity(
      name: oldName,
      applicationId: oldApplicationId,
    );

    final updates = <FileUpdate>[];
    _addUpdate(
      updates,
      androidGradle,
      gradleBefore,
      _replaceRequired(
        _replaceRequired(
          gradleBefore,
          'namespace = "$oldApplicationId"',
          'namespace = "${identity.applicationId}"',
          'Android namespace',
        ),
        'applicationId = "$oldApplicationId"',
        'applicationId = "${identity.applicationId}"',
        'Android applicationId',
      ),
    );

    final manifestBefore = androidManifest.readAsStringSync();
    final labelPattern = RegExp(r'android:label="[^"]*"');
    _requireMatchCount(manifestBefore, labelPattern, 1, 'Android app label');
    _addUpdate(
      updates,
      androidManifest,
      manifestBefore,
      manifestBefore.replaceFirst(
        labelPattern,
        'android:label="${_escapeXml(identity.name)}"',
      ),
    );

    final mainActivities = kotlinRoot
        .listSync(recursive: true, followLinks: false)
        .whereType<File>()
        .where((file) => _fileName(file.path) == 'MainActivity.kt')
        .toList();
    if (mainActivities.length != 1) {
      throw StateError(
        'Expected exactly one Android MainActivity.kt, found '
        '${mainActivities.length}.',
      );
    }
    final mainActivity = mainActivities.single;
    final mainActivityBefore = mainActivity.readAsStringSync();
    final mainActivityAfter = _replaceRequired(
      mainActivityBefore,
      'package $oldApplicationId',
      'package ${identity.applicationId}',
      'MainActivity package declaration',
    );
    final mainActivityDestination = File(
      _joinAll([
        kotlinRoot.path,
        ...identity.applicationId.split('.'),
        'MainActivity.kt',
      ]),
    );
    FileMove? mainActivityMove;
    if (_normalizedPath(mainActivity.path) ==
        _normalizedPath(mainActivityDestination.path)) {
      _addUpdate(
        updates,
        mainActivity,
        mainActivityBefore,
        mainActivityAfter,
      );
    } else {
      if (mainActivityDestination.existsSync()) {
        throw StateError(
          'Cannot move MainActivity because the destination already exists: '
          '${mainActivityDestination.path}',
        );
      }
      mainActivityMove = FileMove(
        source: mainActivity,
        destination: mainActivityDestination,
        after: mainActivityAfter,
        kotlinRoot: kotlinRoot,
      );
    }

    final iosProjectBefore = iosProject.readAsStringSync();
    var iosIdentifierCount = 0;
    final iosProjectAfter = iosProjectBefore.replaceAllMapped(
      RegExp(r'(PRODUCT_BUNDLE_IDENTIFIER\s*=\s*)([^;]+)(;)'),
      (match) {
        final rawValue = match.group(2)!.trim();
        final isQuoted = rawValue.startsWith('"') && rawValue.endsWith('"');
        final value =
            isQuoted ? rawValue.substring(1, rawValue.length - 1) : rawValue;
        if (value != oldApplicationId &&
            !value.startsWith('$oldApplicationId.')) {
          return match.group(0)!;
        }
        iosIdentifierCount += 1;
        final replacement =
            '${identity.applicationId}${value.substring(oldApplicationId.length)}';
        return '${match.group(1)}${isQuoted ? '"$replacement"' : replacement}'
            '${match.group(3)}';
      },
    );
    if (iosIdentifierCount == 0) {
      throw StateError('No matching iOS bundle identifiers were found.');
    }
    _addUpdate(
      updates,
      iosProject,
      iosProjectBefore,
      iosProjectAfter,
    );

    final plistBefore = iosPlist.readAsStringSync();
    var plistAfter = _replacePlistString(
      plistBefore,
      key: 'CFBundleDisplayName',
      value: identity.name,
    );
    plistAfter = _replacePlistString(
      plistAfter,
      key: 'CFBundleName',
      value: identity.name,
    );
    _addUpdate(updates, iosPlist, plistBefore, plistAfter);

    final newNameLiteral = _encodeDartSingleQuoted(identity.name);
    var appConfigAfter = appConfigBefore;
    for (final suffix in const ['', ' (Dev)', ' (Staging)', ' (Test)']) {
      appConfigAfter = _replaceRequired(
        appConfigAfter,
        "appName: '$oldNameLiteral$suffix'",
        "appName: '$newNameLiteral$suffix'",
        'AppConfig name$suffix',
      );
    }
    _addUpdate(updates, appConfig, appConfigBefore, appConfigAfter);

    final homeBefore = homePage.readAsStringSync();
    final starterTitle = "'$oldNameLiteral Architecture'";
    final configuredTitle = "'$oldNameLiteral'";
    final currentHomeTitle =
        homeBefore.contains(starterTitle) ? starterTitle : configuredTitle;
    final homeAfter = _replaceRequired(
      homeBefore,
      currentHomeTitle,
      "'$newNameLiteral'",
      'home-page product title',
    );
    _addUpdate(updates, homePage, homeBefore, homeAfter);

    final mobileTests = Directory(_resolve('apps/mobile/test'));
    if (mobileTests.existsSync()) {
      for (final testFile in mobileTests
          .listSync(recursive: true, followLinks: false)
          .whereType<File>()
          .where((file) => file.path.endsWith('.dart'))) {
        final before = testFile.readAsStringSync();
        final after = before.replaceAll(
          "'$oldNameLiteral (Test)'",
          "'$newNameLiteral (Test)'",
        );
        _addUpdate(updates, testFile, before, after);
      }
    }

    return AppIdentityPlan._(
      root: root,
      previousIdentity: previousIdentity,
      identity: identity,
      updates: updates,
      mainActivityMove: mainActivityMove,
    );
  }

  void verify(AppIdentity identity) {
    final gradle = _requiredFile('apps/mobile/android/app/build.gradle.kts')
        .readAsStringSync();
    if (!gradle.contains('namespace = "${identity.applicationId}"') ||
        !gradle.contains('applicationId = "${identity.applicationId}"')) {
      throw StateError('Android identity verification failed.');
    }

    final kotlinPath = _joinAll([
      _resolve('apps/mobile/android/app/src/main/kotlin'),
      ...identity.applicationId.split('.'),
      'MainActivity.kt',
    ]);
    final activity = File(kotlinPath);
    if (!activity.existsSync() ||
        !activity
            .readAsStringSync()
            .contains('package ${identity.applicationId}')) {
      throw StateError('MainActivity verification failed.');
    }

    final iosProject = _requiredFile(
      'apps/mobile/ios/Runner.xcodeproj/project.pbxproj',
    ).readAsStringSync();
    if (!iosProject.contains(identity.applicationId)) {
      throw StateError('iOS bundle identifier verification failed.');
    }

    final encodedName = _encodeDartSingleQuoted(identity.name);
    final appConfig = _requiredFile(
      'apps/mobile/lib/app/config/app_config.dart',
    ).readAsStringSync();
    if (!appConfig.contains("appName: '$encodedName'")) {
      throw StateError('Application name verification failed.');
    }
  }

  File _requiredFile(String relativePath) {
    final file = File(_resolve(relativePath));
    if (!file.existsSync()) {
      throw StateError('Required file is missing: ${file.path}');
    }
    return file;
  }

  Directory _requiredDirectory(String relativePath) {
    final directory = Directory(_resolve(relativePath));
    if (!directory.existsSync()) {
      throw StateError('Required directory is missing: ${directory.path}');
    }
    return directory;
  }

  String _resolve(String relativePath) {
    return _joinAll([root.path, ...relativePath.split('/')]);
  }
}

void _addUpdate(
  List<FileUpdate> updates,
  File file,
  String before,
  String after,
) {
  if (before != after) {
    updates.add(FileUpdate(file: file, before: before, after: after));
  }
}

String _readSingleMatch(
  String source,
  RegExp pattern,
  String description,
) {
  final matches = pattern.allMatches(source).toList();
  if (matches.length != 1) {
    throw StateError(
      'Expected exactly one $description, found ${matches.length}.',
    );
  }
  return matches.single.group(1)!;
}

String _replaceRequired(
  String source,
  String from,
  String to,
  String description,
) {
  final count = from.allMatches(source).length;
  if (count != 1) {
    throw StateError('Expected exactly one $description, found $count.');
  }
  return source.replaceFirst(from, to);
}

void _requireMatchCount(
  String source,
  RegExp pattern,
  int expected,
  String description,
) {
  final count = pattern.allMatches(source).length;
  if (count != expected) {
    throw StateError('Expected $expected $description, found $count.');
  }
}

String _replacePlistString(
  String source, {
  required String key,
  required String value,
}) {
  final pattern = RegExp(
    '<key>$key</key>(\\s*)<string>[^<]*</string>',
  );
  _requireMatchCount(source, pattern, 1, 'iOS $key value');
  return source.replaceFirstMapped(
    pattern,
    (match) =>
        '<key>$key</key>${match.group(1)}<string>${_escapeXml(value)}</string>',
  );
}

String _escapeXml(String value) {
  return value
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;')
      .replaceAll("'", '&apos;');
}

String _encodeDartSingleQuoted(String value) {
  return value
      .replaceAll(r'\', r'\\')
      .replaceAll("'", r"\'")
      .replaceAll(r'$', r'\$');
}

String _decodeDartSingleQuoted(String value) {
  final buffer = StringBuffer();
  for (var index = 0; index < value.length; index += 1) {
    final character = value[index];
    if (character != r'\' || index + 1 >= value.length) {
      buffer.write(character);
      continue;
    }
    index += 1;
    buffer.write(value[index]);
  }
  return buffer.toString();
}

String _joinAll(List<String> segments) => segments.join(Platform.pathSeparator);

String _fileName(String path) => path.split(Platform.pathSeparator).last;

String _normalizedPath(String path) =>
    File(path).absolute.path.toLowerCase().replaceAll('/', r'\');

String _relativePath(Directory root, File file) {
  final rootPath = root.absolute.path;
  final filePath = file.absolute.path;
  if (filePath.toLowerCase().startsWith(rootPath.toLowerCase())) {
    return filePath.substring(rootPath.length + 1).replaceAll(r'\', '/');
  }
  return filePath;
}

void _removeEmptyParents(Directory directory, {required Directory stopAt}) {
  var current = directory;
  final stopPath = _normalizedPath(stopAt.path);
  while (_normalizedPath(current.path) != stopPath) {
    if (!current.existsSync() || current.listSync().isNotEmpty) {
      return;
    }
    final parent = current.parent;
    current.deleteSync();
    current = parent;
  }
}
