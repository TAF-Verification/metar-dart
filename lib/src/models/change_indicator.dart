part of models;

final CHANGE_TRANSLATIONS = <String, String>{
  'NOSIG': 'no significant changes',
  'BECMG': 'becoming',
  'TEMPO': 'temporary',
  'PROB30': 'probability 30%',
  'PROB40': 'probability 40%',
};

/// Basic structure for trend codes in the report.
class ChangeIndicator extends Group {
  late String? _translation;

  ChangeIndicator(String? code, RegExpMatch? match) : super(code) {
    if (match != null) {
      if (CHANGE_TRANSLATIONS.keys.contains(code)) {
        _translation = CHANGE_TRANSLATIONS[code];
      } else if (code!.startsWith('PROB')) {
        final codes = code.split('_');
        _translation =
            '${CHANGE_TRANSLATIONS[codes[0]]} ${CHANGE_TRANSLATIONS[codes[1]]}';
      } else {
        _translation = null;
      }
    } else {
      _translation = null;
    }
  }

  @override
  String toString() {
    if (_translation != null) {
      return _translation!;
    }

    return super.toString();
  }

  /// Get the translation of the change indicator.
  String? get translation => _translation;

  @override
  Map<String, Object?> asMap() {
    final map = super.asMap();
    map.addAll({
      'translation': _translation,
    });
    return map.cast<String, String?>();
  }
}
