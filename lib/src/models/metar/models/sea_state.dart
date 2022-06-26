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
  String? _state;
  Distance _height = Distance(null);

  MetarSeaState(String? code, RegExpMatch? match) : super(code) {
    if (match != null) {
      final sign = match.namedGroup('sign');
      final temp = match.namedGroup('temp');
      final state = match.namedGroup('state');
      final height = match.namedGroup('height');

      if (<String>['M', '-'].contains(sign)) {
        _temperature = Temperature('-$temp');
      } else {
        _temperature = Temperature(temp);
      }

      _state = SEA_STATE[state];

      late final double? heightAsDouble;
      try {
        heightAsDouble = int.parse('$height') / 10;
      } catch (e) {
        heightAsDouble = null;
      } finally {
        _height = Distance('$heightAsDouble');
      }
    }
  }

  @override
  String toString() {
    if (_temperature.value == null && _height.value == null && _state == null) {
      return '';
    }

    var s = '';

    if (_temperature.value != null) {
      s += 'temperature $_temperature, ';
    } else {
      s += 'no temperature, ';
    }

    if (_height.value != null) {
      s += 'significant wave height $_height, ';
    } else {
      s += 'no significant wave height, ';
    }

    if (_state != null) {
      s += _state!;
    } else {
      s += 'no sea state';
    }

    return s;
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

  /// Get the height of the significant wave in meters.
  double? get heightInMeters => _height.inMeters;

  /// Get the height of the significant wave in centimeters.
  double? get heightInCentimeters =>
      _height.converted(conversionDouble: Conversions.M_TO_CM);

  /// Get the height of the significant wave in decimeters.
  double? get heightInDecimeters =>
      _height.converted(conversionDouble: Conversions.M_TO_DM);

  /// Get the height of the significant wave in feet.
  double? get heightInFeet =>
      _height.converted(conversionDouble: Conversions.M_TO_FT);

  /// Get the height of the significant wave in inches.
  double? get heightInInches =>
      _height.converted(conversionDouble: Conversions.M_TO_IN);

  @override
  Map<String, Object?> asMap() {
    final map = {
      'state': state,
      'temperature': _temperature.asMap(),
      'height': _height.asMap(),
    };
    map.addAll(super.asMap());
    return map;
  }
}
