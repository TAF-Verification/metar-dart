// Regular expressions to decode various groups of the METAR code
final REGEXP = RegularExpresions();

class RegularExpresions {
  RegExp MISSING_RE = RegExp(r'^[M/]+$');

  RegExp TYPE = RegExp(r'^(?<type>METAR|SPECI|TAF)$');

  RegExp COR_RE = RegExp(r'^(?<cor>COR)$');

  RegExp STATION = RegExp(r'^(?<station>[A-Z][A-Z0-9]{3})$');

  RegExp TIME = RegExp(r'^(?<day>\d{2})(?<hour>\d{2})(?<minute>\d{2})Z$');

  RegExp MODIFIER = RegExp(r'^(?<mod>AUTO|FINO|NIL|TEST|COR(R)?|RTD|CC[A-G])$');

  RegExp WIND = RegExp(r'^(?<dir>[0-3]\d{2}|///|MMM|VRB|P)'
      r'(?<speed>[\d]{2}|[/M]{2})'
      r'(G(?<gust>\d{2}|[/M{2}]))?'
      r'(?<units>KT|MPS)$');

  RegExp WIND_VARIATION = RegExp(r'^(?<from>\d{3})'
      r'V(?<to>\d{3})$');

  //RegExp OPTIONALVIS_RE = RegExp(r'^(?<opt>\d)$');

  RegExp VISIBILITY = RegExp(r'^(?<vis>\d{4}|\//\//)'
      r'(?<dir>[NSEW]([EW])?)?|'
      r'((?<opt>\d)_)?(M|P)?'
      r'(?<visextreme>\d{1,2}|\d/\d)'
      r'(?<units>SM|KM|M|U)|'
      r'(?<cavok>CAVOK)$');

  RegExp MINIMUM_VISIBILITY = RegExp(r'^(?<vis>\d{4})'
      r'(?<dir>[NSEW]([EW])?)$');

  RegExp RUNWAY = RegExp(r'^R(?<name>\d{2}([RLC])?)/'
      r'(?<rvrlow>[MP])?'
      r'(?<low>\d{2,4})'
      r'(V(?<rvrhigh>[MP])?'
      r'(?<high>\d{2,4}))?'
      r'(?<units>FT)?'
      r'(?<trend>[NDU])?$');

  RegExp WEATHER = RegExp(r'^((?<intensity>(-|\+|VC))?'
      r'(?<descrip>MI|PR|BC|DR|BL|SH|TS|FZ)?'
      r'((?<precip>DZ|RA|SN|SG|IC|PL|GR|GS|UP)|'
      r'(?<obsc>BR|FG|FU|VA|DU|SA|HZ|PY)|'
      r'(?<other>PO|SQ|FC|SS|DS|NSW|/))?)$');

  RegExp SKY = RegExp(r'^(?<cover>VV|CLR|SCK|SCK|NSC|NCD|BKN|SCT|FEW|OVC|///)'
      r'(?<height>\d{3}|///)?'
      r'(?<cloud>TCU|CB|///)?$');

  RegExp TEMPERATURES = RegExp(r'^(?<tsign>M|-)?'
      r'(?<temp>\d{2}|//|XX|MM)/'
      r'(?<dsign>M|-)?'
      r'(?<dewpt>\d{2}|//|XX|MM)$');

  RegExp PRESSURE = RegExp(r'^(?<units>A|Q|QNH)?'
      r'(?<press>\d{4}|\//\//)'
      r'(?<units2>INS)?$');

  RegExp RECENT_WEATHER = RegExp(r'^RE(?<descrip>MI|PR|BC|DR|BL|SH|TS|FZ)?'
      r'(?<precip>DZ|RA|SN|SG|IC|PL|GR|GS|UP)?'
      r'(?<obsc>BR|FG|VA|DU|SA|HZ|PY)?'
      r'(?<other>PO|SQ|FC|SS|DS)?$');

  RegExp WINDSHEAR = RegExp(r'^WS(?<all>_ALL)?'
      r'_(RWY|R(?<name>\d{2}[RCL]?))$');

  RegExp SEA_STATE = RegExp(r'^W(?<sign>M)?'
      r'(?<temp>\d{2})/S'
      r'(?<state>\d)$');

  RegExp COLOR_RE =
      RegExp(r'^(BLACK)?(BLU|GRN|WHT|RED)\+?(/?(BLACK)?(BLU|GRN|WHT|RED)\+?)*');

  RegExp RUNWAYSTATE_RE = RegExp(
      r'^R(?<num>\d{2})?(?<name>[CLR])?/((?<deposit>\d|/)(?<contamination>\d|/)(?<depth>\d\d|//)(?<friction>\d\d|//)|(?<SNOCLO>SNOCLO)|(?<CLRD>CLRD//))$');
  //r'^((\d{2}) | R(\d{2})(RR?|LL?|C)?/?)((SNOCLO|CLRD(\d{2}|//)) | (\d|/)(\d|/)(\d{2}|//)(\d{2}|//))');

  RegExp TREND = RegExp(r'^(?<trend>TEMPO|BECMG|NOSIG|FM\d+|PROB\d{2})$');

  RegExp TRENDTIME_RE = RegExp(r'^(FM|TL|AT)(\d{2})(\d{2}\s+)');

  RegExp REMARK = RegExp(r'^(?<rmk>RMK(S)?)$');

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
