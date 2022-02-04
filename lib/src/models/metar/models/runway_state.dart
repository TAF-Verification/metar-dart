part of models;

/// Table 0919
final RUNWAY_DEPOSITS = <String, String>{
  '0': 'clear and dry',
  '1': 'damp',
  '2': 'wet and water patches',
  '3': 'rime and frost covered (depth normally less than 1 mm)',
  '4': 'dry snow',
  '5': 'wet snow',
  '6': 'slush',
  '7': 'ice',
  '8': 'compacted or rolled snow',
  '9': 'frozen ruts or ridges',
  '/':
      'type of deposit not reported (e.g. due to runway clearance in progress),'
};

/// Table 0519
final RUNWAY_CONTAMINATION = <String, String>{
  '1': 'less than 10% of runway',
  '2': '11%-25% of runway',
  '3': 'reserved',
  '4': 'reserved',
  '5': '26%-50% of runway',
  '6': 'reserved',
  '7': 'reserved',
  '8': 'reserved',
  '9': '51%-100% of runway',
  '/': 'not reported',
};

/// Table 1079
final DEPOSIT_DEPTH = <String, String>{
  '00': 'less than 1 mm',
  '91': 'reserved',
  '92': '10 cm',
  '93': '15 cm',
  '94': '20 cm',
  '95': '25 cm',
  '96': '30 cm',
  '97': '35 cm',
  '98': '40 cm or more',
  '99':
      'runway(s) non-operational due to snow, slush, ice, large drifts or runway clearance, but depth not reported',
  '//': 'depth of deposit operationally not significant or not measurable',
};

/// Table 0366
final SURFACE_FRICTION = <String, String>{
  '91': 'breaking action poor',
  '92': 'breaking action medium/poor',
  '93': 'breaking action medium',
  '94': 'breaking action medium/good',
  '95': 'breaking action good',
  '96': 'reserved',
  '97': 'reserved',
  '98': 'reserved',
  '99': 'unreliable',
  '//': 'breaking conditions not reported and/or runway not operational',
};

/// Basic structure for runway state groups in METAR.
class MetarRunwayState extends Group {
  bool _snoclo = false;
  bool _clrd = false;
  late final RegExpMatch? _match;
  late final String? _name;
  late final String? _deposits;
  late final String? _contamination;
  late final String? _depositsDepth;
  late final String? _surfaceFriction;

  MetarRunwayState(String? code, RegExpMatch? match) : super(code) {
    _match = match;

    if (match == null) {
      _name = null;
      _deposits = null;
      _contamination = null;
      _depositsDepth = null;
      _surfaceFriction = null;
    } else {
      _name = setRunwayName(match.namedGroup('name'));
      _deposits = RUNWAY_DEPOSITS[match.namedGroup('deposit')];
      _contamination = RUNWAY_CONTAMINATION[match.namedGroup('cont')];
      _depositsDepth = _setDepositsDepth(match.namedGroup('depth'));
      _surfaceFriction = _setSurfaceFriction(match.namedGroup('fric'));
      _snoclo = match.namedGroup('snoclo') != null;
      _clrd = match.namedGroup('clrd') != null;
    }
  }

  String? _setDepositsDepth(String? code) {
    if (code == null) {
      return null;
    }

    final depth = int.tryParse(code);
    if (depth != null) {
      if (depth > 0 && depth <= 90) {
        return '$depth mm';
      }
    }

    return DEPOSIT_DEPTH[code];
  }

  String? _setSurfaceFriction(String? code) {
    if (code == null) {
      return null;
    }

    final coef = int.tryParse(code);
    if (coef != null) {
      if (coef > -1 && coef <= 90) {
        return '0.' + '$coef'.padLeft(2, '0');
      }
    }

    return SURFACE_FRICTION[code];
  }

  String _depositsToString() {
    final deposits = _match?.namedGroup('deposit');
    final depth = _match?.namedGroup('depth');
    late final String s;

    if (deposits == '/') {
      if (depth == '99' || depth == '//') {
        s = '$_depositsDepth and $_deposits';
      } else if (depth != null) {
        s = 'deposit of $_depositsDepth but $_deposits';
      } else {
        s = '$_deposits';
      }
    } else if (deposits != null) {
      if (depth == '99' || depth == '//') {
        s = '$_depositsDepth of $_deposits';
      } else if (depth != null) {
        s = 'deposits of $_depositsDepth of $_deposits';
      } else {
        s = 'deposits of $_deposits';
      }
    } else {
      if (depth == '99' || depth == '//') {
        s = '$_depositsDepth';
      } else if (depth != null) {
        s = 'deposits depth of $_depositsDepth';
      } else {
        s = '';
      }
    }

    return s;
  }

  String _surfaceFrictionToString() {
    final friction = _match?.namedGroup('fric');
    late final String s;

    if (friction != null) {
      final frictionAsInt = int.tryParse(friction);

      if (frictionAsInt != null) {
        if (frictionAsInt < 91) {
          s = 'estimated surface friction $_surfaceFriction';
        } else {
          s = '$_surfaceFriction';
        }
      } else {
        s = '$_surfaceFriction';
      }
    } else {
      s = '';
    }

    return s;
  }

  @override
  String toString() {
    if (_match == null) {
      return '';
    }

    if (_snoclo) return 'aerodrome is closed due to extreme deposit of snow';

    if (_clrd) return '$clrd';

    return '$_name, '
        '${_depositsToString()}, '
        'contamination $_contamination, '
        '${_surfaceFrictionToString()}';
  }

  /// Get the name of the runway.
  String? get name => _name;

  /// Get the deposits type of the runway.
  String? get deposits => _deposits;

  /// Get the contamination quantity of the deposits.
  String? get contamination => _contamination;

  /// Get the deposits depth.
  String? get depositsDepth => _depositsDepth;

  /// Get the surface friction index of the runway.
  String? get surfaceFriction => _surfaceFriction;

  /// true: aerodrome is closed due to extreme deposit of snow.
  /// false: aerodrome is open.
  bool get snoclo => _snoclo;

  /// Get if contamination have ceased to exists in some runway as string.
  String? get clrd {
    final clrdText = 'contaminations have ceased to exists';

    if (!_clrd) {
      return null;
    }

    if (_name == 'repeated') {
      return clrdText + ' on previous runway';
    }

    if (_name == 'all runways') {
      return clrdText + ' on $_name';
    }

    return clrdText + ' on runway $_name';
  }
}
