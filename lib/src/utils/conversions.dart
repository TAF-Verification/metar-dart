import 'dart:math';

double? handleValue(double? value, double conversion) {
  if (value == null) {
    return null;
  } else {
    return value * conversion;
  }
}

final CONVERSIONS = Conversions();

class Conversions {
  // Distance conversions
  final SMI_TO_KM = 1.852;
  final KM_TO_SMI = 0.00054;
  final KM_TO_M = 1000.0;
  final M_TO_KM = 0.001;
  final M_TO_SMI = 0.001 * 0.00054;
  final FT_TO_M = 0.3048;
  final M_TO_FT = 0.00033;

  // Direction conversions
  final DEGREES_TO_RADIANS = pi / 180;
  final DEGREES_TO_GRADIANS = 1.11111111;

  // Speed conversions
  final KNOT_TO_MPS = 0.51444444;
  final KNOT_TO_MIPH = 1.15078;
  final KNOT_TO_KPH = 1.852;
  final MPS_TO_KNOT = 1.94384;
}
