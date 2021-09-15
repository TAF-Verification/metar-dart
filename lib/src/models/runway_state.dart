import 'package:metar_dart/src/models/descriptors.dart';
import 'package:metar_dart/src/models/visibility.dart' show RunwayName;
import 'package:metar_dart/src/models/weather.dart' show Item;
import 'package:metar_dart/src/utils/utils.dart' show SkyTranslations;

class Deposits extends Item {
  Deposits(String? code) : super(SkyTranslations.RUNWAY_DEPOSITS[code]);
}

class Contamination extends Item {
  Contamination(String? code)
      : super(SkyTranslations.RUNWAY_CONTAMINATION[code]);
}

String? _handleDepositsDepth(String? code) {
  if (code != null) {
    final depth = int.tryParse(code);
    if (depth != null) {
      if (depth > 0 && depth <= 90) {
        return '$depth mm';
      }
    }
  }

  if (SkyTranslations.DEPOSIT_DEPTH.containsKey(code)) {
    return SkyTranslations.DEPOSIT_DEPTH[code];
  }

  return code;
}

class DepositsDepth extends Item {
  DepositsDepth(String? code) : super(_handleDepositsDepth(code));
}

String? _handleSurfaceFriction(String? code) {
  if (code != null) {
    final coef = int.tryParse(code);
    if (coef != null) {
      if (coef > -1 && coef <= 90) {
        return '0.${coef.toString().padLeft(2, "0")}';
      }
    }
  }

  if (SkyTranslations.SURFACE_FRICTION.containsKey(code)) {
    return SkyTranslations.SURFACE_FRICTION[code];
  }

  return code;
}

class SurfaceFriction extends Item {
  SurfaceFriction(String? code) : super(_handleSurfaceFriction(code));
}

String? _handleSNOCLO(String? code) {
  if (code == null) {
    return null;
  }

  return 'aerodrome is closed due to extreme deposit of snow';
}

class Snoclo extends Item {
  Snoclo(String? code) : super(_handleSNOCLO(code));
}

String? _handleCLRD(String? code) {
  if (code == null) {
    return null;
  }

  return 'contaminations have ceased to exist';
}

class Clrd extends Item {
  Clrd(String? code) : super(_handleCLRD(code));
}

class RunwayState extends Group {
  RunwayName _name = RunwayName(null);
  Deposits _deposits = Deposits(null);
  Contamination _contamination = Contamination(null);
  DepositsDepth _depositsDepth = DepositsDepth(null);
  SurfaceFriction _surfaceFriction = SurfaceFriction(null);
  Snoclo _snoclo = Snoclo(null);
  Clrd _clrd = Clrd(null);
  RegExpMatch? _match;

  RunwayState(String? code, RegExpMatch? match) : super(code) {
    _match = match;

    if (match != null) {
      _name = RunwayName(match.namedGroup('name'));
      _deposits = Deposits(match.namedGroup('deposits'));
      _contamination = Contamination(match.namedGroup('contamination'));
      _depositsDepth = DepositsDepth(match.namedGroup('depth'));
      _surfaceFriction = SurfaceFriction(match.namedGroup('friction'));
      _snoclo = Snoclo(match.namedGroup('snoclo'));
      _clrd = Clrd(match.namedGroup('clrd'));
    }
  }

  String _depositsToString() {
    final depositType = _match!.namedGroup('deposits');
    final depth = _match!.namedGroup('depth');
    String sep;

    if (depositType == '/') {
      if (depth == '99' || depth == '//') {
        sep = '$depositsDepth and $deposits';
      } else if (depth != null) {
        sep = 'depth of $depositsDepth but $deposits';
      } else {
        sep = '$deposits';
      }
    } else if (deposits != null) {
      if (depth == '99' || depth == '//') {
        sep = '$depositsDepth of $deposits';
      } else if (depth != null) {
        sep = 'deposits of $depositsDepth of $deposits';
      } else {
        sep = 'deposits of $deposits';
      }
    } else {
      if (depth == '99' || depth == '//') {
        sep = '$depositsDepth';
      } else if (depth != null) {
        sep = 'deposits depth of $depositsDepth';
      } else {
        sep = '';
      }
    }

    return sep;
  }

  String _surfaceFrictionToString() {
    final friction = _match!.namedGroup('friction');

    if (friction != null && friction != '//') {
      final frictionAsInteger = int.parse(friction);

      if (frictionAsInteger < 91) {
        return 'estimated surface friction $surfaceFriction';
      } else {
        return '$surfaceFriction';
      }
    } else {
      return '';
    }
  }

  @override
  String toString() {
    if (_match == null) {
      return 'null';
    }

    if (snoclo != null) {
      return '$snoclo';
    }

    if (clrd != null) {
      return '$clrd';
    }

    return '$name'
        '${_depositsToString()}'
        'contamination $contamination'
        '${_surfaceFrictionToString()}';
  }

  String? get name => _name.name;
  String? get deposits => _deposits.value;
  String? get contamination => _contamination.value;
  String? get depositsDepth => _depositsDepth.value;
  String? get surfaceFriction => _surfaceFriction.value;
  String? get snoclo => _snoclo.value;
  String? get clrd {
    if (_clrd.value == null) {
      return null;
    }

    if (name == 'repeated') {
      return _clrd.value! + ' on previous runway';
    }

    if (name == 'all runways') {
      return _clrd.value! + ' on $name';
    }

    return _clrd.value! + ' on runway $name';
  }
}
