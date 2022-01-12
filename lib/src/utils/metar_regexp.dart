part of utils;

// Regular expressions to decode various groups of the METAR code
class MetarRegExp {
  static final RegExp TREND =
      RegExp(r'^(?<trend>TEMPO|BECMG|NOSIG|FM\d{6}|PROB\d{2})$');

  static final RegExp REMARK = RegExp(r'^(?<rmk>RMK(S)?)$');
}
