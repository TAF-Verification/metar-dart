part of models;

/// Basic structure for pressure attributes.
class Pressure extends Numeric {
  Pressure(String? code) : super(null) {
    code ??= '//\//';

    final _pressure = double.tryParse(code);
    _value = _pressure;
  }

  @override
  String toString() {
    if (_value != null) {
      return super.toString() + ' hPa';
    }

    return super.toString();
  }

  /// Get the pressure in hecto pascals (hPa).
  double? get inHPa => _value;

  /// Get the pressure in mercury inches (inHg).
  double? get inInHg => converted(conversionDouble: Conversions.HPA_TO_INHG);

  /// Get the pressure in millibars (mbar).
  double? get inMbar => converted(conversionDouble: Conversions.HPA_TO_MBAR);

  /// Get the pressure in bars (bar).
  double? get inBar => converted(conversionDouble: Conversions.HPA_TO_BAR);

  /// Get the pressure in atmospheres (atm).
  double? get inAtm => converted(conversionDouble: Conversions.HPA_TO_ATM);
}
