import 'package:metar_dart/src/models/visibility.dart';
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
  Visibility _visibility = Visibility(null, null);
  MinimumVisibility _minimumVisibility = MinimumVisibility(null, null);
  final RunwayRanges _runwayRanges = RunwayRanges();
  final Weathers _weathers = Weathers();
  final Sky _sky = Sky();
  Temperatures _temperatures = Temperatures(null, null);

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

  // Handle wind
  void _handleWind(String group) {
    final match = REGEXP.WIND.firstMatch(group);
    _wind = Wind(group, match);

    _string += 'Wind: ${_wind.toString()}\n';
  }

  Wind get wind => _wind;

  // Handle wind variation
  void _handleWindVariation(String group) {
    final match = REGEXP.WIND_VARIATION.firstMatch(group);
    _windVariation = WindVariation(group, match);

    _string += 'Wind variation: ${_windVariation.toString()}';
  }

  WindVariation get windVariation => _windVariation;

  // Handle visibility
  void _handleVisibility(String group) {
    final match = REGEXP.VISIBILITY.firstMatch(group);
    _visibility = Visibility(group, match);

    _string += 'Visibility: ${_visibility.toString()}\n';
  }

  Visibility get visibility => _visibility;

  // Handle minimum visibility
  void _handleMinimumVisibility(String group) {
    final match = REGEXP.MINIMUM_VISIBILITY.firstMatch(group);
    _minimumVisibility = MinimumVisibility(group, match);

    _string += 'Minimum visibility: ${_minimumVisibility.toString()}\n';
  }

  MinimumVisibility get minimumVisibility => _minimumVisibility;

  // Handle runway ranges
  void _handleRunwayRange(String group) {
    final match = REGEXP.RUNWAY.firstMatch(group);
    final runwayRange = RunwayRange(group, match);

    _runwayRanges.add(runwayRange);

    _string += 'Runway range: ${runwayRange.toString()}\n';
  }

  RunwayRanges get runwayRanges => _runwayRanges;

  // Handle weathers
  void _handleWeather(String group) {
    final match = REGEXP.WEATHER.firstMatch(group);
    final weather = Weather(group, match);

    _weathers.add(weather);

    _string += 'Weather: ${weather.toString()}\n';
  }

  Weathers get weathers => _weathers;

  // Handle cloud layer
  void _handleCloudLayer(String group) {
    final match = REGEXP.SKY.firstMatch(group);
    final cloudLayer = CloudLayer(group, match);

    _sky.add(cloudLayer);

    _string += 'Cloud layer: ${cloudLayer.toString()}\n';
  }

  Sky get sky => _sky;

  // Handle temperatures
  void _handleTemperatures(String group) {
    final match = REGEXP.TEMPERATURES.firstMatch(group);
    _temperatures = Temperatures(group, match);

    _string += 'Temperatures: ${_temperatures.toString()}';
  }

  Temperatures get temperatures => _temperatures;

  void _parse_body() {
    final handlers = <Tuple2<RegExp, Function>>[
      Tuple2(REGEXP.TYPE, _handleType),
      Tuple2(REGEXP.STATION, _handleStation),
      Tuple2(REGEXP.TIME, _handleTime),
      Tuple2(REGEXP.MODIFIER, _handleModifier),
      Tuple2(REGEXP.WIND, _handleWind),
      Tuple2(REGEXP.WIND_VARIATION, _handleWindVariation),
      Tuple2(REGEXP.VISIBILITY, _handleVisibility),
      Tuple2(REGEXP.MINIMUM_VISIBILITY, _handleMinimumVisibility),
      Tuple2(REGEXP.RUNWAY, _handleRunwayRange),
      Tuple2(REGEXP.RUNWAY, _handleRunwayRange),
      Tuple2(REGEXP.RUNWAY, _handleRunwayRange),
      Tuple2(REGEXP.WEATHER, _handleWeather),
      Tuple2(REGEXP.WEATHER, _handleWeather),
      Tuple2(REGEXP.WEATHER, _handleWeather),
      Tuple2(REGEXP.SKY, _handleCloudLayer),
      Tuple2(REGEXP.SKY, _handleCloudLayer),
      Tuple2(REGEXP.SKY, _handleCloudLayer),
      Tuple2(REGEXP.SKY, _handleCloudLayer),
      Tuple2(REGEXP.TEMPERATURES, _handleTemperatures),
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
