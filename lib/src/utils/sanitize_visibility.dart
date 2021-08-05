String sanitizeVisibility(String report) {
  final regex = RegExp(r'\s(?<int>\d+)\s(?<frac>\d/\dSM)\s?');

  for (var i = 0; i < 3; i++) {
    if (regex.hasMatch(report)) {
      final match = regex.allMatches(report);
      final matches = match.elementAt(0);
      report = report.replaceFirst(
        regex,
        ' ${matches.namedGroup('int')}_${matches.namedGroup('frac')} ',
      );
    }
  }

  return report;
}
