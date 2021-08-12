import 'package:tuple/tuple.dart';

import 'package:metar_dart/src/models/models.dart';
import 'package:metar_dart/src/utils/utils.dart';

class Metar extends Report {
  var _string = '';
  bool _truncate;
  int? _year, _month;
  MetarSections _sections = MetarSections('');
  Type _type = Type('METAR');
  Station _station = Station(null);
  Time _time = Time(null, null, null, null);
  Modifier _modifier = Modifier(null);
  Wind _wind = Wind(null, null);
  WindVariation _windVariation = WindVariation(null, null);

  Metar(String code, {int? year, int? month, bool truncate = false})
      : _truncate = truncate,
        super(code) {
    _year = year;
    _month = month;
    _truncate = truncate;

    if (code.isEmpty) {
      throw ParserError('METAR code must be not null or not empty string');
    }

    _sections = MetarSections(raw_code);

    _parse();
  }

  @override
  String toString() => _string;

  // Handle type
  void _handleType(String group) {
    _type = Type(group);

    _string += _type.toString() + '\n';
  }

  Type get type => _type;

  // Handle station
  void _handleStation(String group) {
    _station = Station(group);

    _string += _station.toString() + '\n';
  }

  Station get station => _station;

  // Handle time
  void _handleTime(String group) {
    final match = REGEXP.TIME.firstMatch(group);
    _time = Time(group, match, _year, _month);

    _string += 'Time: ${_time.toString()}\n';
  }

  Time get time => _time;

  // Handle modifier
  void _handleModifier(String group) {
    _modifier = Modifier(group);

    _string += 'Modifier: ${_modifier.toString()}\n';
  }

  Modifier get modifier => _modifier;

  void _handleWind(String group) {
    final match = REGEXP.WIND.firstMatch(group);
    _wind = Wind(group, match);

    _string += 'Wind: ${_wind.toString()}\n';
  }

  Wind get wind => _wind;

  void _handleWindVariation(String group) {
    final match = REGEXP.WIND_VARIATION.firstMatch(group);
    _windVariation = WindVariation(group, match);

    _string += 'Wind variation: ${_windVariation.toString()}';
  }

  WindVariation get windVariation => _windVariation;

  void _parse_body() {
    final handlers = <Tuple2<RegExp, Function>>[
      Tuple2(REGEXP.TYPE, _handleType),
      Tuple2(REGEXP.STATION, _handleStation),
      Tuple2(REGEXP.TIME, _handleTime),
      Tuple2(REGEXP.MODIFIER, _handleModifier),
      Tuple2(REGEXP.WIND, _handleWind),
      Tuple2(REGEXP.WIND_VARIATION, _handleWindVariation),
    ];

    var index = 0;

    final body = sanitizeVisibility(_sections.body);
    body.split(' ').forEach((group) {
      unparsed_groups.add(group);

      for (var i = index; i < handlers.length; i++) {
        var handler = handlers[i];

        index++;

        if (handler.item1.hasMatch(group)) {
          handler.item2(group);
          unparsed_groups.remove(group);
          break;
        }
      }
    });

    if (unparsed_groups.isNotEmpty && _truncate) {
      throw ParserError(
        'failed while processing ${unparsed_groups.join(" ")} from: $raw_code',
      );
    }
  }

  void _parse() {
    _parse_body();
  }

  List<String> get sections => _sections.sections;
  String get body => _sections.body;
  String get trend => _sections.trend;
  String get remark => _sections.remark;
}
