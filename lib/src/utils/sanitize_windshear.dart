part of utils;

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
