library reports;

import 'dart:convert';

import 'package:tuple/tuple.dart';

import '/src/utils/utils.dart';
import '/src/database/database.dart';

// base
part 'models/base/change_indicator.dart';
part 'models/base/clouds.dart';
part 'models/base/distance.dart';
part 'models/base/errors.dart';
part 'models/base/flight_rules.dart';
part 'models/base/group.dart';
part 'models/base/modifier.dart';
part 'models/base/numeric.dart';
part 'models/base/pressure.dart';
part 'models/base/report.dart';
part 'models/base/stations.dart';
part 'models/base/string_attribute.dart';
part 'models/base/temperature.dart';
part 'models/base/time.dart';
part 'models/base/type.dart';
part 'models/base/wind.dart';

// metar
part 'metar.dart';
part 'models/metar/pressure.dart';
part 'models/metar/recent_weather.dart';
part 'models/metar/runway_range.dart';
part 'models/metar/runway_state.dart';
part 'models/metar/sea_state.dart';
part 'models/metar/temperatures.dart';
part 'models/metar/trend_indicator.dart';
part 'models/metar/visibility.dart';
part 'models/metar/weather_trend.dart';
part 'models/metar/weather.dart';
part 'models/metar/wind_variation.dart';
part 'models/metar/wind.dart';
part 'models/metar/windshear.dart';

// taf
part 'taf.dart';
part 'models/taf/cancelled.dart';
part 'models/taf/change_forecast.dart';
part 'models/taf/change_indicator.dart';
part 'models/taf/missing.dart';
part 'models/taf/temperature.dart';
part 'models/taf/valid.dart';

/// Parse the groups of the section.
///
/// Args:
///     handlers (List<GroupHandler>): handler list to manage and match.
///     section (String): the section containing all the groups to parse separated
///     by spaces.
///
/// Returns:
///     unparsed_groups (List<String>): the not matched groups with anyone
///     of the regular expresions stored in `handlers`.
List<String> parseSection(List<GroupHandler> handlers, String section) {
  final unparsedGroups = <String>[];
  var index = 0;

  section.split(' ').forEach((group) {
    unparsedGroups.add(group);
    var counter = 0;

    for (var i = index; i < handlers.length; i++) {
      var handler = handlers[i];
      counter++;

      if (handler.regexp.hasMatch(group)) {
        index += counter;
        handler.handler(group);
        unparsedGroups.remove(group);
        break;
      }
    }
  });

  return unparsedGroups;
}
