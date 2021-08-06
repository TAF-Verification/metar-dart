import 'package:metar_dart/src/database/countries_db.dart';
import 'package:metar_dart/src/database/stations_db.dart';
import 'package:metar_dart/src/models/descriptors.dart';

class StationData extends Code {
  List<String> _station;

  StationData(String code) : super(code) {
    for (var stn in getStation()) {
      if (code == stn[1]) {
        _station = stn;
        break;
      }
    }
  }

  @override
  String toString() {
    return '${_station.join(' | ')}';
  }

  List<String> get station => _station;
}

class Station {
  StationData _station;

  Station(String code) {
    _station = StationData(code);
  }

  @override
  String toString() {
    return 'Name: $name\n'
        'Coordinates: $latitude - $longitude\n'
        'Elevation: $elevation m MSL\n'
        'Country: $country';
  }

  String get name => _station.station[0];
  String get icao => _station.station[1];
  String get iata => _station.station[2];
  String get synop => _station.station[3];
  String get latitude => _station.station[4];
  String get longitude => _station.station[5];
  String get elevation => _station.station[6];
  String get country => getCountry(_station.station[7]);
}
