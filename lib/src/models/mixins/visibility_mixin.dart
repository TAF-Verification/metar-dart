part of models;

mixin VisibilityMixin on Report {
  Prevailing _visibility = Prevailing(null, null);

  void _handleVisibility(String group) {
    final match = RegularExpresions.VISIBILITY.firstMatch(group);
    _visibility = Prevailing(group, match);

    _concatenateString(_visibility);
  }

  /// Get the prevailing visibility data of the report.
  Prevailing get visibility => _visibility;
}
