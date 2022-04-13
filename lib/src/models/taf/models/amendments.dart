part of models;

/// Basic structure for valid time groups in change periods and forecasts.
class TafAmendments extends Group {
  TafAmendments(String? code) : super(code);

  DateTime? after, next;
  bool nextNotSked = false;

  /// Named constructor of the TafAmendments clas
  ///
  /// Args:
  ///   code (String?): the code of the group.
  ///   match (RegExpMatch?): the match of the regular expression.
  TafAmendments.fromTaf(String? code, RegExpMatch? match) : super(code) {
    if (match != null) {
      final afterd = match.namedGroup('afterd') ?? match.namedGroup('afterd2');
      final afterh = match.namedGroup('afterh') ?? match.namedGroup('afterh2');
      final nextd = match.namedGroup('nextd');
      final nexth = match.namedGroup('nextd');

      if (match.input == 'AMD_NOT_SKED' || (afterd == null && nexth == null)) {
        nextNotSked = true;
        return;
      }

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
    if (nextNotSked) {
      return 'AMD_NOT_SKED';
    }
    if (next != null) {
      return 'No amendments between ${after!.hour}:00 UTC on the ${after!.day}${daySuffix(after!.day)} and ${next!.hour}:00 UTC on the ${next!.day}${daySuffix(next!.day)}';
    }
    return 'No amendments after ${after!.hour}:00 UTC on the ${after!.day}${daySuffix(after!.day)}';
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
mixin TafAmendmentsMixin on StringAttributeMixin {
  late final TafAmendments _amendment;

  void _handleAmendment(String group) {
    final match = TafRegExp.AMENDMENTS.firstMatch(group);
    _amendment = TafAmendments.fromTaf(group, match);
    _concatenateString(_amendment);
  }

  TafAmendments get ammendment => _amendment;
}

String sanitizeAmendments(String code) {
  return code
      .replaceAll(' LAST NO AMDS AFT ', ' LAST_NO_AMDS_AFT_')
      .replaceAll(' AFT ', ' AFT_')
      .replaceAll(' NEXT ', '_NEXT_')
      .replaceAll(' AMD NOT SKED', ' AMD_NOT_SKED');
}
