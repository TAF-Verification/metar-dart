part of models;

final CODE_TYPES = <String, int>{
  'ICAO': 1,
  'IATA': 2,
  'SYNOP': 3,
};

/// Basic structure for station code groups in reports from land stations.
///
/// Args:
///     code (str): the land station code from the report (MROC, SJO, 78762).
///     type (str): the type of land station code (ICAO, IATA, SYNOP).
class Station extends Group {
  late List<String?> _station;

  Station(String? code, String? type) : super(code) {
    if (code != null) {
      _station = _getData(code, CODE_TYPES[type]!);
    } else {
      _station = List.generate(8, (index) => null);
    }
  }

  List<String?> _getData(String code, int index) {
    for (var stn in getStation()) {
      if (code == stn[index]) {
        return stn;
      }
    }

    return List.generate(8, (index) => null);
  }

  @override
  String toString() {
    return 'Name: $name | '
        'Coordinates: $latitude $longitude | '
        'Elevation: $elevation m MSL | '
        'Country: $country';
  }

  /// Get the name of the station.
  String? get name => _station[0];

  /// Get the ICAO code of the station.
  String? get icao => _station[1];

  /// Get the IATA code of the station.
  String? get iata => _station[2];

  /// Get the SYNOP code of the station.
  String? get synop => _station[3];

  /// Get the latitude of the station.
  String? get latitude => _station[4];

  /// Get the longitude of the station.
  String? get longitude => _station[5];

  /// Get the elevation of the station.
  String? get elevation => _station[6];

  /// Get the country of the station.
  String? get country => getCountry(_station[7]);

  @override
  Map<String, String?> toMap() {
    final map = super.toMap();
    map.addAll({
      'name': name,
      'icao': icao,
      'iata': iata,
      'synop': synop,
      'latitude': latitude,
      'longitude': longitude,
      'elevation': elevation,
      'country': country,
    });
    return map.cast<String, String?>();
  }
}
