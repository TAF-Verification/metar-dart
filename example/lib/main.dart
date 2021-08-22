/// Import the package
import 'package:metar_dart/metar_dart.dart';

void main() {
  /// Instantiate the object Metar() providin the code as an argument
  final metar = Metar(
    'TAF KLAX 210800Z 33007G17KT 9999 R07R/1500U R25C/M1000VP3000U +RA BR VCTS SCT020TCU BKN055 16/13 A3002 RESHRA RMK TS TO SW BECMG 10010KT',
    //truncate: true,
  );

  /// Get the features of the report
  /// Take care with posible null values depending of every report
  print(metar.raw_code);
  print(metar.sections);
  print('${metar.type.code} -> ${metar.type.type}');
  print(metar.station.name);
  print(metar.time.toString());
  print(metar.time);
  print(metar.wind.cardinalDirection);
  print(metar.wind.speedInMps);
  print(metar.wind.gustInKnot);
  print(metar.wind.directionInDegrees);
  print(metar.wind);
  print(metar.visibility);
  print(metar.visibility.inKilometers);
  print(metar.runwayRanges.third);
  for (var range in metar.runwayRanges.iter) {
    print(range);
  }
  print(metar.weathers);
  for (var ww in metar.weathers.iter) {
    print(ww);
  }
  print(metar.sky);
  for (var layer in metar.sky.iter) {
    print(layer);
  }
  print(metar.temperatures);
  print(metar.temperatures.temperatureInFahrenheit);
  print(metar.temperatures.dewpointInFahrenheit);
  // print(metar.temperature?.inCelsius);
  // print(metar.pressure?.inHPa);

  // You can see a resume of the METAR with the toString() method
  // print(metar.toString());

  // Transforming the METAR as a Json format
  // print(metar.toJson());
}
