import 'package:metar_dart/src/models/descriptors.dart';

final TYPES = {
  'METAR': 'Meteorological Aerodrome Report',
  'SPECI': 'Special Aerodrome Report',
  'TAF': 'Terminal Aerodrome Forecast',
};

class TypeData extends Code {
  String _type;

  TypeData(String code) : super(code) {
    _handler(code);
  }

  void _handler(String code) {
    _type = TYPES[code];
  }

  @override
  String toString() => '$code: $type';

  String get type => _type;
}

class Type {
  TypeData _type;

  Type(String code) {
    _type = TypeData(code);
  }

  @override
  String toString() => _type.toString();

  String get code => _type.code;
  String get type => _type.type;
}
