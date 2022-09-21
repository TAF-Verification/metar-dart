part of reports;

Map<String, String> SKY_COVER = {
  'SKC': 'clear',
  'CLR': 'clear',
  'NSC': 'clear',
  'NCD': 'clear',
  'FEW': 'a few',
  'SCT': 'scattered',
  'BKN': 'broken',
  'OVC': 'overcast',
  '///': 'undefined',
  'VV': 'indefinite ceiling',
};

Map<String, String> CLOUD_TYPE = {
  'AC': 'altocumulus',
  'ACC': 'altocumulus castellanus',
  'ACSL': 'standing lenticulas altocumulus',
  'AS': 'altostratus',
  'CB': 'cumulonimbus',
  'CBMAM': 'cumulonimbus mammatus',
  'CCSL': 'standing lenticular cirrocumulus',
  'CC': 'cirrocumulus',
  'CI': 'cirrus',
  'CS': 'cirrostratus',
  'CU': 'cumulus',
  'NS': 'nimbostratus',
  'SC': 'stratocumulus',
  'ST': 'stratus',
  'SCSL': 'standing lenticular stratocumulus',
  'TCU': 'towering cumulus'
};

class Cloud extends Group {
  String? _cover;
  String? _type;
  String? _oktas;
  late Distance _height;

  Cloud(Map<String, String?> data) : super(data['code']) {
    _cover = data['cover'];
    _type = data['type'];
    _oktas = data['oktas'];
    _height = Distance(data['height']);
  }

  factory Cloud.fromMetar(String? code, RegExpMatch? match) {
    String? _code;
    String? _cover;
    String? _type;
    String? _oktas;
    String? _height;

    if (match != null) {
      _code = code;
      final cover = match.namedGroup('cover');

      _cover = SKY_COVER[match.namedGroup('cover')];
      _oktas = Cloud._setOktas(cover!);
      _type = CLOUD_TYPE[match.namedGroup('type')];

      var height = match.namedGroup('height');
      if (height == null || height == '///') {
        _height = '//\//';
      } else {
        height = height + '00';
        var heightAsDouble = double.parse(height);
        heightAsDouble = heightAsDouble * Conversions.FT_TO_M;
        _height = heightAsDouble.toStringAsFixed(10);
      }
    }

    return Cloud({
      'code': _code,
      'cover': _cover,
      'type': _type,
      'oktas': _oktas,
      'height': _height,
    });
  }

  @override
  String toString() {
    if (_type != null && _height.value != null) {
      return '$_cover at ${heightInFeet!.toStringAsFixed(1)} feet of $_type';
    }

    if (_height.value != null) {
      return '$_cover at ${heightInFeet!.toStringAsFixed(1)} feet';
    }

    final _undefinedCovers =
        <String>['NSC', 'NCD', '///'].map((el) => SKY_COVER[el]).toList();
    if (_undefinedCovers.contains(_cover)) {
      return '$_cover';
    }

    if (_cover == SKY_COVER['VV']) {
      if (_height.value != null) {
        return '$_cover at ${heightInFeet!.toStringAsFixed(1)} feet';
      }
      return '$_cover';
    }

    return '$_cover at undefined height';
  }

  static String _setOktas(String cover) {
    if (<String>['NSC', 'NCD'].contains(cover)) {
      return 'not specified';
    }

    if (<String>['///', 'VV'].contains(cover)) {
      return 'undefined';
    }

    switch (cover) {
      case 'FEW':
        return '1-2';
      case 'SCT':
        return '3-4';
      case 'BKN':
        return '5-7';
      case 'OVC':
        return '8';
    }

    return '';
  }

  /// Get the cover description of the cloud layer.
  String? get cover => _cover;

  /// Get the type of cloud translation of the cloud layer.
  String? get cloudType => _type;

  /// Get the oktas amount of the cloud layer.
  String? get oktas => _oktas;

  /// Get the height of the cloud base in meters.
  double? get heightInMeters => _height.inMeters;

  /// Get the height of the cloud base in kilometers.
  double? get heightInKilometers => _height.inKilometers;

  /// Get the height of the cloud base in sea miles.
  double? get heightInSeaMiles => _height.inSeaMiles;

  /// Get the height of the cloud base in feet.
  double? get heightInFeet => _height.inFeet;

  @override
  Map<String, Object?> asMap() {
    final map = {
      'cover': cover,
      'oktas': oktas,
      'height_units': 'meters',
      'height': heightInMeters,
      'type': cloudType,
    };
    map.addAll(super.asMap());
    return map;
  }
}

class CloudList extends GroupList<Cloud> {
  CloudList() : super(4);

  /// Get `true` if there is ceiling, `false` if not.
  ///
  /// If the cover of someone of the cloud layers is broken (BKN) or
  /// overcast (OVC) and its height is less or equal than 1500.0 feet,
  /// there is ceiling; there isn't otherwise.
  bool get ceiling {
    for (var group in _list) {
      final _oktas = group.oktas;
      final _height = group.heightInFeet;
      if (<String>['5-7', '8'].contains(_oktas)) {
        if (_height != null && _height <= 1500.0) {
          return true;
        }
      }
    }
    return false;
  }
}
