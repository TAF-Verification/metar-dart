part of models;

final MODIFIERS = {
  'COR': 'Correction',
  'CORR': 'Correction',
  'AMD': 'Amendment',
  'NIL': 'Missing report',
  'AUTO': 'Automatic report',
  'TEST': 'Testing report',
  'FINO': 'Missing report',
};

class Modifier extends Group {
  late final String? _modifier;

  Modifier(String? code) : super(code) {
    _modifier = MODIFIERS[code];
  }

  @override
  String toString() {
    if (_modifier != null) {
      return _modifier!.toLowerCase();
    }

    return '';
  }

  /// Get the modifier description of the report.
  String? get modifier => _modifier;
}
