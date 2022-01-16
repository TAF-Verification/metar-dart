part of utils;

// Regular expressions to decode various groups of the METAR code
class MetarRegExp {
  static final RegExp TYPE = RegExp(r'^(?<type>METAR|SPECI|TAF)$');

  static final RegExp STATION = RegExp(r'^(?<station>[A-Z][A-Z0-9]{3})$');

  static final RegExp TIME =
      RegExp(r'^(?<day>\d{2})' r'(?<hour>\d{2})' r'(?<min>\d{2})Z$');

  static final RegExp MODIFIER =
      RegExp(r'^(?<mod>COR(R)?|AMD|NIL|TEST|FINO|AUTO)$');

  static final RegExp TREND =
      RegExp(r'^(?<trend>TEMPO|BECMG|NOSIG|FM\d{6}|PROB\d{2})$');

  static final RegExp REMARK = RegExp(r'^(?<rmk>RMK(S)?)$');
}
