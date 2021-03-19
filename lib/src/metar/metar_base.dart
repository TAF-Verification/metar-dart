import 'package:http/http.dart' as http;
import 'package:metar_dart/src/database/translations.dart';
import 'package:tuple/tuple.dart';

import 'package:metar_dart/src/database/stations_db.dart';
import 'package:metar_dart/src/metar/regexp.dart';
import 'package:metar_dart/src/units/units.dart';
import 'package:metar_dart/src/utils/capitalize_string.dart';
import 'package:metar_dart/src/utils/parser_error.dart';
import 'package:metar_dart/src/utils/station.dart';

/// Divide the METAR in three parts (if possible):
/// * `body`
/// * `trend`
/// * `remark`
List<String> _divideCode(String code) {
  String body, trend, rmk;
  final regexp = METAR_REGEX();
  int rmkIndex, trendIndex;

  if (regexp.TREND_RE.hasMatch(code)) {
    trendIndex = regexp.TREND_RE.firstMatch(code).start;
  }

  if (regexp.REMARK_RE.hasMatch(code)) {
    rmkIndex = regexp.REMARK_RE.firstMatch(code).start;
  }

  if (trendIndex == null && rmkIndex != null) {
    body = code.substring(0, rmkIndex - 1);
    rmk = code.substring(rmkIndex);
  } else if (trendIndex != null && rmkIndex == null) {
    body = code.substring(0, trendIndex - 1);
    trend = code.substring(trendIndex);
  } else if (trendIndex == null && rmkIndex == null) {
    body = code;
  } else {
    if (trendIndex > rmkIndex) {
      body = code.substring(0, rmkIndex - 1);
      rmk = code.substring(rmkIndex, trendIndex - 1);
      trend = code.substring(trendIndex);
    } else {
      body = code.substring(0, trendIndex - 1);
      rmk = code.substring(trendIndex, rmkIndex - 1);
      trend = code.substring(rmkIndex);
    }
  }

  return <String>[body, trend, rmk];
}

/// Metar model to parse the code for every station
class Metar {
  String _body, _trend, _rmk;
  String _string = '### BODY ###\n';
  String _code, _errorMessage;
  bool _correction = false;
  String _modifier;
  String _type = 'METAR';
  Station _station;
  int _month, _year;
  DateTime _time;
  Direction _windDirection,
      _trendWindDirection,
      _windVariationFrom,
      _windVariationTo;
  Speed _windSpeed, _windGust, _trendWindSpeed, _trendWindGust;
  Length _visibility, _trendVisibility, _minimumVisibility;
  Direction _minimumVisibilityDirection;
  Length _optionalVisibility, _trendOptionalVisibility;
  bool _cavok, _trendCavok;
  List<Tuple7<String, String, String, Length, String, Length, String>> _runway =
      [];
  final _weather = <Map<String, String>>[];
  final _trendWeather = <Map<String, String>>[];
  final _translations = SKY_TRANSLATIONS();

  Metar(String code, {int utcMonth, int utcYear}) {
    if (code.isEmpty || code == null) {
      _errorMessage = 'metar code must be not null or empty string';
      throw ParserError(_errorMessage);
    }

    _code = code.trim().replaceAll(RegExp(r'\s+'), ' ').replaceAll('=', '');
    final dividedCodeList = _divideCode(_code);

    // Parts of the METAR code
    _body = dividedCodeList[0];
    _trend = dividedCodeList[1];
    _rmk = dividedCodeList[2];

    final now = DateTime.now().toUtc();
    if (utcMonth != null) {
      _month = utcMonth;
    } else {
      _month = now.month;
    }

    if (utcYear != null) {
      _year = utcYear;
    } else {
      _year = now.year;
    }

    _bodyParser();
  }

  /// Static method to get the current METAR report for a given station
  static Future<Metar> current(String icaoCode) async {
    final url =
        'http://tgftp.nws.noaa.gov/data/observations/metar/stations/${icaoCode.toUpperCase()}.TXT';
    final response = await http.get(url);
    final data = response.body.split('\n');

    final dateString = data[0].replaceAll('/', '-') + ':00';
    final date = DateTime.parse(dateString);

    return Metar(data[1], utcMonth: date.month, utcYear: date.year);
  }

  @override
  String toString() {
    return _string;
  }

  /// Here begins the body group handlers
  void _handleType(RegExpMatch match) {
    _type = match.namedGroup('type');
    _string += '--- Type ---\n'
        ' * $_type';
  }

  void _handleStation(RegExpMatch match) {
    final stationID = match.namedGroup('station');
    final station = getStation(stationID);

    _station = Station(
      station[0],
      station[1],
      station[2],
      station[3],
      station[4],
      station[5],
      station[6],
      station[7],
    );

    final stationAsMap = _station.toMap();
    _string += '--- Station ---\n'
        ' * Name: ${stationAsMap['name']}\n'
        ' * ICAO: ${stationAsMap['icao']}\n'
        ' * IATA: ${stationAsMap['iata']}\n'
        ' * SYNOP: ${stationAsMap['synop']}\n'
        ' * Longitude: ${stationAsMap['longitude']}\n'
        ' * Latitude: ${stationAsMap['latitude']}\n'
        ' * Elevation: ${stationAsMap['elevation']}\n'
        ' * Country: ${stationAsMap['country']}\n';
  }

  void _handleCorrection(RegExpMatch match) {
    _correction = true;

    _string += '--- Correction ---\n';
  }

  void _handleTime(RegExpMatch match) {
    final day = int.parse(match.namedGroup('day'));
    final hour = int.parse(match.namedGroup('hour'));
    final minute = int.parse(match.namedGroup('minute'));

    if (minute != 0) {
      _type = 'SPECI';
    }

    _time = DateTime(_year, _month, day, hour, minute);
    _string += '--- Time ---\n'
        ' * $_time\n';
  }

  void _handleModifier(RegExpMatch match) {
    _modifier = match.namedGroup('mod');

    final mod = capitalize(_modifier);

    _string += '--- $mod ---\n';
  }

  void _handleWind(RegExpMatch match, {String section = 'body'}) {
    final windDirection = match.namedGroup('dir');
    final windSpeed = match.namedGroup('speed');
    final windGust = match.namedGroup('gust');
    final units = match.namedGroup('units');

    Direction dirValue;
    Speed speedValue, gustValue;

    if (windDirection != null && RegExp(r'^\d{3}$').hasMatch(windDirection)) {
      dirValue = Direction.fromDegrees(value: windDirection);
    } else {
      dirValue = Direction.fromUndefined(value: windDirection);
    }

    if (windSpeed != null && RegExp(r'^\d{2}$').hasMatch(windSpeed)) {
      if (units == 'KT' || units == 'KTS') {
        speedValue = Speed.fromKnot(value: double.parse(windSpeed));
      } else {
        speedValue = Speed.fromMeterPerSecond(value: double.parse(windSpeed));
      }
    }

    if (windGust != null && RegExp(r'^\d{2}').hasMatch(windGust)) {
      if (units == 'KT' || units == 'KTS') {
        gustValue = Speed.fromKnot(value: double.parse(windGust));
      } else {
        gustValue = Speed.fromMeterPerSecond(value: double.parse(windGust));
      }
    }

    if (section == 'body') {
      _windDirection = dirValue;
      _windSpeed = speedValue;
      _windGust = gustValue;
    } else {
      _trendWindDirection = dirValue;
      _trendWindSpeed = speedValue;
      _trendWindGust = gustValue;
    }

    _string += '--- Wind ---\n'
        ' * Direction:\n'
        '   - Degrees: ${dirValue.variable ? 'Varibale' : '${dirValue.directionInDegrees}°'}\n'
        '   - Cardinal point: ${dirValue.variable ? 'Variable' : dirValue.cardinalPoint}\n'
        ' * Speed: ${speedValue != null ? speedValue.inKnot : 0.0} knots\n'
        ' * Gust: ${gustValue != null ? gustValue.inKnot : 0.0} knots\n';
  }

  void _handleWindVariation(RegExpMatch match) {
    final from = match.namedGroup('from');
    final to = match.namedGroup('to');

    _windVariationFrom = Direction.fromDegrees(value: from);
    _windVariationTo = Direction.fromDegrees(value: to);

    _string += ' * Wind direction variation:\n'
        '   - From:\n'
        '     > Degrees: ${_windVariationFrom.directionInDegrees}\n'
        '     > Cardinal point: ${_windVariationTo.cardinalPoint}\n'
        '   - To:\n'
        '     > Degrees: ${_windVariationTo.directionInDegrees}\n'
        '     > Cardinal point: ${_windVariationTo.cardinalPoint}\n';
  }

  void _handleOptionalVisibility(RegExpMatch match, {String section = 'body'}) {
    final optVis = match.namedGroup('opt');

    if (section == 'body') {
      _optionalVisibility = Length.fromMiles(value: double.parse(optVis));
    } else {
      _trendOptionalVisibility = Length.fromMiles(value: double.parse(optVis));
    }
  }

  void _handleVisibility(RegExpMatch match, {String section = 'body'}) {
    String units, vis, extreme, visExtreme, cavok;
    Length value;

    units = match.namedGroup('units');
    vis = match.namedGroup('vis');
    extreme = match.namedGroup('extreme');
    visExtreme = match.namedGroup('visextreme');
    cavok = match.namedGroup('cavok');

    if (section == 'body') {
      (cavok == null) ? _cavok = false : _cavok = true;
    } else {
      (cavok == null) ? _trendCavok = false : _trendCavok = true;
    }

    if (visExtreme != null && visExtreme.contains('/')) {
      var items = visExtreme.split('/');
      visExtreme = '${int.parse(items[0]) / int.parse(items[1])}';
    }

    units ??= units = 'M';

    Length visFromMiles(Length optionalVis) {
      Length value;

      if (optionalVis != null) {
        value = Length.fromMiles(
          value: optionalVis.inMiles + double.parse(visExtreme),
        );
      } else {
        value = Length.fromMiles(value: double.parse(visExtreme));
      }

      return value;
    }

    if (units == 'SM' && section == 'body') {
      value = visFromMiles(_optionalVisibility);
    } else if (units == 'SM') {
      value = visFromMiles(_trendOptionalVisibility);
    } else if (units == 'KM') {
      value = Length.fromKilometers(value: double.parse(visExtreme));
    } else {
      if (vis == '9999' || _cavok) {
        value = Length.fromMeters(value: double.parse('10000'));
      } else {
        value = Length.fromMeters(value: double.parse(vis));
      }
    }

    if (section == 'body') {
      _visibility = value;
    } else {
      _trendVisibility = value;
    }

    _string += '--- Visibility ---\n'
        ' * Prevailing: ${value.inMeters} meters\n'
        ' * ${(cavok != null) ? 'CAVOK' : 'No CAVOK'}\n';
  }

  void _handleMinimunVisibility(RegExpMatch match) {
    final minVis = match.namedGroup('vis');
    final dir = match.namedGroup('dir');

    _minimumVisibility = Length.fromMeters(value: double.parse(minVis));
    _minimumVisibilityDirection = Direction.fromUndefined(value: dir);

    _string +=
        ' * Minimum visibility: ${_minimumVisibility.inMeters} meters to $dir\n';
  }

  void _handleRunway(RegExpMatch match) {
    Tuple7<String, String, String, Length, String, Length, String> runway;

    var name = match.namedGroup('name');
    var rvrLow = match.namedGroup('rvrlow');
    final lowRange = match.namedGroup('low');
    var rvrHigh = match.namedGroup('rvrhigh');
    final highRange = match.namedGroup('high');
    var units = match.namedGroup('units');
    var trend = match.namedGroup('trend');

    // setting the range units
    if (units == 'FT') {
      units = 'feet';
    } else {
      units = 'meters';
    }

    // setting the trend
    if (trend == 'N') {
      trend = 'no change';
    } else if (trend == 'U') {
      trend = 'increasing';
    } else if (trend == 'D') {
      trend = 'decreasing';
    } else {
      trend = '';
    }

    // setting the name of runway
    name = name
        .substring(1)
        .replaceFirst('L', ' left')
        .replaceFirst('R', ' right')
        .replaceFirst('C', ' center');

    Length _extractRange(String range) {
      if (range == null) {
        return Length.fromMeters(value: 0.0);
      }

      final rangeValue = double.parse(range);

      if (units == 'feet') {
        return Length.fromFeet(value: rangeValue);
      } else {
        return Length.fromMeters(value: rangeValue);
      }
    }

    String _translateRVR(String rvr) {
      if (rvr == 'P') {
        return 'greater than';
      } else if (rvr == 'M') {
        return 'less than';
      } else {
        return '';
      }
    }

    runway = Tuple7(
      name,
      units,
      _translateRVR(rvrLow),
      _extractRange(lowRange),
      _translateRVR(rvrHigh),
      _extractRange(highRange),
      trend,
    );

    // adding the runway
    _runway.add(runway);

    if (_runway.last == _runway[0]) {
      _string += ' * Runway:\n';
    }
    _string += '   - Name: ${runway.item1}\n'
        '     > Low range: ${runway.item3} ${runway.item4.inMeters} meters\n'
        '     > High range: ${runway.item5} ${runway.item6.inMeters} meters\n'
        '     > Trend: ${runway.item7}';
  }

  void _handleWeather(RegExpMatch match, {String section = 'body'}) {
    Map<String, String> weather;

    final intensity = match.namedGroup('intensity');
    final description = match.namedGroup('descrip');
    final precipitation = match.namedGroup('precip');
    final obscuration = match.namedGroup('obsc');
    final other = match.namedGroup('other');

    weather = {
      'intensity': intensity ?? '',
      'description': description ?? '',
      'precipitation': precipitation ?? '',
      'obscuration': obscuration ?? '',
      'other': other ?? '',
    };

    if (section == 'body') {
      _weather.add(weather);
    } else {
      _trendWeather.add(weather);
    }

    if ((_weather.isNotEmpty && weather == _weather[0]) ||
        (_trendWeather.isNotEmpty && weather == _trendWeather[0])) {
      _string += '--- Weather ---\n';
    }

    _string +=
        ' * Intensity: ${weather["intensity"] == "" ? "" : _translations.WEATHER_INT[weather["intensity"]]}\n'
        '   Description: ${weather["description"] == "" ? "" : _translations.WEATHER_DESC[weather["description"]]}\n'
        '   Precipitation: ${weather["precipitation"] == "" ? "" : _translations.WEATHER_PREC[weather["precipitation"]]}\n'
        '   Obscuration: ${weather["obscuration"] == "" ? "" : _translations.WEATHER_OBSC[weather["obscuration"]]}\n'
        '   Other: ${weather["other"] == "" ? "" : _translations.WEATHER_OTHER[weather["other"]]}\n';
  }

  // Method to parse the groups
  void _parseGroups(
    List<String> groups,
    List<List> handlers, {
    String section = 'body',
  }) {
    Iterable<RegExpMatch> matches;
    var index = 0;

    groups.forEach((group) {
      for (var i = index; i < handlers.length; i++) {
        final handler = handlers[i];

        if (handler[0].hasMatch(group) && !handler[2]) {
          matches = handler[0].allMatches(group);
          if (section == 'body') {
            handler[1](matches.elementAt(0));
          } else {
            handler[1](matches.elementAt(0), section: section);
          }

          handler[2] = true;
          index = i + 1;
          break;
        }

        // TODO: Descomentar esta línea para activar los errores de parseo
        // if (handlers.indexOf(handler) == handlers.length - 1) {
        //   _errorMessage = 'failed while processing "$group". Code: $_code';
        //   throw ParserError(_errorMessage);
        // }

      }
    });
  }

  void _bodyParser() {
    final handlers = [
      // [regex, handlerMethod, featureFound]
      [METAR_REGEX().TYPE_RE, _handleType, false],
      [METAR_REGEX().STATION_RE, _handleStation, false],
      [METAR_REGEX().COR_RE, _handleCorrection, false],
      [METAR_REGEX().TIME_RE, _handleTime, false],
      [METAR_REGEX().MODIFIER_RE, _handleModifier, false],
      [METAR_REGEX().WIND_RE, _handleWind, false],
      [METAR_REGEX().WINDVARIATION_RE, _handleWindVariation, false],
      [METAR_REGEX().OPTIONALVIS_RE, _handleOptionalVisibility, false],
      [METAR_REGEX().VISIBILITY_RE, _handleVisibility, false],
      [METAR_REGEX().SECVISIBILITY_RE, _handleMinimunVisibility, false],
      [METAR_REGEX().RUNWAY_RE, _handleRunway, false],
      [METAR_REGEX().WEATHER_RE, _handleWeather, false],
      [METAR_REGEX().WEATHER_RE, _handleWeather, false],
      [METAR_REGEX().WEATHER_RE, _handleWeather, false],
    ];

    _parseGroups(_body.split(' '), handlers);
  }

  // Getters
  String get body => _body;
  String get trend => _trend;
  String get remark => _rmk;
  String get type => _type;
  Station get station => _station;
  bool get correction => _correction;
  DateTime get time => _time;
  String get modifier => _modifier;
  Direction get windDirection => _windDirection;
  Speed get windSpeed => _windSpeed;
  Speed get windGust => _windGust;
  Direction get windVariationFrom => _windVariationFrom;
  Direction get windVariationTo => _windVariationTo;
  Length get visibility => _visibility;
  bool get cavok => _cavok;
  Length get minimumVisibility => _minimumVisibility;
  Direction get minimumVisibilityDirection => _minimumVisibilityDirection;
  List<Tuple7<String, String, String, Length, String, Length, String>>
      get runwayRanges => _runway;
  List<Map<String, String>> get weather => _weather;
}
