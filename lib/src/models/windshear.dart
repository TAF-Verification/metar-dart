import 'package:metar_dart/src/models/descriptors.dart';
import 'package:metar_dart/src/models/visibility.dart' show RunwayName;

class Runway extends Group {
  RunwayName _name = RunwayName(null);

  Runway(String? code, RegExpMatch? match) : super(code) {
    if (match != null) {
      _name = RunwayName(match.namedGroup('name'));
    }
  }

  @override
  String toString() {
    final s = _name.name ?? 'null';
    return s;
  }

  String? get name => _name.name;
}

class Windshear {
  Runway _first = Runway(null, null);
  Runway _second = Runway(null, null);
  Runway _third = Runway(null, null);
  bool _all = false;
  final List<Runway> _windshearList = <Runway>[];
  int _count = 0;

  Windshear();

  void add(String code, RegExpMatch match) {
    if (_count >= 3) {
      throw RangeError("can't set more than three windshear codes");
    }

    final runway = Runway(code, match);

    if (_count == 0) {
      _first = runway;
      if (match.namedGroup('all') != null) {
        _all = true;
      }
    } else if (_count == 1) {
      _second = runway;
    } else {
      _third = runway;
    }

    _windshearList.add(runway);
    _count++;
  }

  @override
  String toString() {
    return _windshearList.join(' | ');
  }

  int get length => _windshearList.length;
  List<String> get codes {
    final list = _windshearList.map((e) => e.code.toString()).toList();

    return list;
  }

  Iterable<Runway> get iter => _windshearList.map((e) => e);
  List<Runway> get toList => _windshearList;
  Runway get first => _first;
  Runway get second => _second;
  Runway get third => _third;
  bool get allRunways => _all;
}
