part of reports;

/// Mixin to add _verify_cavok method to the report.
mixin ShouldBeCavokMixin
    on MetarPrevailingMixin, MetarWeatherMixin, MetarCloudMixin {
  /// Analyses the conditions for CAVOK in the report. Returns `true` if CAVOK
  /// should be reported, `false` if not or if there is no data to make a
  /// complete analysis.
  bool shouldBeCavok() {
    if (weathers.length > 0) return false;

    if (clouds.ceiling) return false;

    if (prevailingVisibility.inMeters == null || clouds.length == 0) {
      return false;
    }

    if (prevailingVisibility.inMeters != null &&
        prevailingVisibility.inMeters! < 10000.0) return false;

    for (var c in clouds.items) {
      if (c.cover == 'indefinite ceiling') return false;

      if (c.cloudType == 'cumulonimbus' || c.cloudType == 'towering cumulus') {
        return false;
      }

      if (c.heightInFeet != null && c.heightInFeet! < 4999.99999999) {
        return false;
      }
    }

    return true;
  }
}
