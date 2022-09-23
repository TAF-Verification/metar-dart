part of reports;

const FLIGHT_RULES = <String, List<double>>{
  'VLIFR': [60.0, 800.0],
  'LIFR': [150.0, 1600.0],
  'IFR': [300.0, 5000.0],
  'MVFR': [900.0, 8000.0],
  'VFR': [40000.0, 20000.0],
};

/// Mixin to add flight rules to the report or forecast.
/// The class must have MetarPrevailingMixin and MetarCloudMixin
/// implemented.
mixin FlightRulesMixin on MetarPrevailingMixin, MetarCloudMixin {
  /// Get the flight rules of the report or forecast.
  String? get flightRules {
    final prevailing = _prevailing.inMeters;
    double? ceiling;
    if (_clouds.length > 0) {
      for (final cloud in _clouds.items) {
        if (<String>['broken', 'overcast', 'indefinite ceiling']
            .contains(cloud.cover)) {
          ceiling = cloud.heightInMeters;
          break;
        }
      }
    }

    if (prevailing == null && ceiling == null) {
      return null;
    }

    for (final flightRule in FLIGHT_RULES.keys) {
      final rules = FLIGHT_RULES[flightRule]!;
      if (prevailing != null && ceiling != null) {
        if (ceiling < rules[0] || prevailing < rules[1]) {
          return flightRule;
        }
      } else if (prevailing != null && ceiling == null) {
        if (prevailing < rules[1]) {
          return flightRule;
        }
      } else if (prevailing == null && ceiling != null) {
        if (ceiling < rules[0]) {
          return flightRule;
        }
      } else {
        return 'VFR';
      }
    }

    return null;
  }
}
