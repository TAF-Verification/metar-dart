library models;

import '../utils/utils.dart';
import '../database/database.dart';

// Models
part 'report.dart';
part 'group.dart';
part 'group_handler.dart';
part 'errors.dart';
part 'stations.dart';
part 'time.dart';
part 'modifier.dart';
part 'numeric.dart';
part 'wind.dart';
part 'distance.dart';
part 'clouds.dart';
part 'temperature.dart';
part 'pressure.dart';

// Groups
part 'type.dart';

// Metar and its models
part 'metar/metar.dart';
part 'metar/models/time.dart';
part 'metar/models/wind.dart';
part 'metar/models/wind_variation.dart';
part 'metar/models/visibility.dart';
part 'metar/models/runway_range.dart';
part 'metar/models/weather.dart';
part 'metar/models/temperatures.dart';
part 'metar/models/pressure.dart';

// METAR Mixins
part 'mixins/metar/modifier_mixin.dart';
part 'mixins/metar/wind_mixin.dart';
part 'mixins/metar/visibility_mixin.dart';
part 'mixins/metar/weather_mixin.dart';
part 'mixins/metar/cloud_mixin.dart';
