part of models;

/// Mixin to add prevailing visibility attribute to the report.
mixin MetarPrevailingMixin on Report {
  MetarPrevailingVisibility _prevailing = MetarPrevailingVisibility(null, null);

  void _handlePrevailing(String group) {
    final match = MetarRegExp.VISIBILITY.firstMatch(group);
    _prevailing = MetarPrevailingVisibility(group, match);

    _concatenateString(_prevailing);
  }

  /// Get the prevailing visibility data of the report.
  MetarPrevailingVisibility get prevailingVisibility => _prevailing;
}
