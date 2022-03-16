part of models;

/// Basic structure for change indicators in TAF.
class TafChangeIndicator extends ChangeIndicator {
  late Valid _valid;

  TafChangeIndicator(String? code, RegExpMatch? match, Valid tafValid)
      : super(code, match) {
    _valid = tafValid;

    if (match != null) {
      if (code!.startsWith('FM')) {
        final day = int.parse(match.namedGroup('day')!);
        final hour = int.parse(match.namedGroup('hour')!);
        final minute = int.parse(match.namedGroup('minute')!);

        var time = tafValid.periodFrom.time;
        while (day != time.day) {
          time = time.add(const Duration(days: 1));
        }
        time = DateTime(time.year, time.month, time.day, hour, minute);

        _valid = Valid(null, Time(time: time), tafValid.periodUntil);

        _translation = '$_valid';
      }
    }
  }

  /// Set the valid time period group of the change indicator.
  ///
  /// Args:
  ///     match (RegExpMatch): the match of the regular expression of valid time period.
  ///     tafTime (Time): the datetime of the TAF report.
  void setValidPeriod(String code, RegExpMatch match, Time tafTime) {
    _valid = Valid.fromTaf(code, match, tafTime.time);

    if (_code!.startsWith('FM')) {
      _translation = '$_valid';
    } else {
      _translation = '$_translation $_valid';
    }
  }

  /// Reset the until time period of change indicators in the
  /// form `FMYYGGgg` only, because these haven't a group of valid
  /// time period.
  ///
  /// Args:
  ///     until (Time): the until time period that this change indicator
  ///     applies to.
  void resetUntilPeriod(Time until) {
    if (_code!.startsWith('FM')) {
      _valid = Valid(null, _valid.periodFrom, until);
      _translation = '$_valid';
    }
  }

  /// Get the valid period of the change indicator.
  Valid get valid => _valid;
}