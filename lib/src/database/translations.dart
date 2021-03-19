// Translations of the sky conditions codes into english

class SKY_TRANSLATIONS {
  Map<String, String> SKY_COVER = {
    'SKC': 'clear',
    'CLR': 'clear',
    'NSC': 'clear',
    'NCD': 'clear',
    'FEW': 'a few',
    'SCT': 'scattered',
    'BKN': 'broken',
    'OVC': 'overcast',
    '///': '',
    'VV': 'indefinite ceiling',
  };

  Map<String, String> CLOUD_TYPE = {
    'AC': 'altocumulus',
    'ACC': 'altocumulus castellanus',
    'ACSL': 'standing lenticulas altocumulus',
    'AS': 'altostratus',
    'CB': 'cumulonimbus',
    'CBMAM': 'cumulonimbus mammatus',
    'CCSL': 'standing lenticular cirrocumulus',
    'CC': 'cirrocumulus',
    'CI': 'cirrus',
    'CS': 'cirrostratus',
    'CU': 'cumulus',
    'NS': 'nimbostratus',
    'SC': 'stratocumulus',
    'ST': 'stratus',
    'SCSL': 'standing lenticular stratocumulus',
    'TCU': 'towering cumulus'
  };

// Translation of the present-weather codes into english

  Map<String, String> WEATHER_INT = {
    '-': 'light',
    '+': 'heavy',
    '-VC': 'nearby light',
    '+VC': 'nearby heavy',
    'VC': 'nearby',
  };

  Map<String, String> WEATHER_DESC = {
    'MI': 'shallow',
    'PR': 'partial',
    'BC': 'patches of',
    'DR': 'low drifting',
    'BL': 'blowing',
    'SH': 'showers',
    'TS': 'thunderstorm',
    'FZ': 'freezing',
  };

  Map<String, String> WEATHER_PREC = {
    'DZ': 'drizzle',
    'RA': 'rain',
    'SN': 'snow',
    'SG': 'snow grains',
    'IC': 'ice crystals',
    'PL': 'ice pellets',
    'GR': 'hail',
    'GS': 'snow pellets',
    'UP': 'unknown precipitation',
    '//': '',
  };

  Map<String, String> WEATHER_OBSC = {
    'BR': 'mist',
    'FG': 'fog',
    'FU': 'smoke',
    'VA': 'volcanic ash',
    'DU': 'dust',
    'SA': 'sand',
    'HZ': 'haze',
    'PY': 'spray',
  };

  Map<String, String> WEATHER_OTHER = {
    'PO': 'sand whirls',
    'SQ': 'squalls',
    'FC': 'funnel cloud',
    'SS': 'sandstorm',
    'DS': 'dust storm',
  };

  Map<String, String> WEATHER_SPECIAL = {
    '+FC': 'tornado',
  };

  Map<String, String> COLOR = {
    'BLU': 'blue',
    'GRN': 'green',
    'WHT': 'white',
  };

// Translation of various remark codes into english

  Map<String, String> PRESSURE_TENDENCY = {
    '0': 'increasing, then decreasing',
    '1': 'increasing more slowly',
    '2': 'increasing',
    '3': 'increasing more quickly',
    '4': 'steady',
    '5': 'decreasing, then increasing',
    '6': 'decreasing more slowly',
    '7': 'decreasing',
    '8': 'decreasing more quickly',
  };

  Map<String, String> LIGHTNING_FREQUENCY = {
    'OCNL': 'occasional',
    'FRQ': 'frequent',
    'CONS': 'constant',
  };

  Map<String, String> LIGHTNING_TYPE = {
    'IC': 'intracloud',
    'CC': 'cloud-to-cloud',
    'CG': 'cloud-to-ground',
    'CA': 'cloud-to-air',
  };

  Map<String, String> REPORT_TYPE = {
    'METAR': 'routine report',
    'SPECI': 'special report',
    'AUTO': 'automatic report',
    'COR': 'manually corrected report',
  };
}
