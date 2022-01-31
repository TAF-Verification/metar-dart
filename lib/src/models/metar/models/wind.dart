part of models;

class MetarWind extends Wind with GroupMixin {
  MetarWind(String? code, RegExpMatch? match)
      : super(
          direction: null,
          speed: null,
          gust: null,
        ) {
    if (match == null) {
      _code = null;
    } else {
      final _dir = match.namedGroup('dir');
      var _spd = match.namedGroup('speed');
      var _gst = match.namedGroup('gust');
      final _unt = match.namedGroup('units');

      _spd ??= '///';
      _gst ??= '///';

      if (_unt == 'MPS') {
        _spd = _mps2kt(_spd);
        _gst = _mps2kt(_gst);
      }

      _direction = Direction(_dir);
      _speed = Speed(_spd);
      _gust = Speed(_gst);
      _code = code;
    }
  }
}
