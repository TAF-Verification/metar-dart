import 'package:tuple/tuple.dart';

import 'package:metar_dart/src/models/models.dart';
import 'package:metar_dart/src/utils/utils.dart';

class Metar extends Report {
  var _string = '';
  bool _truncate;
  Type _type = Type('METAR');
  MetarSections _sections;

  Metar(String code, {int year, int month, bool truncate = false})
      : super(code) {
    _truncate = truncate;

    if (code.isEmpty || code == null) {
      throw ParserError('METAR code must be not null or not empty string');
    }

    _sections = MetarSections(raw_code);

    _parse();
  }

  @override
  String toString() => _string;

  // Handle type
  void _handle_type(RegExpMatch match) {
    _type = Type(match.namedGroup('type'));

    _string += _type.toString() + '\n';
  }

  Type get type => _type;

  void _parse_body() {
    final handlers = <Tuple2<RegExp, Function>>[
      Tuple2(REGEXP.TYPE, _handle_type),
    ];

    Iterable<RegExpMatch> matches;
    var index = 0;

    final body = sanitizeVisibility(_sections.body);
    body.split(' ').forEach((group) {
      unparsed_groups.add(group);

      for (var i = index; i < handlers.length; i++) {
        var handler = handlers[i];

        matches = handler.item1.allMatches(group);
        index++;

        if (matches.isNotEmpty) {
          handler.item2(matches.elementAt(0));
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
