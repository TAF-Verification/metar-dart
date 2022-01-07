part of models;

/// Mixin to add wind attribute to the report.
mixin WindMixin on Report {
  Wind _wind = Wind(null, null);

  void _handleWind(String group) {
    final match = RegularExpresions.WIND.firstMatch(group);

    _wind = Wind(group, match);

    _concatenateString(_wind);
  }

  /// Get the wind data of the report.
  Wind get wind => _wind;
}
