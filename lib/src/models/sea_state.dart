import 'package:metar_dart/src/models/descriptors.dart';
import 'package:metar_dart/src/models/weather.dart' show Item;
import 'package:metar_dart/src/models/temperatures.dart'
    show Temperature, setTemperature;
import 'package:metar_dart/src/utils/utils.dart'
    show handleTemperature, Conversions, SkyTranslations;

class State extends Item {
  State(String? code) : super(SkyTranslations.SEA_STATE[code]);
}

class SeaState extends Group {
  Temperature _temperature = Temperature(null);
  State _state = State(null);

  SeaState(String? code, RegExpMatch? match) : super(code) {
    if (match != null) {
      final sign = match.namedGroup('sign');

      final temp = setTemperature(sign, match.namedGroup('temp'));
      _temperature = Temperature(temp);

      _state = State(match.namedGroup('state'));
    }
  }

  @override
  String toString() {
    if (_temperature.temperature == null && _state.value != null) {
      return 'no temperature, $state';
    } else if (_temperature.temperature != null && _state.value == null) {
      return 'temperature $temperatureInCelsius°';
    } else if (_temperature.temperature == null && _state.value == null) {
      return '';
    } else {
      return 'temperature $temperatureInCelsius°, $state';
    }
  }

  String? get state => _state.value;

  double? get temperatureInCelsius =>
      handleTemperature(_temperature.temperature, Conversions.sameValue);
  double? get temperatureInFahrenheit => handleTemperature(
      _temperature.temperature, Conversions.celsiusToFahrenheit);
  double? get temperatureInKelvin =>
      handleTemperature(_temperature.temperature, Conversions.celsiusToKelvin);
  double? get temperatureInRankine =>
      handleTemperature(_temperature.temperature, Conversions.celsiusToRankine);
}
