part of models;

mixin ModifierMixin on Report {
  Modifier _modifier = Modifier(null);

  void _handleModifier(String group) {
    _modifier = Modifier(group);

    _concatenateString(_modifier);
  }

  /// Get the modifier type of the report.
  Modifier get modifier => _modifier;
}
