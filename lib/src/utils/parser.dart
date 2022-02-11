part of utils;

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

String sanitizeWindshear(String code) {
  code = code.replaceFirst(RegExp(r'WS\sALL\sRWY'), 'WS_ALL_RWY');

  final regex = RegExp(r'WS\sR(WY)?(?<name>\d{2}[CLR]?)');
  for (var i = 1; i <= 3; i++) {
    if (regex.hasMatch(code)) {
      final match = regex.firstMatch(code);
      code = code.replaceFirst(
        regex,
        'WS_R${match!.namedGroup("name")}',
      );
    }
  }

  return code;
}

/// Parse the groups of the section.
///
/// Args:
///     handlers (List<GroupHandler>): handler list to manage and match.
///     section (String): the section containing all the groups to parse separated
///     by spaces.
///
/// Returns:
///     unparsed_groups (List<String>): the not matched groups with anyone
///     of the regular expresions stored in `handlers`.
List<String> parseSection(List<GroupHandler> handlers, String section) {
  final unparsedGroups = <String>[];
  var index = 0;

  section.split(' ').forEach((group) {
    unparsedGroups.add(group);

    for (var i = index; i < handlers.length; i++) {
      var handler = handlers[i];
      index++;

      if (handler.regexp.hasMatch(group)) {
        handler.handler(group);
        unparsedGroups.remove(group);
        break;
      }
    }
  });

  return unparsedGroups;
}
