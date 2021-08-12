import 'package:metar_dart/src/database/countries_db.dart';
import 'package:metar_dart/src/database/stations_db.dart';
import 'package:metar_dart/src/models/descriptors.dart';

class Station extends Group {
  List<String> _station = <String>[];

  Station(String? code) : super(code) {
    for (var stn in getStation()) {
      if (code == stn[1]) {
        _station = stn;
        break;
      }
    }
  }

  @override
  String toString() {
    return 'Name: $name\n'
        'Coordinates: $latitude - $longitude\n'
        'Elevation: $elevation m MSL\n'
        'Country: $country';
  }

  String? operator [](int index) {
    if (index >= 0 && index < 8) {
      return _station[index];
    }

    return null;
  }

  List<String> get stationData => _station;
  String? get name => _station.isEmpty ? null : _station[0];
  String? get icao => _station.isEmpty ? null : _station[1];
  String? get iata => _station.isEmpty ? null : _station[2];
  String? get synop => _station.isEmpty ? null : _station[3];
  String? get latitude => _station.isEmpty ? null : _station[4];
  String? get longitude => _station.isEmpty ? null : _station[5];
  String? get elevation => _station.isEmpty ? null : _station[6];
  String? get country => _station.isEmpty ? null : getCountry(_station[7]);
}
