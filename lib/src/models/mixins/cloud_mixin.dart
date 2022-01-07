part of models;

/// Mixin to add cloud list attribute to the report.
mixin CloudMixin on Report {
  final _clouds = CloudList();

  void _handleCloud(String group) {
    final match = RegularExpresions.CLOUD.firstMatch(group);
    final _cloud = CloudLayer(group, match);
    _clouds.add(_cloud);

    _concatenateString(_cloud);
  }

  /// Get the cloud data of the report.
  CloudList get clouds => _clouds;
}
