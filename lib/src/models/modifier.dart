import 'package:metar_dart/src/models/descriptors.dart';

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
  Modifier(String? code) : super(code);

  @override
  String toString() {
    if (MODIFIERS.containsKey(code)) {
      return '${MODIFIERS[code]}';
    }

    return '';
  }

  String? get modifier => MODIFIERS[code];
}
