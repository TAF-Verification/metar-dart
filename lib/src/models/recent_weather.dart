import 'package:metar_dart/src/models/weather.dart';
import 'package:metar_dart/src/models/descriptors.dart';

class RecentWeather extends Group {
  Description _description = Description(null);
  Precipitation _precipitation = Precipitation(null);
  Obscuration _obscuration = Obscuration(null);
  Other _other = Other(null);

  RecentWeather(String? code, RegExpMatch? match) : super(code) {
    if (match != null) {
      _description = Description(match.namedGroup('descrip'));
      _precipitation = Precipitation(match.namedGroup('precip'));
      _obscuration = Obscuration(match.namedGroup('obsc'));
      _other = Other(match.namedGroup('other'));
    }
  }

  @override
  String toString() {
    var string = '${description != null ? " $description" : ""}'
        '${precipitation != null ? " $precipitation" : ""}'
        '${obscuration != null ? " $obscuration" : ""}'
        '${other != null ? " $other" : ""}';

    return string.trim();
  }

  String? get description => _description.value;
  String? get precipitation => _precipitation.value;
  String? get obscuration => _obscuration.value;
  String? get other => _other.value;
}
