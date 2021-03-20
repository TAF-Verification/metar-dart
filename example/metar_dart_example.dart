import 'package:metar_dart/metar_dart.dart';

void main() async {
  final metar = await Metar.current('MROC');

  print(metar.body);
  print(metar.trend);
  print(metar.remark);
  print(metar.type);
  print(metar.station.name);
  print(metar.time);
  print(metar.windDirection?.directionInDegrees);
  print(metar.windDirection?.cardinalPoint);
  print(metar.windSpeed?.inMeterPerSecond);
  print(metar.windGust?.inMilePerHour);

  print(metar.toString());
}
