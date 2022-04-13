part of models;

/// Basic structure for valid time groups in change periods and forecasts.
class TafAmmendments extends Group {
  TafAmmendments(String? code) : super(code);

  DateTime? after, next;

  /// Named constructor of the TafAmmendments clas
  ///
  /// Args:
  ///   code (String?): the code of the group.
  ///   match (RegExpMatch?): the match of the regular expression.
  TafAmmendments.fromTaf(String? code, RegExpMatch? match) : super(code) {
    if (match != null) {
      final afterd = match.namedGroup('afterd') ?? match.namedGroup('afterd2');
      final afterh = match.namedGroup('afterh') ?? match.namedGroup('afterh2');
      final nextd = match.namedGroup('nextd');
      final nexth = match.namedGroup('nextd');

      after = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        int.parse(afterd!),
        int.parse(afterh!),
        0,
      );

      if (nextd != null && nexth != null) {
        next = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          int.parse(nextd),
          int.parse(nexth),
          0,
        );
      }
    }
  }

  @override
  String toString() {
    if (next != null) {
      return 'No ammendments between ${after!.hour}:00 UTC on the ${after!.day}${daySuffix(after!.day)} and ${next!.hour}:00 UTC on the ${next!.day}${daySuffix(next!.day)}';
    }
    return 'No ammendments after ${after!.hour}:00 UTC on the ${after!.day}${daySuffix(after!.day)}';
  }

  String daySuffix(int day) {
    switch (day) {
      case 1:
      case 21:
      case 31:
        return 'st';
      case 2:
      case 22:
        return 'nd';
      case 3:
      case 23:
        return 'rd';
      default:
        return 'th';
    }
  }
}

/// Mixin to add the valid period of forecast attribute and handler.
mixin TafAmmendmentsMixin on StringAttributeMixin {
  late final TafAmmendments _ammendment;

  void _handleAmmendment(String group) {
    final match = TafRegExp.AMMENDMENTS.firstMatch(group);
    _ammendment = TafAmmendments.fromTaf(group, match);
    _concatenateString(_ammendment);
  }

  TafAmmendments get ammendment => _ammendment;
}

String sanitizeAmmendments(String code) {
  return code
      .replaceAll(' LAST NO AMDS AFT ', ' LAST_NO_AMDS_AFT_')
      .replaceAll(' AFT ', ' AFT_')
      .replaceAll(' NEXT ', '_NEXT_');
}
