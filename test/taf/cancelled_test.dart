import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  test('Test cancelled TAF', () {
    final code = 'TAF FKKD 271700Z 2718/2824 CNL';
    final taf = Taf(code);

    expect(taf.cancelled.code, 'CNL');
    expect(taf.cancelled.isCancelled, true);
    expect(taf.cancelled.toString(), 'cancelled');
    expect(
        taf.cancelled.asMap(),
        equals(<String, Object?>{
          'code': 'CNL',
          'is_cancelled': true,
        }));
  });

  test('Test no cancelled TAF', () {
    final code = '''
    TAF FKKD 271700Z 2718/2824 VRB03KT 9999 SCT016 FEW020CB
        PROB30 2718/2720 TS
        TEMPO 2722/2807 BKN013 FEW016CB
        TEMPO 2805/2807 2000 BR
    ''';
    final taf = Taf(code);

    expect(taf.cancelled.code, null);
    expect(taf.cancelled.isCancelled, false);
    expect(taf.cancelled.toString(), '');
    expect(
        taf.cancelled.asMap(),
        equals(<String, Object?>{
          'code': null,
          'is_cancelled': false,
        }));
  });
}
