part of reports;

/// Basic structure for distance attributes.
class Distance extends Numeric {
  Distance(String? code) : super(null) {
    code ??= '//\//';

    if (code == '9999') {
      code = '10000';
    }

    final _distance = double.tryParse(code);
    _value = _distance;
  }

  @override
  String toString() {
    if (_value != null) {
      return super.toString() + ' m';
    }

    return super.toString();
  }

  /// Get the distance in meters.
  double? get inMeters => _value;

  /// Get the distance in kilometers.
  double? get inKilometers => converted(conversionDouble: Conversions.M_TO_KM);

  /// Get the distance in sea miles.
  double? get inSeaMiles => converted(conversionDouble: Conversions.M_TO_SMI);

  /// Get the distance in feet.
  double? get inFeet => converted(conversionDouble: Conversions.M_TO_FT);

  @override
  Map<String, Object?> asMap() {
    return {
      'units': 'meters',
      'distance': inMeters,
    };
  }
}
