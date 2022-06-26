part of models;

Map<String, String> INTENSITY = {
  '-': 'light',
  '+': 'heavy',
  '-VC': 'nearby light',
  '+VC': 'nearby heavy',
  'VC': 'nearby',
};

Map<String, String> DESCRIPTION = {
  'MI': 'shallow',
  'PR': 'partial',
  'BC': 'patches of',
  'DR': 'low drifting',
  'BL': 'blowing',
  'SH': 'showers',
  'TS': 'thunderstorm',
  'FZ': 'freezing',
};

Map<String, String> PRECIPITATION = {
  'DZ': 'drizzle',
  'RA': 'rain',
  'SN': 'snow',
  'SG': 'snow grains',
  'IC': 'ice crystals',
  'PL': 'ice pellets',
  'GR': 'hail',
  'GS': 'snow pellets',
  'UP': 'unknown precipitation',
  '//': '',
};

Map<String, String> OBSCURATION = {
  'BR': 'mist',
  'FG': 'fog',
  'FU': 'smoke',
  'VA': 'volcanic ash',
  'DU': 'dust',
  'SA': 'sand',
  'HZ': 'haze',
  'PY': 'spray',
};

Map<String, String> OTHER = {
  'PO': 'sand whirls',
  'SQ': 'squalls',
  'FC': 'funnel cloud',
  'SS': 'sandstorm',
  'DS': 'dust storm',
  'NSW': 'nil significant weather',
};

class MetarWeather extends Group {
  String? _intensity;
  String? _description;
  String? _precipitation;
  String? _obscuration;
  String? _other;

  MetarWeather(String? code, RegExpMatch? match) : super(code) {
    if (match != null) {
      _intensity = INTENSITY[match.namedGroup('int')];
      _description = DESCRIPTION[match.namedGroup('desc')];
      _precipitation = PRECIPITATION[match.namedGroup('prec')];
      _obscuration = OBSCURATION[match.namedGroup('obsc')];
      _other = OTHER[match.namedGroup('other')];
    }
  }

  @override
  String toString() {
    var s = '$_intensity'
        ' $_description'
        ' $_precipitation'
        ' $_obscuration'
        ' $_other';
    s = s.replaceAll('null', '');
    s = s.replaceAll(RegExp(r'\s{2,}'), ' ');

    return s.trim();
  }

  /// Get the intensity of the weather.
  String? get intensity => _intensity;

  /// Get the description of the weather.
  String? get description => _description;

  // Get the precipitation type of the weather.
  String? get precipitation => _precipitation;

  /// Get the obscuration type of the weather.
  String? get obscuration => _obscuration;

  /// Get the other parameter of the weather.
  String? get other => _other;

  @override
  Map<String, String?> asMap() {
    final map = super.asMap();
    map.addAll({
      'intensity': intensity,
      'description': description,
      'precipitation': precipitation,
      'obscuration': obscuration,
      'other': other,
    });
    return map.cast<String, String?>();
  }
}

mixin MetarWeatherMixin on StringAttributeMixin {
  final _weathers = GroupList<MetarWeather>(3);

  void _handleWeather(String group) {
    final match = MetarRegExp.WEATHER.firstMatch(group);
    final weather = MetarWeather(group, match);
    _weathers.add(weather);

    _concatenateString(weather);
  }

  /// Get the weather data of the report if provided.
  GroupList<MetarWeather> get weathers => _weathers;
}
