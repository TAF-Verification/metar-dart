import 'package:tuple/tuple.dart';

import 'package:metar_dart/src/models/models.dart';
import 'package:metar_dart/src/utils/utils.dart';

class Metar extends Report {
  var _string = '';
  bool _truncate;
  int? _year, _month;
  MetarSections _sections = MetarSections('');
  Type _type = Type('METAR');
  Station? _station;
  Time? _time;
  Modifier? _modifier;

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
  void _handle_type(String group) {
    _type = Type(group);

    _string += _type.toString() + '\n';
  }

  Type get type => _type;

  // Handle station
  void _handle_station(String group) {
    _station = Station(group);

    _string += _station.toString() + '\n';
  }

  Station? get station => _station;

  // Handle time
  void _handle_time(String group) {
    final match = REGEXP.TIME.firstMatch(group);
    _time = Time(group, match, _year, _month);

    _string += 'Time: ${_time.toString()}\n';
  }

  Time? get time => _time;

  // Handle modifier
  void _handle_modifier(String group) {
    _modifier = Modifier(group);

    _string += 'Modifier: ${_modifier.toString()}\n';
  }

  Modifier? get modifier => _modifier;

  void _parse_body() {
    final handlers = <Tuple2<RegExp, Function>>[
      Tuple2(REGEXP.TYPE, _handle_type),
      Tuple2(REGEXP.STATION, _handle_station),
      Tuple2(REGEXP.TIME, _handle_time),
      Tuple2(REGEXP.MODIFIER, _handle_modifier),
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
