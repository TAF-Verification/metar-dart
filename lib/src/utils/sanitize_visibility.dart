String sanitizeVisibility(String report) {
  final regex = RegExp(r'\s(?<int>\d+)\s(?<frac>\d/\dSM)\s?');

  for (var i = 0; i < 3; i++) {
    if (regex.hasMatch(report)) {
      final match = regex.firstMatch(report)!;
      report = report.replaceFirst(
        regex,
        ' ${match.namedGroup('int')}_${match.namedGroup('frac')} ',
      );
    }
  }

  return report;
}
