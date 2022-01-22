/// Import the package
import 'package:metar_dart/metar_dart.dart';

void main() {
  /// Get the data from somewhere
  final code =
      'METAR KMIA 210800Z 33007G17KT 5000 +RA VCTS SCT020TCU BKN055 16/13 A3002 RESHRA NOSIG';

  /// Instantiate the object Metar() providing the code as an argument
  final metar = Metar(code);

  /// Get the features of the report
  /// Take care with posible null values depending of every report
  print(metar.type);
  print(metar.station.name);
  print(metar.time);
  print(metar.wind.directionInDegrees);

  /// You can see a resume of the METAR with the toString() method
  print(metar.toString());

  /// Transforming the METAR as a Json format
  // print(metar.toJson());
}
