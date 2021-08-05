/// Import the package
import 'package:metar_dart/metar_dart.dart';

void main() {
  /// Instantiate the object Metar() providin the code as an argument
  final metar = Metar(
    'TAF KMIA 210800Z 33007G17KT 5000 +RA VCTS SCT020TCU BKN055 16/13 A3002 RESHRA RMK TS TO SW BECMG 10010KT',
    //truncate: true,
  );

  /// Get the features of the report
  /// Take care with posible null values depending of every report
  print(metar.raw_code);
  print(metar.sections);
  print('${metar.type.code} -> ${metar.type.type}');
  // print(metar.station.name);
  // print(metar.time);
  // print(metar.windDirection?.directionInDegrees);
  // print(metar.windDirection?.cardinalPoint);
  // print(metar.windSpeed?.inMeterPerSecond);
  // print(metar.windGust?.inMilePerHour);
  // print(metar.temperature?.inCelsius);
  // print(metar.pressure?.inHPa);

  // You can see a resume of the METAR with the toString() method
  // print(metar.toString());

  // Transforming the METAR as a Json format
  // print(metar.toJson());
}
