part of utils;

class TafRegExp {
  static final RegExp AMD_COR = RegExp(r'^(?<mod>COR|AMD)$');

  static final RegExp NIL = RegExp(r'^NIL$');

  static final RegExp VALID = RegExp(r'^(?<fmday>0[1-9]|[12][0-9]|3[01])'
      r'(?<fmhour>[0-1]\d|2[0-4])/'
      r'(?<tlday>0[1-9]|[12][0-9]|3[01])'
      r'(?<tlhour>[0-1]\d|2[0-4])$');

  static final RegExp CANCELLED = RegExp(r'^CNL$');

  static final RegExp WIND = RegExp(r'^(?<dir>([0-2][0-9]|3[0-6])0|VRB)'
      r'P?(?<speed>\d{2,3})'
      r'(G(P)?(?<gust>\d{2,3}))?'
      r'(?<units>KT|MPS)$');

  static final RegExp VISIBILITY = RegExp(r'^(?<vis>\d{4})'
      r'(?<dir>[NSEW]([EW])?)?|'
      r'(M|P)?(?<integer>\d{1,2})?_?'
      r'(?<fraction>\d/\d)?'
      r'(?<units>SM|KM|M|U)|'
      r'(?<cavok>CAVOK)$');

  static final RegExp TEMPERATURE = RegExp(r'T(?<type>N|X)'
      r'(?<sign>M)?'
      r'(?<temp>\d{2})/'
      r'(?<day>0[1-9]|[12][0-9]|3[01])'
      r'(?<hour>[0-1]\d|2[0-3])Z');

  static final RegExp CHANGE_INDICATOR = RegExp(r'^TEMPO|BECMG'
      r'|FM(?<day>0[1-9]|[12][0-9]|3[01])'
      r'(?<hour>[0-1]\d|2[0-3])'
      r'(?<minute>[0-5]\d)'
      r'|PROB[34]0(_TEMPO)?$');

  static final RegExp WINDSHEAR = RegExp(r'^WS(?<height>\d{3})/'
      r'(?<dir>([0-2][0-9]|3[0-6])0|///|VRB)'
      r'P?(?<speed>\d{2,3}|//|///)'
      r'(G(P)?(?<gust>\d{2,3}))?'
      r'(?<units>KT|MPS)$');
}
