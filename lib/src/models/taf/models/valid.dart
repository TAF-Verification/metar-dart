part of models;

/// Basic structure for valid time groups in change periods and forecasts.
class Valid extends Group {
  late final Time _from;
  late final Time _until;

  Valid(String? code, this._from, this._until) : super(code);

  /// Named constructor of the Valid class using a TAF like
  /// group of valid period of time.
  ///
  /// Args:
  ///   code (String?): the code of the group.
  ///   match (RegExpMatch?): the match of the regular expression.
  ///   time (DateTime): the initial valid time of the forecast.
  Valid.fromTaf(String? code, RegExpMatch? match, DateTime time) : super(code) {
    time = DateTime(
      time.year,
      time.month,
      time.day,
      time.hour,
      0,
      time.second,
      time.millisecond,
      time.microsecond,
    );

    if (match == null) {
      time = time.add(const Duration(hours: 1));

      _from = Time(time: time);
      _until = Time(time: time.add(const Duration(hours: 24)));
    } else {
      final _fmday = int.parse(match.namedGroup('fmday')!);
      final _fmhour = int.parse(match.namedGroup('fmhour')!);
      final _tlday = int.parse(match.namedGroup('tlday')!);
      var _tlhour = int.parse(match.namedGroup('tlhour')!);

      late DateTime from;
      late DateTime until;
      if (_fmday == time.day) {
        from = time;
      } else {
        from = time.add(const Duration(days: 1));
      }

      if (_tlday == time.day) {
        until = time;
      } else {
        until = time.add(const Duration(days: 1));
      }

      if (_tlhour == 24) {
        until = until.add(const Duration(days: 1));
        _tlhour = 0;
      }

      _from = Time(
          time: DateTime(
        from.year,
        from.month,
        from.day,
        _fmhour,
        from.minute,
        from.second,
        from.millisecond,
        from.microsecond,
      ));

      _until = Time(
          time: DateTime(
        until.year,
        until.month,
        until.day,
        _tlhour,
        until.minute,
        until.second,
        until.millisecond,
        until.microsecond,
      ));
    }
  }

  @override
  String toString() {
    return 'from $_from until $_until';
  }

  /// Get the time period `from` of the forecast.
  Time get periodFrom => _from;

  /// Get the time period `until` of the forecast.
  Time get periodUntil => _until;

  @override
  Map<String, Object?> toMap() {
    final map = super.toMap();
    map.addAll({
      'from_': periodFrom.toMap(),
      'until': periodUntil.toMap(),
    });
    return map;
  }
}

/// Mixin to add the valid period of forecast attribute and handler.
mixin TafValidMixin on StringAttributeMixin, TimeMixin {
  /// Initialize this attribute in the constructor of the client class.
  /// `_valid = Valid.fromTaf(null, null, _time.time);`
  late Valid _valid;

  void _handleValidPeriod(String group) {
    final match = TafRegExp.VALID.firstMatch(group);
    _valid = Valid.fromTaf(group, match, _time.time);

    _concatenateString(_valid);
  }

  /// Get the dates of valid period of the forecast.
  Valid get valid => _valid;
}
