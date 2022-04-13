part of models;

class MetarPressure extends Pressure with GroupMixin {
  MetarPressure(String? code, RegExpMatch? match) : super(null) {
    _code = code;

    if (match != null) {
      final _units = match.namedGroup('units');
      final _press = match.namedGroup('press');
      final _unit2 = match.namedGroup('units2');

      if (_press != '//\//') {
        var _pressure = double.parse(_press!);

        if (_units == 'A' || _unit2 == 'INS') {
          _pressure = _pressure / 100 * Conversions.INHG_TO_HPA;
        } else if (<String>['Q', 'QNH'].contains(_units)) {
          _pressure *= 1;
        } else if (_pressure > 2500.0) {
          _pressure = _pressure * Conversions.INHG_TO_HPA;
        } else {
          _pressure = _pressure * Conversions.MBAR_TO_HPA;
        }

        _value = _pressure;
      }
    }
  }
}

mixin PressureMixin on StringAttributeMixin {
  late MetarPressure _pressure = MetarPressure(null, null);

  void _handlePressure(String group) {
    final match = MetarRegExp.PRESSURE.firstMatch(group);
    _pressure = MetarPressure(group, match);

    _concatenateString(_pressure);
  }

  MetarPressure get pressure => _pressure;
}
