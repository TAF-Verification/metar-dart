import 'package:metar_dart/src/models/descriptors.dart';
import 'package:metar_dart/src/utils/translations.dart';
import 'package:metar_dart/src/utils/utils.dart';

abstract class Item {
  final String? _value;

  Item(this._value);

  @override
  String toString() {
    if (_value != null) {
      return _value.toString();
    }

    return '';
  }

  String? get value => _value;
}

class Intensity extends Item {
  Intensity(String? code) : super(SkyTranslations.WEATHER_INT[code]);
}

class Description extends Item {
  Description(String? code) : super(SkyTranslations.WEATHER_DESC[code]);
}

class Precipitation extends Item {
  Precipitation(String? code) : super(SkyTranslations.WEATHER_PREC[code]);
}

class Obscuration extends Item {
  Obscuration(String? code) : super(SkyTranslations.WEATHER_OBSC[code]);
}

class Other extends Item {
  Other(String? code) : super(SkyTranslations.WEATHER_OTHER[code]);
}

class Weather extends Group {
  Intensity _intensity = Intensity(null);
  Description _description = Description(null);
  Precipitation _precipitation = Precipitation(null);
  Obscuration _obscuration = Obscuration(null);
  Other _other = Other(null);

  Weather(String? code, RegExpMatch? match) : super(code) {
    if (match != null) {
      _intensity = Intensity(match.namedGroup('intensity'));
      _description = Description(match.namedGroup('descrip'));
      _precipitation = Precipitation(match.namedGroup('precip'));
      _obscuration = Obscuration(match.namedGroup('obsc'));
      _other = Other(match.namedGroup('other'));
    }
  }

  @override
  String toString() {
    var string = '${intensity != null ? "$intensity" : ""}'
        '${description != null ? " $description" : ""}'
        '${precipitation != null ? " $precipitation" : ""}'
        '${obscuration != null ? " $obscuration" : ""}'
        '${other != null ? " $other" : ""}';

    return string.trim();
  }

  String? get intensity => _intensity.value;
  String? get description => _description.value;
  String? get precipitation => _precipitation.value;
  String? get obscuration => _obscuration.value;
  String? get other => _other.value;
}

class Weathers {
  Weather _first = Weather(null, null);
  Weather _second = Weather(null, null);
  Weather _third = Weather(null, null);
  final List<Weather> _weathersList = <Weather>[];
  int _count = 0;

  Weathers();

  void add(Weather weather) {
    if (_count >= 3) {
      throw RangeError("Can't set more than three weathers");
    }

    if (_count == 0) {
      _first = weather;
    } else if (_count == 1) {
      _second = weather;
    } else {
      _third = weather;
    }

    _weathersList.add(weather);
    _count++;
  }

  @override
  String toString() {
    return _weathersList.join(' | ');
  }

  int get length => _weathersList.length;
  List<String> get codes {
    final list = _weathersList.map((e) => e.code.toString()).toList();

    return list;
  }

  Iterable<Weather> get iter => _weathersList.map((e) => e);
  List<Weather> get toList => _weathersList;
  Weather get first => _first;
  Weather get second => _second;
  Weather get third => _third;
}
