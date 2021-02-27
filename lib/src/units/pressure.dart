class Pressure implements Comparable<Pressure> {
  /*
   * The value of this Pressure object in inHg.
   */
  final double _pressure;

  ///inHG to mb
  //static const double _inHg_to_mb = 1;

  ///mb to inHg
  //static const double _mb_to_inHg = 1;

  ///inHg to hPa
  static const double _inHg_to_hPa = 33.86398;

  ///hPa to inHg
  static const double _hPa_to_inHg = 1 / 33.86398;
  //static const double _hPa_to_mb = 1 / 33.86398;

  Pressure.fromInHg({double value = 0.0}) : _pressure = value;
  Pressure.fromMb({double value = 0.0}) : _pressure = value;
  Pressure.fromHPa({double value = 0.0}) : _pressure = _hPa_to_inHg * value;

  double get inMb => _returnValue(_pressure);
  double get inInHg => _returnValue(_pressure);
  double get inHPa => _returnValue(_inHg_to_hPa * _pressure);

  double _returnValue(num value) => double.parse(value.toStringAsFixed(2));

  /**
     * Compares this Pressure to [other], returning zero if the values are equal.
     *
     * Returns a negative integer if this `Pressure` is shorter than
     * [other], or a positive integer if it is longer.
     *
     */
  int compareTo(Pressure other) => _pressure.compareTo(other._pressure);
}
