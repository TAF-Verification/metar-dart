part of models;

class Station extends Group {
  List<String?> _station = List.generate(8, (index) => null);

  Station(String? code) : super(code) {
    if (code != null) {
      for (var stn in getStation()) {
        if (stn[1] == code || stn[2] == code || stn[3] == code) {
          _station = stn;
          break;
        }
      }
    }
  }

  @override
  String toString() {
    return 'Name: $name | '
        'Coordinates: $latitude - $longitude | '
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

  /// Get the elevation of the station in meters over sea level.
  String? get elevation => _station[6];

  /// Get the country where station is.
  String? get country => getCountry(_station[7]);
}
