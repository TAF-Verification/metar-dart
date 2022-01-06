part of models;

mixin WeatherMixin on Report {
  final _weathers = GroupList<Weather>(3);

  void _handleWeather(String group) {
    final match = RegularExpresions.WEATHER.firstMatch(group);
    final weather = Weather(group, match);

    _weathers.add(weather);

    _concatenateString(weather);
  }

  /// Get the weather data of the report.
  GroupList<Weather> get weathers => _weathers;
}
