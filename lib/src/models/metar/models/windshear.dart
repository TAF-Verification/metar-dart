part of models;

/// Basic structure for windshear runways groups in METAR.
class MetarWindshearRunway extends Group {
  late final String? _all;
  late final String? _name;

  MetarWindshearRunway(String? code, RegExpMatch? match)
      : super(code?.replaceAll('_', ' ')) {
    if (match == null) {
      _all = null;
      _name = null;
    } else {
      _all = match.namedGroup('all');
      final name = match.namedGroup('name');
      if (name == null || name.length == 2) {
        _name = name;
      } else if (name.length == 3) {
        _name = setRunwayName(name);
      } else {
        _name = null;
      }
    }
  }

  @override
  String toString() {
    if (_name != null) {
      return _name!;
    }

    if (_all != null) {
      return 'all';
    }

    return '';
  }

  /// Get if `ALL` is found in the group.
  bool get all {
    if (_all != null) {
      return true;
    }

    return false;
  }

  /// Get the name of the runway with windshear.
  String? get name => _name;

  @override
  Map<String, Object?> asMap() {
    final map = {
      'all': all,
      'name': name,
    };
    map.addAll(super.asMap());
    return map;
  }
}

/// Basic structure for windshear groups in METAR.
class MetarWindshearList extends GroupList<MetarWindshearRunway> {
  MetarWindshearList() : super(3);

  @override
  String toString() {
    if (all_runways) {
      return 'all runways';
    }

    return super.toString();
  }

  /// Get the names of the windshear runway list in METAR.
  List<String?> get names {
    if (all_runways) {
      return <String>[];
    }

    return _list.map((ws) => ws.name).toList();
  }

  /// Get if all runways have windshear.
  bool get all_runways {
    if (_list.length == 1 && _list[0].all) {
      return true;
    }

    return false;
  }
}
