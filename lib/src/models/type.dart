import 'package:metar_dart/src/models/descriptors.dart';

final TYPES = {
  'METAR': 'Meteorological Aerodrome Report',
  'SPECI': 'Special Aerodrome Report',
  'TAF': 'Terminal Aerodrome Forecast',
};

class Type extends Group {
  Type(String code) : super(code);

  @override
  String toString() {
    if (TYPES.containsKey(code)) {
      return '${TYPES[code]}';
    }

    return '';
  }

  String? get type => TYPES[code];
}
