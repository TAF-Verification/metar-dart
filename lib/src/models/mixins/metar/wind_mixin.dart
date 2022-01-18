part of models;

/// Mixin to add a METAR wind group attribute to the report.
mixin MetarWindMixin on Report {
  MetarWind _wind = MetarWind(null, null);

  void _handleWind(String group) {
    final match = MetarRegExp.WIND.firstMatch(group);
    _wind = MetarWind(group, match);

    _concatenateString(_wind);
  }

  /// Get the wind data of the report.
  MetarWind get wind => _wind;
}
