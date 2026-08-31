import 'dart:io';

void main(List<String> arguments) {
  if (arguments.isEmpty || arguments.length > 2) {
    stderr.writeln(
      'Usage: dart run scripts/check_coverage.dart <lcov.info> [minimum-percent]',
    );
    exitCode = 64;
    return;
  }

  final coverageFile = File(arguments.first);
  final minimumPercent =
      arguments.length == 2 ? double.tryParse(arguments[1]) : 60.0;

  if (minimumPercent == null ||
      minimumPercent.isNaN ||
      minimumPercent < 0 ||
      minimumPercent > 100) {
    stderr.writeln('Minimum coverage must be a number from 0 to 100.');
    exitCode = 64;
    return;
  }

  if (!coverageFile.existsSync()) {
    stderr.writeln('Coverage file not found: ${coverageFile.path}');
    exitCode = 66;
    return;
  }

  var linesFound = 0;
  var linesHit = 0;

  for (final line in coverageFile.readAsLinesSync()) {
    if (line.startsWith('LF:')) {
      linesFound += _parseCount(line, coverageFile.path);
    } else if (line.startsWith('LH:')) {
      linesHit += _parseCount(line, coverageFile.path);
    }
  }

  if (linesFound == 0) {
    stderr.writeln('Coverage file contains no executable lines.');
    exitCode = 65;
    return;
  }

  final actualPercent = linesHit / linesFound * 100;
  stdout.writeln(
    'Mobile line coverage: $linesHit/$linesFound '
    '(${actualPercent.toStringAsFixed(1)}%; minimum '
    '${minimumPercent.toStringAsFixed(1)}%)',
  );

  if (actualPercent < minimumPercent) {
    stderr.writeln('Coverage is below the required minimum.');
    exitCode = 1;
  }
}

int _parseCount(String line, String path) {
  final count = int.tryParse(line.substring(3));
  if (count == null || count < 0) {
    throw FormatException('Invalid LCOV count in $path: $line');
  }
  return count;
}
