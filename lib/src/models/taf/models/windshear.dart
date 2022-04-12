part of models;

/// Basic structure for valid time groups in change periods and forecasts.
class TafWindshear extends Group {
  TafWindshear(String? code) : super(code);

  late int heightInFeet;
  late MetarWind wind;

  /// Named constructor of the TafWindshear clas
  ///
  /// Args:
  ///   code (String?): the code of the group.
  ///   match (RegExpMatch?): the match of the regular expression.
  TafWindshear.fromTaf(String? code, RegExpMatch? match) : super(code) {
    if (match != null) {
      heightInFeet = int.parse(match.namedGroup('height')!) * 100;
      wind = MetarWind(null, match);
    }
  }

  @override
  String toString() {
    return 'wind-shear at $heightInFeet feet, ${wind.toString()}';
  }
}

/// Mixin to add the valid period of forecast attribute and handler.
mixin TafWindshearMixin on StringAttributeMixin {
  final List<TafWindshear> _windshears = [];

  void _handleWindshear(String group) {
    final match = TafRegExp.WINDSHEAR.firstMatch(group);
    final _windshear = TafWindshear.fromTaf(group, match);
    _windshears.add(_windshear);
    _concatenateString(_windshear);
  }

  List<TafWindshear> get windshears => _windshears;
}
