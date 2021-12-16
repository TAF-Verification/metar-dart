part of utils;

/// Regular expressions to decode various groups of the METAR code.
class RegularExpresions {
  static RegExp MISSING_RE = RegExp(r'^[M/]+$');

  static RegExp TYPE = RegExp(r'^(?<type>METAR|SPECI|TAF)$');

  static RegExp COR_RE = RegExp(r'^(?<cor>COR)$');

  static RegExp STATION = RegExp(r'^(?<station>[A-Z][A-Z0-9]{3})$');

  static RegExp TIME =
      RegExp(r'^(?<day>\d{2})(?<hour>\d{2})(?<minute>\d{2})Z$');

  static RegExp MODIFIER =
      RegExp(r'^(?<mod>AUTO|FINO|NIL|TEST|COR(R)?|RTD|CC[A-G])$');

  static RegExp WIND = RegExp(r'^(?<dir>[0-3]\d{2}|///|MMM|VRB|P)'
      r'(?<speed>[\d]{2}|[/M]{2})'
      r'(G(?<gust>\d{2}|[/M{2}]))?'
      r'(?<units>KT|MPS)$');

  static RegExp WIND_VARIATION = RegExp(r'^(?<from>\d{3})'
      r'V(?<to>\d{3})$');

  //RegExp OPTIONALVIS_RE = RegExp(r'^(?<opt>\d)$');

  static RegExp VISIBILITY = RegExp(r'^(?<vis>\d{4}|\//\//)'
      r'(?<dir>[NSEW]([EW])?)?|'
      r'((?<opt>\d)_)?(M|P)?'
      r'(?<visextreme>\d{1,2}|\d/\d)'
      r'(?<units>SM|KM|M|U)|'
      r'(?<cavok>CAVOK)$');

  static RegExp MINIMUM_VISIBILITY = RegExp(r'^(?<vis>\d{4})'
      r'(?<dir>[NSEW]([EW])?)$');

  static RegExp RUNWAY = RegExp(r'^R(?<name>\d{2}([RLC])?)/'
      r'(?<rvrlow>[MP])?'
      r'(?<low>\d{2,4})'
      r'(V(?<rvrhigh>[MP])?'
      r'(?<high>\d{2,4}))?'
      r'(?<units>FT)?'
      r'(?<trend>[NDU])?$');

  static RegExp WEATHER = RegExp(r'^((?<intensity>(-|\+|VC))?'
      r'(?<descrip>MI|PR|BC|DR|BL|SH|TS|FZ)?'
      r'((?<precip>DZ|RA|SN|SG|IC|PL|GR|GS|UP)|'
      r'(?<obsc>BR|FG|FU|VA|DU|SA|HZ|PY)|'
      r'(?<other>PO|SQ|FC|SS|DS|NSW|/))?)$');

  static RegExp SKY =
      RegExp(r'^(?<cover>VV|CLR|SCK|SCK|NSC|NCD|BKN|SCT|FEW|OVC|///)'
          r'(?<height>\d{3}|///)?'
          r'(?<cloud>TCU|CB|///)?$');

  static RegExp TEMPERATURES = RegExp(r'^(?<tsign>M|-)?'
      r'(?<temp>\d{2}|//|XX|MM)/'
      r'(?<dsign>M|-)?'
      r'(?<dewpt>\d{2}|//|XX|MM)$');

  static RegExp PRESSURE = RegExp(r'^(?<units>A|Q|QNH)?'
      r'(?<press>\d{4}|\//\//)'
      r'(?<units2>INS)?$');

  static RegExp RECENT_WEATHER =
      RegExp(r'^RE(?<descrip>MI|PR|BC|DR|BL|SH|TS|FZ)?'
          r'(?<precip>DZ|RA|SN|SG|IC|PL|GR|GS|UP)?'
          r'(?<obsc>BR|FG|VA|DU|SA|HZ|PY)?'
          r'(?<other>PO|SQ|FC|SS|DS)?$');

  static RegExp WINDSHEAR = RegExp(r'^WS(?<all>_ALL)?'
      r'_(RWY|R(?<name>\d{2}[RCL]?))$');

  static RegExp SEA_STATE = RegExp(r'^W(?<sign>M)?'
      r'(?<temp>\d{2})/S'
      r'(?<state>\d)$');

  static RegExp COLOR_RE =
      RegExp(r'^(BLACK)?(BLU|GRN|WHT|RED)\+?(/?(BLACK)?(BLU|GRN|WHT|RED)\+?)*');

  static RegExp RUNWAY_STATE = RegExp(r'^R(?<name>\d{2}([RLC])?)?/('
      r'(?<deposits>\d|/)'
      r'(?<contamination>\d|/)'
      r'(?<depth>\d\d|//)'
      r'(?<friction>\d\d|//)|'
      r'(?<snoclo>SNOCLO)|'
      r'(?<clrd>CLRD//))$');

  static RegExp TREND =
      RegExp(r'^(?<trend>TEMPO|BECMG|NOSIG|FM\d{6}|PROB\d{2})$');

  static RegExp TREND_TIME_GROUP =
      RegExp(r'^(?<prefix>FM|TL|AT)(?<time>\d{4})$');

  static RegExp REMARK = RegExp(r'^(?<rmk>RMK(S)?)$');

// Regular expressions for remark groups
  // RegExp AUTO_RE = RegExp(r'^AO(\d)\s+');

  // RegExp SEALVL_PRESS_RE = RegExp(r'^SLP(\d{3})');

  // RegExp PEAK_WIND_RE =
  //     RegExp(r'^P[A-Z]\s+WND\s+(\d{3})(P?\d{3}?)/(\d{2})?(\d{2})');

  // RegExp WIND_SHIFT_RE = RegExp(r'^WSHFT\s+(\d{2})?(\d{2})(\s+(FROPA))?');

  // RegExp PRECIP_1HR_RE = RegExp(r'^P(\d{4})');

  // RegExp PRECIP_24HR_RE = RegExp(r'^(6|7)(\d{4})');

  // RegExp PRESS_3HR_RE = RegExp(r'^5([0-8])(\d{3})');

  // RegExp TEMP_1HR_RE = RegExp(r'^T(1|2)(0|1)(\d{3})');

  // RegExp TEMP_6HR_RE = RegExp(r'^(1|2)(0|1)(\d{3})');

  // RegExp TEMP_24HR_RE = RegExp(r'^4(0|1)(\d{3})(0|1)(\d{3})');

  // RegExp UNPARSED_RE = RegExp(r'(\S+)\s+');

  // RegExp LIGHTNING_RE = RegExp(
  //     r'^((OCNL|FRQ|CONS)\s+)?LGT((IC|CC|CG|CA)*)( \s+(( OHD | VC | DSNT\s+ | \s+AND\s+ | [NSEW][EW]? (-[NSEW][EW]?)* )+) )?');

  // RegExp TS_LOC_RE = RegExp(
  //     r'TS(\s+(( OHD | VC | DSNT\s+ | \s+AND\s+ | [NSEW][EW]? (-[NSEW][EW]?)* )+))?( \s+MOV\s+([NSEW][EW]?) )?');

  // RegExp SNOWDEPTH_RE = RegExp(r'^4/(\d{3})');

  // RegExp ICE_ACCRETION_RE = RegExp(r'^I([136])(\d{3})');
}
