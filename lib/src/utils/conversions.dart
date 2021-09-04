import 'dart:math';

double? handleValue(double? value, double conversion) {
  if (value == null) {
    return null;
  } else {
    final val = (value * conversion).toStringAsFixed(5);
    return double.parse(val);
  }
}

double? handleTemperature(double? value, double Function(double) conversion) {
  if (value == null) {
    return null;
  } else {
    final val = conversion(value).toStringAsFixed(5);
    return double.parse(val);
  }
}

class Conversions {
  // Distance conversions
  static final SMI_TO_KM = 1.852;
  static final KM_TO_SMI = 1 / SMI_TO_KM;
  static final KM_TO_M = 1000.0;
  static final M_TO_KM = 1 / KM_TO_M;
  static final M_TO_SMI = M_TO_KM * KM_TO_SMI;
  static final FT_TO_M = 0.3048;
  static final M_TO_FT = 1 / FT_TO_M;

  // Direction conversions
  static final DEGREES_TO_RADIANS = pi / 180;
  static final DEGREES_TO_GRADIANS = 1.11111111;

  // Speed conversions
  static final KNOT_TO_MPS = 0.51444444;
  static final KNOT_TO_MIPH = 1.15078;
  static final KNOT_TO_KPH = 1.852;
  static final MPS_TO_KNOT = 1 / KNOT_TO_MPS;

  // Pressure conversions
  static final HPA_TO_INHG = 0.02953;
  static final INHG_TO_HPA = 1 / HPA_TO_INHG;
  static final HPA_TO_BAR = 0.001;
  static final BAR_TO_HPA = 1 / HPA_TO_BAR;
  static final MBAR_TO_HPA = BAR_TO_HPA / 1000;
  static final HPA_TO_MBAR = HPA_TO_BAR * 1000;
  static final HPA_TO_ATM = 1 / 1013.25;

  // Temperature conversions
  static double celsiusToKelvin(double temp) {
    return temp + 273.15;
  }

  static double celsiusToFahrenheit(double temp) {
    return temp * 9 / 5 + 32;
  }

  static double celsiusToRankine(double temp) {
    return temp * 9 / 5 + 491.67;
  }

  // Helper when need to return same value
  static double sameValue(double value) {
    return value;
  }
}
