import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  test('Test sections with variated weather changes', () {
    final code = '''
    TAF OEDF 182100Z 1900/2006 16007KT 5000 BR NSC
        PROB30
        TEMPO 1902/1904 2000
        BECMG 1907/1909 13018KT 8000
        TEMPO 1918/2006 5000 BLDU SCT040 BKN080
        PROB30
        TEMPO 2000/2005 VRB25KT 3000 TSRA FEW030CB
    ''';
    final taf = Taf(code);
    final sections = <String>[
      'TAF OEDF 182100Z 1900/2006 16007KT 5000 BR NSC',
      ('PROB30'
          ' TEMPO 1902/1904 2000'
          ' BECMG 1907/1909 13018KT 8000'
          ' TEMPO 1918/2006 5000 BLDU SCT040 BKN080'
          ' PROB30'
          ' TEMPO 2000/2005 VRB25KT 3000 TSRA FEW030CB'),
    ];

    expect(taf.sections, sections);
    expect(taf.body, sections[0]);
    expect(taf.weatherChanges, sections[1]);
  });

  test('Test sections with from weather change', () {
    final code = '''
    TAF OKBK 190445Z 1906/2012 15015G25KT 6000 SCT040 BKN080
        PROB30
        TEMPO 1906/1915 2000 BLDU
        FM190900 0800 DS
    ''';
    final taf = Taf(code);
    final sections = <String>[
      'TAF OKBK 190445Z 1906/2012 15015G25KT 6000 SCT040 BKN080',
      ('PROB30'
          ' TEMPO 1906/1915 2000 BLDU'
          ' FM190900 0800 DS'),
    ];

    expect(taf.sections, sections);
    expect(taf.body, sections[0]);
    expect(taf.weatherChanges, sections[1]);
  });

  test('Test sections with no weather changes', () {
    final code =
        'TAF MRPV 190500Z 1906/2006 10017G28KT CAVOK TX27/1919Z TN18/1911Z';
    final taf = Taf(code);
    final sections = <String>[
      'TAF MRPV 190500Z 1906/2006 10017G28KT CAVOK TX27/1919Z TN18/1911Z',
      '',
    ];

    expect(taf.sections, sections);
    expect(taf.body, sections[0]);
    expect(taf.weatherChanges, sections[1]);
  });
}
