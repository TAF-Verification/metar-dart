import 'package:metar_dart/metar.dart';

void main() async {
  final metar = await Metar.current('MROC');
  print(metar.body);
  print(metar.trend);
  print(metar.remark);
}
