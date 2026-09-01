import 'dart:io';

import 'src/app_identity_configurator.dart';

void main(List<String> arguments) {
  try {
    final options = _Options.parse(arguments);
    if (options.showHelp) {
      stdout.write(_usage);
      return;
    }

    final root = _findRepositoryRoot();
    final interactive = options.name == null && options.applicationId == null;
    final name = options.name ?? _prompt('Product name');
    final applicationId = options.applicationId ??
        _prompt('Application ID (for example com.company.product)');
    final identity = AppIdentity(name: name, applicationId: applicationId);
    final configurator = AppIdentityConfigurator(root);
    final plan = configurator.createPlan(identity);

    _printPlan(plan, dryRun: options.dryRun);
    if (!plan.hasChanges) {
      stdout.writeln('\nThe starter already uses this identity.');
      return;
    }
    if (options.dryRun) {
      stdout.writeln('\nDry run complete. No files were changed.');
      return;
    }

    _requireSafeWorkingTree(root, allowDirty: options.allowDirty);
    if (interactive && !_confirm('\nApply these changes? [y/N] ')) {
      stdout.writeln('Cancelled. No files were changed.');
      return;
    }

    plan.apply();
    configurator.verify(identity);
    stdout
      ..writeln('\nApplication identity configured successfully.')
      ..writeln('Next:')
      ..writeln('  dart run melos run analyze')
      ..writeln('  dart run melos run test');
  } on FormatException catch (error) {
    stderr.writeln('Setup error: ${error.message}');
    exitCode = 64;
  } on FileSystemException catch (error) {
    stderr.writeln('File error: ${error.message}');
    exitCode = 74;
  } on StateError catch (error) {
    stderr.writeln('Setup error: ${error.message}');
    exitCode = 1;
  }
}

final class _Options {
  const _Options({
    required this.name,
    required this.applicationId,
    required this.dryRun,
    required this.allowDirty,
    required this.showHelp,
  });

  final String? name;
  final String? applicationId;
  final bool dryRun;
  final bool allowDirty;
  final bool showHelp;

  static _Options parse(List<String> arguments) {
    String? name;
    String? applicationId;
    var dryRun = false;
    var allowDirty = false;
    var showHelp = false;

    for (var index = 0; index < arguments.length; index += 1) {
      final argument = arguments[index];
      switch (argument) {
        case '--name':
          name = _nextValue(arguments, ++index, argument);
        case '--id' || '--application-id':
          applicationId = _nextValue(arguments, ++index, argument);
        case '--dry-run':
          dryRun = true;
        case '--allow-dirty':
          allowDirty = true;
        case '--help' || '-h':
          showHelp = true;
        default:
          if (argument.startsWith('--name=')) {
            name = argument.substring('--name='.length);
          } else if (argument.startsWith('--id=')) {
            applicationId = argument.substring('--id='.length);
          } else if (argument.startsWith('--application-id=')) {
            applicationId = argument.substring('--application-id='.length);
          } else {
            throw FormatException('Unknown option "$argument".\n\n$_usage');
          }
      }
    }

    if ((name == null) != (applicationId == null)) {
      throw const FormatException(
        'Pass both --name and --id, or omit both for interactive setup.',
      );
    }

    return _Options(
      name: name,
      applicationId: applicationId,
      dryRun: dryRun,
      allowDirty: allowDirty,
      showHelp: showHelp,
    );
  }
}

String _nextValue(List<String> arguments, int index, String option) {
  if (index >= arguments.length || arguments[index].startsWith('--')) {
    throw FormatException('$option requires a value.');
  }
  return arguments[index];
}

Directory _findRepositoryRoot() {
  var current = File.fromUri(Platform.script).absolute.parent.parent;
  while (true) {
    if (File(_join(current.path, 'pubspec.yaml')).existsSync() &&
        Directory(_join(current.path, 'apps', 'mobile')).existsSync()) {
      return current;
    }
    if (current.parent.path == current.path) {
      throw StateError('Could not find the Flutter starter repository root.');
    }
    current = current.parent;
  }
}

String _prompt(String label) {
  stdout.write('$label: ');
  final value = stdin.readLineSync();
  if (value == null) {
    throw const FormatException('Input ended before setup was complete.');
  }
  return value;
}

bool _confirm(String message) {
  stdout.write(message);
  return stdin.readLineSync()?.trim().toLowerCase() == 'y';
}

void _printPlan(AppIdentityPlan plan, {required bool dryRun}) {
  stdout
    ..writeln(
        dryRun ? 'Application identity dry run' : 'Application identity plan')
    ..writeln(
      '  Name: ${plan.previousIdentity.name} -> ${plan.identity.name}',
    )
    ..writeln(
      '  ID:   ${plan.previousIdentity.applicationId} -> '
      '${plan.identity.applicationId}',
    )
    ..writeln('  Files:');
  for (final path in plan.changedPaths) {
    stdout.writeln('    - $path');
  }
}

void _requireSafeWorkingTree(Directory root, {required bool allowDirty}) {
  if (allowDirty) {
    return;
  }
  final result = Process.runSync(
    'git',
    const ['status', '--porcelain'],
    workingDirectory: root.path,
    runInShell: Platform.isWindows,
  );
  if (result.exitCode != 0) {
    throw StateError(
      'Could not inspect the Git working tree. Commit your work first or pass '
      '--allow-dirty after making a backup.',
    );
  }
  if ((result.stdout as String).trim().isNotEmpty) {
    throw StateError(
      'The Git working tree is not clean. Commit or stash existing changes, '
      'then run setup again. Use --allow-dirty only if you intentionally accept '
      'that risk.',
    );
  }
}

String _join(String first, String second, [String? third]) => [
      first,
      second,
      if (third != null) third,
    ].join(Platform.pathSeparator);

const _usage = '''
Configure this starter's product name and Android/iOS application identifiers.

Usage:
  dart run scripts/configure_app.dart
  dart run scripts/configure_app.dart --name "My App" --id com.company.my_app

Options:
  --name <value>            Product name shown to users.
  --id <value>              Android application ID and iOS bundle identifier.
  --application-id <value>  Alias for --id.
  --dry-run                 Preview the complete plan without writing files.
  --allow-dirty             Allow writes with uncommitted Git changes.
  --help, -h                Show this help.
''';
