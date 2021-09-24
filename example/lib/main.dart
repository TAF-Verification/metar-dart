/// Import the package
import 'package:metar_dart/metar_dart.dart';

void main() {
  /// Instantiate the object Metar() providin the code as an argument
  final metar = Metar(
    'METAR KLAX 210800Z 33007G17KT 9999 R07R/1500U R25C/M1000VP3000U +RA BR VCTS SCT020TCU BKN055 16/13 A3002 RESHRA RMK TS TO SW BECMG 10010KT',
  );

  /// Get the features of the report
  /// Take care with posible null values depending of every report
  print('Code: ${metar.raw_code}');
  print('Sections: ${metar.sections}');
  print('${metar.type.code} -> ${metar.type.type}');
  print('Station name: ${metar.station.name}');
  print('Time: ${metar.time}');
  print('Wind: ${metar.wind}');
  print('Visibility: ${metar.visibility}');
  print('Runway ranges: ${metar.runwayRanges}');
  print('Weather: ${metar.weathers}');
  print('Sky conditions: ${metar.sky}');
  print('Temperatures: ${metar.temperatures}');
  print('Recent weather: ${metar.recentWeather}');

  // You can see a resume of the METAR with the toString() method
  // print(metar.toString());

  // Transforming the METAR as a Json format
  // print(metar.toJson());
}
