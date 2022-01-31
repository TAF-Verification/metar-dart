part of models;

/// Basic structure for temperatures in reports from land stations.
class Temperatures extends Group {
  Temperature _temperature = Temperature(null);
  Temperature _dewpoint = Temperature(null);

  Temperatures(String? code, RegExpMatch? match) : super(code) {
    if (match != null) {
      final _tsign = match.namedGroup('tsign');
      final _temp = match.namedGroup('temp');
      final _dsign = match.namedGroup('dsign');
      final _dewpt = match.namedGroup('dewpt');

      _temperature = _setTemperature(_temp, _tsign);
      _dewpoint = _setTemperature(_dewpt, _dsign);
    }
  }

  @override
  String toString() {
    if (_temperature.value == null && _dewpoint.value == null) {
      return '';
    } else if (_temperature.value == null && _dewpoint.value != null) {
      return 'no temperature | dewpoint: $_dewpoint';
    } else if (_temperature.value != null && _dewpoint.value == null) {
      return 'temperature: $_temperature | no dewpoint';
    } else {
      return 'temperature: $_temperature | dewpoint: $_dewpoint';
    }
  }

  /// Handler to set the temperature value.
  Temperature _setTemperature(String? code, String? sign) {
    if (<String>['M', '-'].contains(sign)) {
      return Temperature('-$code');
    }

    return Temperature('$code');
  }

  /// Get the temperature in °Celsius.
  double? get temperatureInCelsius => _temperature.inCelsius;

  /// Get the temperature in °Kelvin.
  double? get temperatureInKelvin => _temperature.inKelvin;

  /// Get the temperature in °Fahrenheit.
  double? get temperatureInFahrenheit => _temperature.inFahrenheit;

  /// Get the temperature in Rankine.
  double? get temperatureInRankine => _temperature.inRankine;

  /// Get the dewpoint in °Celsius.
  double? get dewpointInCelsius => _dewpoint.inCelsius;

  /// Get the dewpoint in °Kelvin.
  double? get dewpointInKelvin => _dewpoint.inKelvin;

  /// Get the dewpoint in °Fahrenheit.
  double? get dewpointInFahrenheit => _dewpoint.inFahrenheit;

  /// Get the dewpoint in Rankine.
  double? get dewpointInRankine => _dewpoint.inRankine;
}
