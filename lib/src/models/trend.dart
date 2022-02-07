part of models;

final TREND_TRANSLATIONS = <String, String>{
  'NOSIG': 'no significant changes',
  'BECMG': 'becoming',
  'TEMPO': 'temporary',
  'PROB30': 'probability 30%',
  'PROB40': 'probability 40%',
};

/// Basic structure for trend codes in the report.
class Trend extends Group {
  @override
  String? _code;
  late final String? _translation;

  Trend(String? code, RegExpMatch? match) : super(code) {
    _code = code;
    _translation = TREND_TRANSLATIONS[match?.namedGroup('trend')];
  }

  @override
  String toString() {
    if (_translation != null) {
      return _translation!;
    }

    return super.toString();
  }

  /// Get the translation of the trend.
  String? get translation => _translation;
}
