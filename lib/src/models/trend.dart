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
  late final String? _translation;

  Trend(String? code, RegExpMatch? match) : super(code) {
    if (match != null) {
      _translation = TREND_TRANSLATIONS[match.namedGroup('trend')];
    }
  }

  /// Get the translation of the trend.
  String? get translation => _translation;
}
