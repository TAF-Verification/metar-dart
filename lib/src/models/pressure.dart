import 'package:metar_dart/src/models/descriptors.dart';
import 'package:metar_dart/src/utils/utils.dart';

class PressureValue {
  double? _pressure;

  PressureValue(double? value) {
    if (value == null) {
      _pressure = null;
    } else {
      _pressure = value;
    }
  }

  @override
  String toString() {
    return _pressure.toString();
  }

  double? get pressure => _pressure;
}

class Pressure extends Group {
  PressureValue _pressure = PressureValue(null);

  Pressure(String? code, RegExpMatch? match) : super(code) {
    if (match != null) {
      final units = match.namedGroup('units');
      final units2 = match.namedGroup('units2');
      final press = match.namedGroup('press');

      _pressure = PressureValue(_handlePressure(units, units2, press));
    }
  }

  double? _handlePressure(String? units, String? units2, String? press) {
    int? value;
    if (press != '//\//') {
      value = int.parse(press.toString());

      if (units == 'A' || units2 == 'INS') {
        return value / 100.0 * Conversions.INHG_TO_HPA;
      } else if (['Q', 'QNH'].contains(units)) {
        return value.toDouble();
      } else if (value > 2500.0) {
        return value * Conversions.INHG_TO_HPA;
      } else {
        return value * Conversions.MBAR_TO_HPA;
      }
    } else {
      return null;
    }
  }

  @override
  String toString() {
    if (_pressure.pressure == null) {
      return '';
    }

    return '${inHectoPascals!.toStringAsFixed(2)} hPa';
  }

  double? get inHectoPascals => handleValue(_pressure.pressure, 1);
  double? get inMercuryInches =>
      handleValue(_pressure.pressure, Conversions.HPA_TO_INHG);
  double? get inMilliBars =>
      handleValue(_pressure.pressure, Conversions.HPA_TO_MBAR);
  double? get inBars => handleValue(_pressure.pressure, Conversions.HPA_TO_BAR);
  double? get inAtmospheres =>
      handleValue(_pressure.pressure, Conversions.HPA_TO_ATM);
}
