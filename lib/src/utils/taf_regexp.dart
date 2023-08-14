part of utils;

class TafRegExp {
  static final RegExp AMD_COR = RegExp(r'^(?<mod>COR|AMD)$');

  static final RegExp NIL = RegExp(r'^NIL$');

  static final RegExp VALID = RegExp(r'^(?<fmday>0[1-9]|[12][0-9]|3[01])'
      r'(?<fmhour>[0-1]\d|2[0-4])/'
      r'(?<tlday>0[1-9]|[12][0-9]|3[01])'
      r'(?<tlhour>[0-1]\d|2[0-4])$');

  static final RegExp CANCELLED = RegExp(r'^CNL$');

  static final RegExp WIND = RegExp(r'^(WND_)?(?<dir>([0-2][0-9]|3[0-6])0|VRB)'
      r'P?(?<speed>\d{2,3})'
      r'(G(P)?(?<gust>\d{2,3}))?'
      r'(?<units>KT|MPS)$');

  static final RegExp VISIBILITY = RegExp(r'^(?<vis>\d{4})'
      r'(?<dir>[NSEW]([EW])?)?|'
      r'(M|P)?(?<integer>\d{1,2})?_?'
      r'(?<fraction>\d/\d)?'
      r'(?<units>SM|KM|M|U)|'
      r'(?<cavok>CAVOK)$');

  static final RegExp TEMPERATURE = RegExp(r'T(?<type>N|X)?'
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

  static final RegExp TURBULENCE =
      RegExp(r'^(5(?<turbType>[0-9])(?<base>\d\d\d)(?<thickness>\d))');
  static final RegExp ICING =
      RegExp(r'^(6(?<icingType>[0-9])(?<base>\d\d\d)(?<thickness>\d))');

  static final RegExp AMENDMENTS = RegExp(
      r'(LAST_NO_AMDS_AFT_(?<afterd>\d{2})(?<afterh>\d{2})_NEXT_(?<nextd>\d{2})(?<nexth>\d{2}))|AFT_(?<afterd2>\d{2})(?<afterh2>\d{2})|AMD_NOT_SKED');

  static final RegExp CORRECTION =
      RegExp(r'^(?<mod>COR|AMD)_(?<h>\d{2})(?<m>\d{2})( |$)');
  static final RegExp CORRECTION_UNSANITIZED =
      RegExp(r'(?<mod>COR|AMD) (?<h>\d{2})(?<m>\d{2})( |$)');

  static final RegExp AUTOMATED_SENSOR_METWATCH = RegExp(
      r'^AUTOMATED_SENSOR_METWATCH_(?<df>\d{2})(?<hf>\d{2})_TIL_(?<dt>\d{2})(?<ht>\d{2})');

  static final RegExp AUTOMATED_SENSOR_METWATCH_UNSANITIZED =
      RegExp(r' AUTOMATED SENSOR METWATCH (?<f>\d{4}) TIL (?<t>\d{4})');
}
