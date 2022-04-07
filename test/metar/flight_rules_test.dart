import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  test('Test VFR flight rules', () {
    final codes = <String>[
      'METAR MROC 202000Z 25011KT 210V290 9999 FEW025TCU SCT040 BKN250 29/20 A2992 NOSIG',
      'METAR DXNG 010000Z 22004KT CAVOK 26/22 Q1010',
      'METAR MNMG 151700Z 11014KT 9999 FEW025 SCT300 33/19 Q1010 A2984 NOSIG',
      'METAR MPTO 272200Z 14009KT 9000 SCT018 31/22 Q1005 NOSIG RMK HZY',
      'SPECI MSSS 101450Z 04003KT 9999 FEW030 27/18 Q1015 A2998',
    ];

    for (final code in codes) {
      final metar = Metar(code);
      expect(metar.flightRules, 'VFR');
    }
  });

  test('Test MVFR flight rules', () {
    final codes = <String>[
      'METAR UUDD 200900Z 16005MPS 9999 BKN025 01/M06 Q1010 R14R/CLRD60 R14C/190050 NOSIG',
      'METAR MGGT 260900Z 21008KT 9000 BKN014 17/15 Q1017 A3003',
      'SPECI MMMX 151942Z 10015KT 4SM SCT250 29/M06 A3009 NOSIG RMK 8/001 HZY BLDU',
      'SPECI KJFK 010751Z 29010KT 5SM RA BR FEW002 BKN018 OVC075 13/13 A2947 RMK AO2 RAB25 SLP978 P0006 T01330128',
      'METAR SKBO 050800Z 03003KT 9999 BKN010 09/09 Q1025 NOSIG RMK A3028',
    ];

    for (final code in codes) {
      final metar = Metar(code);
      expect(metar.flightRules, 'MVFR');
    }
  });

  test('Test IFR flight rules', () {
    final codes = <String>[
      'METAR KBOS 011254Z 30022G35KT 1 1/2SM +RA SCT011 OVC019 12/09 A2947 RMK AO2 PK WND 30035/1251 TWR VIS 3 RAB31 SLP980 T01220094 PNO',
      'METAR MROC 162100Z 25012KT 3000 TSRA BKN008CB SCT040 26/20 A2990 NOSIG',
      'METAR MHTG 011700Z 36006KT 4000 HZ NSC 28/16 Q1020 A3012 NOSIG',
      'METAR KCLE 111502Z 28016KT 2 1/2SM -SN BKN006 BKN028 OVC042 02/M02 A2983 RMK AO2 P0000 T00171022',
      'METAR MSSS 222150Z 17012KT 2000 BR VV007 28/22 Q1011 A2988',
    ];

    for (final code in codes) {
      final metar = Metar(code);
      expect(metar.flightRules, 'IFR');
    }
  });

  test('Test LIFR flight rules', () {
    final codes = <String>[
      'METAR GOOK 211800Z 36004KT 1000 BR VV/// 40/12 Q1006',
      'METAR SAVC 032200Z 29015KT 0800 FG NSC 24/M02 Q1006 RMK PP000',
      'METAR CYQM 122240Z 33007KT 1 1/4SM +RA BR BKN003 OVC015 04/03 A2925 RMK SF7SC1 PRESRR SLP909',
      'METAR CZSM 011800Z AUTO 33007KT 3/4SM HZ SCT030 BKN100 M15/M22 RMK AO1 SOG 57 8002 SLP208 T11471219',
      'METAR SPJC 202100Z 18011KT 1500 TSRA SCT010CB BKN035 21/15 Q1011 NOSIG RMK PP000',
    ];

    for (final code in codes) {
      final metar = Metar(code);
      expect(metar.flightRules, 'LIFR');
    }
  });

  test('Test VLIFR flight rules', () {
    final codes = <String>[
      'METAR KJFK 250451Z 17010KT 1/8SM R04R/4000VP6000FT -RA BR BKN002 OVC025 11/11 A2949 RMK AO2 PK WND 18027/0408 SFC VIS 2 1/2 SLP986 P0000 T01110111 401390067',
      'METAR MMPR 011844Z 26008KT 1/4SM SN SCT050 BKN100 24/16 A2994 RMK 8/501',
      'METAR MRLM 152100Z 06008KT 1500 TSRA OVC001CB 21/21 A2978',
      'METAR TUPJ 032200Z 10013KT 2SM BR VV001 22/21 A3002 RMK Q1017 VIS16KM',
      'METAR SKCG 012200Z 29006KT 260V330 0500 FG OVC003 28/24 Q1008 RMK A2979',
    ];

    for (final code in codes) {
      final metar = Metar(code);
      expect(metar.flightRules, 'VLIFR');
    }
  });

  test('Test no data to set flight rules', () {
    final codes = <String>[
      'METAR MRLM 152100Z 06008KT //\// TSRA OVC///CB 21/21 A2978',
      'METAR TUPJ 032200Z AUTO 10013KT //\// BR VV/// 22/21 A3002 RMK Q1017 VIS16KM',
    ];

    for (final code in codes) {
      final metar = Metar(code);
      expect(metar.flightRules, null);
    }
  });

  test('Test trend flight rules NOSIG', () {
    final code =
        'SPECI MROC 062121Z VRB02KT 9999 3000SW -RA VCTS FEW020CB SCT035 BKN100 19/19 A2996 RETS NOSIG';
    final metar = Metar(code);

    expect(metar.weatherTrends[0].flightRules, null);
  });
}
