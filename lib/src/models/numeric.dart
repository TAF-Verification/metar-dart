part of models;

abstract class Numeric {
  late double? _value;

  Numeric(double? value) {
    _value = value;
  }

  @override
  String toString() {
    if (_value == null) {
      return '';
    }

    return _value!.toStringAsFixed(1);
  }

  double? converted(
      {double? conversionDouble, double Function(double)? conversionFunction}) {
    if (conversionDouble != null && _value != null) {
      return conversionDouble * _value!;
    }

    if (conversionFunction != null && _value != null) {
      return conversionFunction(_value!);
    }

    return _value;
  }

  /// Get the value as a float.
  double? get value => _value;
}
