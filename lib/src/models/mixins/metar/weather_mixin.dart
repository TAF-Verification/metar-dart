part of models;

mixin MetarWeatherMixin on Report {
  final _weathers = GroupList<MetarWeather>(3);

  void _handleWeather(String group) {
    final match = MetarRegExp.WEATHER.firstMatch(group);
    final weather = MetarWeather(group, match);
    _weathers.add(weather);

    _concatenateString(weather);
  }

  /// Get the weather data of the report if provided.
  GroupList<MetarWeather> get weathers => _weathers;
}
