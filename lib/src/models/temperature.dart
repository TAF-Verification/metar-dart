part of models;

/// Basic structure for temperature attributes.
class Temperature extends Numeric {
  Temperature(String? code) : super(null) {
    _setTemperature(code);
  }

  void _setTemperature(String? code) {
    if (code == null || <String>['///', '//'].contains(code)) {
      code = '///';
    }

    if (code.replaceFirst('-', '').length == 2) {
      code += '0';
    }

    assert(code.replaceFirst('-', '').length == 3,
        'temperature code must have 3 or 2 digits length');

    double? _temperature;
    try {
      _temperature = double.parse(code) / 10;
    } catch (e) {
      _temperature = null;
    }
    _value = _temperature;
  }

  @override
  String toString() {
    if (_value != null) {
      return super.toString() + '°C';
    }

    return super.toString();
  }

  /// Get the temperature in Celsius.
  double? get inCelsius => _value;

  /// Get the temperature in Kelvin.
  double? get inKelvin =>
      converted(conversionFunction: Conversions.celsiusToKelvin);

  /// Get the temperature in Fahrenheit.
  double? get inFahrenheit =>
      converted(conversionFunction: Conversions.celsiusToFahrenheit);

  /// Get the temperature in Rankine.
  double? get inRankine =>
      converted(conversionFunction: Conversions.celsiusToRankine);
}

mixin MetarTemperatureMixin on StringAttributeMixin {
  late MetarTemperatures _temperatures = MetarTemperatures(null, null);

  void _handleTemperatures(String group) {
    final match = MetarRegExp.TEMPERATURES.firstMatch(group);
    _temperatures = MetarTemperatures(group, match);

    _concatenateString(_temperatures);
  }

  /// Get the temperatures data of the METAR.
  MetarTemperatures get temperatures => _temperatures;
}