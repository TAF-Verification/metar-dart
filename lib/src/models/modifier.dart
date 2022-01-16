part of models;

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
  late final String? _modifier;

  Modifier(String? code) : super(code) {
    _modifier = MODIFIERS[code];
  }

  @override
  String toString() {
    if (_modifier == null) return '';

    return _modifier!.toLowerCase();
  }

  /// Get the modifier description of the report.
  String? get modifier => _modifier;
}
