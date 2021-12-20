part of models;

mixin WindMixin on Report {
  Wind _wind = Wind(null, null);

  void _handleWind(String group) {
    final match = RegularExpresions.WIND.firstMatch(group);

    _wind = Wind(group, match);

    _concatenateString(_wind);
  }

  /// Get the modifier type of the report.
  Wind get wind => _wind;
}
