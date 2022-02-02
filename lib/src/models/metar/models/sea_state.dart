part of models;

/// Table 3700
final SEA_STATE = <String, String>{
  '0': 'calm (glassy)',
  '1': 'calm (rippled)',
  '2': 'smooth (wavelets)',
  '3': 'slight',
  '4': 'moderate',
  '5': 'rough',
  '6': 'very rough',
  '7': 'high',
  '8': 'very high',
  '9': 'phenomenal',
};

/// Basic structure for sea state data in METAR.
class MetarSeaState extends Group {
  Temperature _temperature = Temperature(null);
  String? _state = null;

  MetarSeaState(String? code, RegExpMatch? match) : super(code) {
    if (match != null) {
      final sign = match.namedGroup('sign');
      final temp = match.namedGroup('temp');
      final state = match.namedGroup('state');

      if (<String>['M', '-'].contains(sign)) {
        _temperature = Temperature('-$temp');
      } else {
        _temperature = Temperature(temp);
      }

      _state = SEA_STATE[state];
    }
  }

  @override
  String toString() {
    if (_temperature.value == null && _state != null) {
      return 'no temperature, $_state';
    } else if (_temperature.value != null && _state == null) {
      return 'temperature $_temperature, no sea state';
    } else if (_temperature.value == null && _state == null) {
      return '';
    } else {
      return 'temperature $_temperature, $_state';
    }
  }

  /// Get the sea state if provided in METAR.
  String? get state => _state;

  /// Get the temperature of the sea in Celsius.
  double? get temperatureInCelsius => _temperature.inCelsius;

  /// Get the temperature of the sea in Kelvin.
  double? get temperatureInKelvin => _temperature.inKelvin;

  /// Get the temperature of the sea in Fahrenheit.
  double? get temperatureInFahrenheit => _temperature.inFahrenheit;

  /// Get the temperature of the sea in Rankine.
  double? get temperatureInRankine => _temperature.inRankine;
}
