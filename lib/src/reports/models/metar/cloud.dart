part of reports;

mixin MetarCloudMixin on StringAttributeMixin {
  final CloudList _clouds = CloudList();

  void _handleCloud(String group) {
    final match = MetarRegExp.CLOUD.firstMatch(group);
    final cloud = Cloud.fromMetar(group, match);
    _clouds.add(cloud);

    _concatenateString(cloud);
  }

  /// Get the cloud groups data of the METAR.
  CloudList get clouds => _clouds;
}
