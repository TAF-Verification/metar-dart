part of models;

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

class CloudLayer extends Group {
  String? _cover;
  String? _type;
  Distance _height = Distance(null);
  String _oktas = "0";

  CloudLayer(String? code, RegExpMatch? match) : super(code) {
    if (match != null) {
      final cover = match.namedGroup('cover');

      _setOktas(cover!);

      _cover = SKY_COVER[match.namedGroup('cover')];
      _type = CLOUD_TYPE[match.namedGroup('type')];

      _setHeight(match.namedGroup('height')!);
    }
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

  void _setOktas(String cover) {
    if (<String>['NSC', 'NCD'].contains(cover)) {
      _oktas = 'not specified';
      return;
    }

    if (<String>['///', 'VV'].contains(cover)) {
      _oktas = 'undefined';
      return;
    }

    switch (cover) {
      case 'FEW':
        _oktas = '1-2';
        break;
      case 'SCT':
        _oktas = '3-4';
        break;
      case 'BKN':
        _oktas = '5-7';
        break;
      case 'OVC':
        _oktas = '8';
        break;
    }
  }

  void _setHeight(String height) {
    if (height == '///') {
      _height = Distance(null);
    } else {
      var _h = double.parse(height + '00');
      _h = _h * Conversions.FT_TO_M;
      _height = Distance('$_h');
    }
  }

  /// Get the cover description of the cloud layer.
  String? get cover => _cover;

  /// Get the cloud type of the layer.
  String? get cloudType => _type;

  /// Get the oktas amount of the cloud layer.
  String get oktas => _oktas;

  /// Get the height of the cloud base in meters.
  double? get heightInMeters => _height.value;

  /// Get the height of the cloud base in kilometers.
  double? get heightInKilometers =>
      _height.converted(conversionDouble: Conversions.M_TO_KM);

  /// Get the height of the cloud base in sea miles.
  double? get heightInSeaMiles =>
      _height.converted(conversionDouble: Conversions.M_TO_SMI);

  /// Get the height of the cloud base in feet.
  double? get heightInFeet =>
      _height.converted(conversionDouble: Conversions.M_TO_FT);
}

class CloudList extends GroupList<CloudLayer> {
  CloudList() : super(4);

  /// Get `true` if there is ceiling, `false` if not.
  ///
  /// If the cover of someone of the cloud layers is broken and its height
  /// is less or equal than 1500.0 feet, there is ceiling; there isn't
  /// otherwise.
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
