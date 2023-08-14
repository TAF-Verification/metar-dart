part of models;

/// Basic structure for valid time groups in change periods and forecasts.
class TafTurbulence extends Group {
  TafTurbulence(String? code) : super(code);

  late int layerBaseInFeet;
  late int layerBaseInMeters;
  late int thicknessLevel;
  late int thicknessInFeet;
  late int thicknessInMeters;

  late String? intensity, weatherCondition, frequency;

  /// Named constructor of the TafTurbulence clas
  ///
  /// Args:
  ///   code (String?): the code of the group.
  ///   match (RegExpMatch?): the match of the regular expression.
  TafTurbulence.fromTaf(String? code, RegExpMatch? match) : super(code) {
    if (match != null) {
      layerBaseInFeet = int.parse(match.namedGroup('base')!) * 100;
      layerBaseInMeters = (layerBaseInFeet * Conversions.FT_TO_M).round();
      final turbType = int.parse(match.namedGroup('turbType')!);
      final thicknessLevel = int.parse(match.namedGroup('thickness')!);
      thicknessInFeet = thicknessLevel * 1000;
      thicknessInMeters = (thicknessInFeet * Conversions.FT_TO_M).round();

      intensity = getIntensity(turbType);
      weatherCondition = getWeatherCondition(turbType);
      frequency = getFrequency(turbType);
    }
  }

  @override
  String toString() {
    return '$intensity turbulence between ${layerBaseInFeet == 0 ? 'surface' : '$layerBaseInFeet ft'} and ${layerBaseInFeet + thicknessInFeet} ft';
  }

  String? getIntensity(int turbType) {
    return [
      'None',
      'Light',
      'Moderate',
      'Moderate',
      'Moderate',
      'Moderate',
      'Severe',
      'Severe',
      'Severe',
      'Severe'
    ][turbType];
  }

  String? getWeatherCondition(int turbType) {
    return [
      null,
      null,
      'Clear',
      'Clear',
      'Cloud',
      'Cloud',
      'Clear',
      'Clear',
      'Cloud',
      'Cloud'
    ][turbType];
  }

  String? getFrequency(int turbType) {
    return [
      null,
      null,
      'Occasional',
      'Frequent',
      'Occasional',
      'Frequent',
      'Occasional',
      'Frequent',
      'Occasional',
      'Frequent'
    ][turbType];
  }
}

/// Mixin to add the valid period of forecast attribute and handler.
mixin TafTurbulenceMixin on StringAttributeMixin {
  final List<TafTurbulence> _turbulences = [];

  void _handleTurbulence(String group) {
    final match = TafRegExp.TURBULENCE.firstMatch(group);
    final turb = TafTurbulence.fromTaf(group, match);
    _turbulences.add(turb);
    _concatenateString(turb);
  }

  List<TafTurbulence> get turbulences => _turbulences;
}
