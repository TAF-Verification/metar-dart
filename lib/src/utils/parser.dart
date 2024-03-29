part of utils;

/// Sanitize the visibility in sea miles to get macth
/// with the regular expresion of visibility in METAR like
/// reports.
///
/// Args:
///     code (String): the code or section to sanitize.
///
/// Returns:
///     String: the sanitized code or section.
String sanitizeVisibility(String code) {
  final regex = RegExp(r'\s(?<int>\d+)\s(?<frac>\d/\dSM)\s?');

  for (var i = 0; i < 3; i++) {
    if (regex.hasMatch(code)) {
      final match = regex.firstMatch(code)!;
      code = code.replaceFirst(
        regex,
        ' ${match.namedGroup('int')}_${match.namedGroup('frac')} ',
      );
    }
  }

  return code;
}

/// Sanitize the windshear in to get macth with the
/// regular expresion of windshear in METAR like reports.
///
/// Args:
///     code (String): the code or section to sanitize.
///
/// Returns:
///     String: the sanitized code or section.
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

/// Sanitize the `PROB[34]0 TEMPO` to get match with the
/// regular expression of the change indicator in TAF like reports.

/// Args:
///     code (String): the report or section to sanitize.

/// Returns:
///     String: the sanitized report or section.
String sanitizeChangeIndicator(String code) {
  final regex = RegExp(r'PROB(?<percent>[34]0)\sTEMPO');
  for (var i = 0; i < 5; i++) {
    if (regex.hasMatch(code)) {
      final match = regex.firstMatch(code);
      code =
          code.replaceFirst(regex, 'PROB${match!.namedGroup("percent")}_TEMPO');
    } else {
      break;
    }
  }

  return code;
}
