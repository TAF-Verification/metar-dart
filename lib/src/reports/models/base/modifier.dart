part of reports;

final MODIFIERS = <String, String>{
  'COR': 'Correction',
  'CORR': 'Correction',
  'AMD': 'Amendment',
  'NIL': 'Missing report',
  'AUTO': 'Automatic report',
  'TEST': 'Testing report',
  'FINO': 'Missing report',
};

/// Basic structure for modifier groups in reports from land stations.
class Modifier extends Group {
  late final String? _description;

  Modifier(String? code) : super(code) {
    _description = MODIFIERS[code];
  }

  @override
  String toString() {
    if (_description == null) return '';

    return _description!.toLowerCase();
  }

  /// Get the modifier description of the report.
  String? get description => _description;

  @override
  Map<String, Object?> asMap() {
    final map = super.asMap();
    map.addAll({
      'modifier': description,
    });
    return map.cast<String, String?>();
  }
}

mixin ModifierMixin on Report {
  Modifier _modifier = Modifier(null);

  void _handleModifier(String group) {
    _modifier = Modifier(group);

    _concatenateString(_modifier);
  }

  /// Get the modifier type of the report.
  Modifier get modifier => _modifier;
}
