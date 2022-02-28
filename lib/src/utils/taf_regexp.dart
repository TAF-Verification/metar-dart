part of utils;

class TafRegExp {
  static final RegExp AMD_COR = RegExp(r'^(?<mod>COR|AMD)$');

  static final RegExp NIL = RegExp(r'^NIL$');

  static final RegExp VALID = RegExp(r'^(?<fmday>0[1-9]|[12][0-9]|3[01])'
      r'(?<fmhour>[0-1]\d|2[0-3])/'
      r'(?<tlday>0[1-9]|[12][0-9]|3[01])'
      r'(?<tlhour>[0-1]\d|2[0-4])$');

  static final RegExp CANCELLED = RegExp(r'^CNL$');

  static final RegExp WIND = RegExp(r'^(?<dir>[0-2][0-9]0|3[0-6]0)'
      r'P?(?<speed>\d{2,3})'
      r'(G(P)?(?<gust>\d{2,3}))?'
      r'(?<units>KT|MPS)$');

  static final RegExp VISIBILITY = RegExp(r'^(?<vis>\d{4})'
      r'(?<dir>[NSEW]([EW])?)?|'
      r'(M|P)?(?<integer>\d{1,2})?_?'
      r'(?<fraction>\d/\d)?'
      r'(?<units>SM|KM|M|U)|'
      r'(?<cavok>CAVOK)$');
}
