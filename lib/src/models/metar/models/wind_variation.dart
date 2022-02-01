part of models;

class MetarWindVariation extends Group {
  Direction _from = Direction(null);
  Direction _to = Direction(null);

  MetarWindVariation(String? code, RegExpMatch? match) : super(code) {
    if (match != null) {
      _from = Direction(match.namedGroup('from'));
      _to = Direction(match.namedGroup('to'));
    }
  }

  @override
  String toString() {
    if (_from.value == null) {
      return '';
    }

    return 'from'
        ' ${_from.cardinal}'
        ' ($_from)'
        ' to'
        ' ${_to.cardinal}'
        ' ($_to)';
  }

  /// Get the `from` cardinal direction.
  String? get fromCardinalDirection => _from.cardinal;

  /// Get the `from` direction in degrees.
  double? get fromInDegrees => _from.value;

  /// Get the `from` direction in radians.
  double? get fromInRadians =>
      _from.converted(conversionDouble: Conversions.DEGREES_TO_RADIANS);

  /// Get the `from` direction in gradians.
  double? get fromInGradians =>
      _from.converted(conversionDouble: Conversions.DEGREES_TO_GRADIANS);

  /// Get the `to` cardinal direction.
  String? get toCardinalDirection => _to.cardinal;

  /// Get the `to` direction in degrees.
  double? get toInDegrees => _to.value;

  /// Get the `to` direction in radians.
  double? get toInRadians =>
      _to.converted(conversionDouble: Conversions.DEGREES_TO_RADIANS);

  /// Get the `to` direction in gradians.
  double? get toInGradians =>
      _to.converted(conversionDouble: Conversions.DEGREES_TO_GRADIANS);
}
