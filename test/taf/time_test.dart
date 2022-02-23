import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  final code = '''
  TAF GCTS 232000Z 2321/2421 33005KT 9999 FEW030 TX22/2414Z TN14/2406Z
      TEMPO 2321/2324 03010KT
      BECMG 2411/2413 20010KT
      BECMG 2416/2417 10007KT
  ''';
  final taf = Taf(code, year: 2022, month: 1);
  final time = taf.time;

  test('Test the date of TAF', () {
    expect(time.code, '232000Z');
    expect(time.year, 2022);
    expect(time.month, 1);
    expect(time.day, 23);
    expect(time.hour, 20);
    expect(time.minute, 0);
    expect(time.toString(), '2022-01-23 20:00:00');
  });
}
