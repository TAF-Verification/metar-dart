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
  print(metar.type_);
  print(metar.station.name);
  print(metar.time);
  print(metar.wind.directionInDegrees);
  print(metar.flightRules);

  /// You can see a resume of the METAR with the toString() method
  print(metar.toString());

  /// You can convert the METAR data as a Map with the asMap() method
  print(metar.asMap());

  /// You can convert the METAR data as a String in JSON format with
  /// the toJSON() method
  print(metar.toJSON());

  final taf = Taf('''
    MROC 261738Z 2618/2718 25005KT 9999 SCT020 SCT120 TX27/2618Z TN19/2710Z
          TEMPO 2618/2622 RA OVC070
          TEMPO 2623/2703 3000 RA BR BKN005
          BECMG 2704/2706 09002KT BCFG
          BECMG 2714/2716 26006KT
  ''');

  /// Get the features of the TAF
  /// Take care with posible null values depending of every report
  print(taf.type_);
  print(taf.station.name);
  print(taf.time);
  print(taf.wind.directionInDegrees);
  print(taf.flightRules);

  /// You can see a resume of the TAF with the toString() method
  print(taf.toString());

  /// You can convert the TAF data as a Map with the asMap() method
  print(taf.asMap());

  /// You can convert the TAF data as a String in JSON format with
  /// the toJSON() method
  print(taf.toJSON());
}
