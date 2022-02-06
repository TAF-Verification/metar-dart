part of models;

/// Basic structure for trend codes in METAR.
class MetarTrend extends Trend {
  MetarTrend(String? code, RegExpMatch? match) : super(code, match);
}
