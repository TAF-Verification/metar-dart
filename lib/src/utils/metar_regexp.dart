part of utils;

// Regular expressions to decode various groups of the METAR code
class MetarRegExp {
  static final RegExp TYPE = RegExp(r'^(?<type>METAR|SPECI|TAF)$');

  static final RegExp STATION = RegExp(r'^(?<station>[A-Z][A-Z0-9]{3})$');

  static final RegExp TIME =
      RegExp(r'^(?<day>\d{2})' r'(?<hour>\d{2})' r'(?<min>\d{2})Z$');

  static final RegExp MODIFIER =
      RegExp(r'^(?<mod>COR(R)?|AMD|NIL|TEST|FINO|AUTO)$');

  static final RegExp WIND = RegExp(r'^(?<dir>[0-3]\d{2}|///|VRB)'
      r'P?(?<speed>\d{2,3}|//)'
      r'(G(P)?(?<gust>\d{2,3}))?'
      r'(?<units>KT|MPS)$');

  static final RegExp WIND_VARIATION = RegExp(r'^(?<from>\d{3})'
      r'V(?<to>\d{3})$');

  static final RegExp VISIBILITY = RegExp(r'^(?<vis>\d{4}|//\//)'
      r'(?<dir>[NSEW]([EW])?)?|'
      r'(?<integer>\d{1,2})?_?(M|P)?'
      r'(?<fraction>\d/\d)?'
      r'(?<units>SM|KM|M|U)|'
      r'(?<cavok>CAVOK)$');

  static final RegExp RUNWAY_RANGE = RegExp(r'^R(?<name>\d{2}[RLC]?)/'
      r'(?<rvrlow>[MP])?'
      r'(?<low>\d{2,4})'
      r'(V(?<rvrhigh>[MP])?'
      r'(?<high>\d{2,4}))?'
      r'(?<units>FT)?'
      r'(?<trend>[NDU])?$');

  static final RegExp TREND =
      RegExp(r'^(?<trend>TEMPO|BECMG|NOSIG|FM\d{6}|PROB\d{2})$');

  static final RegExp REMARK = RegExp(r'^(?<rmk>RMK(S)?)$');
}
