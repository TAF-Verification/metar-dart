library models;

import 'package:tuple/tuple.dart';

import '../utils/utils.dart';
import '../database/database.dart';

// Models
part 'change_indicator.dart';
part 'clouds.dart';
part 'distance.dart';
part 'errors.dart';
part 'group.dart';
part 'modifier.dart';
part 'numeric.dart';
part 'pressure.dart';
part 'report.dart';
part 'stations.dart';
part 'string_attribute.dart';
part 'temperature.dart';
part 'time.dart';
part 'type.dart';
part 'wind.dart';

// Metar and its models
part 'metar/metar.dart';
part 'metar/models/pressure.dart';
part 'metar/models/recent_weather.dart';
part 'metar/models/runway_range.dart';
part 'metar/models/runway_state.dart';
part 'metar/models/sea_state.dart';
part 'metar/models/temperatures.dart';
part 'metar/models/time.dart';
part 'metar/models/trend_indicator.dart';
part 'metar/models/visibility.dart';
part 'metar/models/weather_trend.dart';
part 'metar/models/weather.dart';
part 'metar/models/wind_variation.dart';
part 'metar/models/wind.dart';
part 'metar/models/windshear.dart';

// Taf and its models
part 'taf/models/cancelled.dart';
part 'taf/models/missing.dart';
part 'taf/models/temperature.dart';
part 'taf/models/valid.dart';
part 'taf/taf.dart';
