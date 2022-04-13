part of models;

class TafIcing extends Group {
  TafIcing(String? code) : super(code);

  late int layerBaseInFeet;
  late int layerBaseInMeters;
  late int thicknessLevel;
  late int thicknessInFeet;
  late int thicknessInMeters;

  late String? intensity, location, frequency;

  /// Named constructor of the TafIcing clas
  ///
  /// Args:
  ///   code (String?): the code of the group.
  ///   match (RegExpMatch?): the match of the regular expression.
  TafIcing.fromTaf(String? code, RegExpMatch? match) : super(code) {
    if (match != null) {
      layerBaseInFeet = int.parse(match.namedGroup('base')!) * 100;
      layerBaseInMeters = (layerBaseInFeet * Conversions.FT_TO_M).round();
      final turbType = int.parse(match.namedGroup('icingType')!);
      final thicknessLevel = int.parse(match.namedGroup('thickness')!);
      thicknessInFeet = thicknessLevel * 1000;
      thicknessInMeters = (thicknessInFeet * Conversions.FT_TO_M).round();

      intensity = getIntensity(turbType);
      location = getLocation(turbType);
    }
  }

  @override
  String toString() {
    return '$intensity icing between ${layerBaseInFeet == 0 ? 'surface' : '$layerBaseInFeet ft'} and ${layerBaseInFeet + thicknessInFeet} ft${location != null ? ' ($location)' : ''}';
  }

  String? getIntensity(int turbType) {
    return [
      'None',
      'Light',
      'Light',
      'Light',
      'Moderate',
      'Moderate',
      'Moderate',
      'Severe',
      'Severe',
      'Severe'
    ][turbType];
  }

  String? getLocation(int turbType) {
    return [
      'None',
      null,
      'In cloud',
      'In precipitation',
      null,
      'In cloud',
      'In precipitation',
      null,
      'In cloud',
      'In precipitation',
    ][turbType];
  }
}

/// Mixin to add the valid period of forecast attribute and handler.
mixin TafIcingMixin on StringAttributeMixin {
  final List<TafIcing> _icings = [];

  void _handleIcing(String group) {
    final match = TafRegExp.ICING.firstMatch(group);
    final icing = TafIcing.fromTaf(group, match);
    _icings.add(icing);
    _concatenateString(icing);
  }

  List<TafIcing> get icings => _icings;
}
