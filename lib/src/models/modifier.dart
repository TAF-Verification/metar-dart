import 'package:metar_dart/src/models/descriptors.dart';

final DESCRIPTION = {
  'COR': 'Correction',
  'CORR': 'Correction',
  'AMD': 'Amendment',
  'NIL': 'Missing report',
  'AUTO': 'Automatic report',
  'TEST': 'Testing report',
  'FINO': 'Missing report',
};

class ModifierData extends Code {
  String? _modifier;

  ModifierData(String code) : super(code) {
    _modifier = DESCRIPTION[code];
  }

  @override
  String toString() {
    return '$_modifier';
  }

  String? get modifier => _modifier;
}

class Modifier {
  ModifierData? _modifier;

  Modifier(String code) {
    _modifier = ModifierData(code);
  }

  @override
  String toString() {
    return _modifier == null ? '' : _modifier.toString();
  }

  String? get code => _modifier?.code;
  String? get modifier => _modifier?.modifier;
}
