import 'package:metar_dart/src/models/descriptors.dart';
import 'package:metar_dart/src/models/visibility.dart' show Distance;
import 'package:metar_dart/src/models/weather.dart';
import 'package:metar_dart/src/utils/utils.dart'
    show Conversions, SkyTranslations, handleValue;

class Cover extends Item {
  Cover(String? code) : super(SkyTranslations.SKY_COVER[code]);
}

class Cloud extends Item {
  Cloud(String? code) : super(SkyTranslations.CLOUD_TYPE[code]);
}

class CloudLayer extends Group {
  Cover _cover = Cover(null);
  Distance _height = Distance(null);
  Cloud _cloud = Cloud(null);

  CloudLayer(String? code, RegExpMatch? match) : super(code) {
    if (match != null) {
      _cover = Cover(match.namedGroup('cover'));
      _cloud = Cloud(match.namedGroup('cloud'));

      final height = match.namedGroup('height');
      if (height != '///' && height != null) {
        final heightDouble = double.parse(height.toString());
        _height = Distance('${heightDouble * 100.0 * Conversions.FT_TO_M}');
      }
    }
  }

  @override
  String toString() {
    if (_cloud.value != null && _height.distance != null) {
      return '$cover at $heightInFeet feet of $cloud';
    } else if (_height.distance != null) {
      return '$cover at $heightInFeet feet';
    } else if (_cover.value == 'clear') {
      return '$cover';
    } else {
      return '$cover at undefined height';
    }
  }

  String? get cover => _cover.value;
  String? get cloud => _cloud.value;

  double? get heightInMeters => _height.distance;
  double? get heightInKilometers =>
      handleValue(_height.distance, Conversions.M_TO_KM);
  double? get heightInSeaMiles =>
      handleValue(_height.distance, Conversions.M_TO_SMI);
  double? get heightInFeet =>
      handleValue(_height.distance, Conversions.M_TO_FT);
}

class Sky {
  CloudLayer _first = CloudLayer(null, null);
  CloudLayer _second = CloudLayer(null, null);
  CloudLayer _third = CloudLayer(null, null);
  CloudLayer _fourth = CloudLayer(null, null);
  final List<CloudLayer> _layersList = <CloudLayer>[];
  int _count = 0;

  Sky();

  void add(CloudLayer layer) {
    if (_count >= 3) {
      throw RangeError("Can't set more than four cloud ayers");
    }

    if (_count == 0) {
      _first = layer;
    } else if (_count == 1) {
      _second = layer;
    } else if (_count == 2) {
      _third = layer;
    } else {
      _fourth = layer;
    }

    _layersList.add(layer);
    _count++;
  }

  @override
  String toString() {
    return _layersList.join(' | ');
  }

  int get length => _layersList.length;
  List<String> get codes {
    final list = _layersList.map((e) => e.code.toString()).toList();

    return list;
  }

  Iterable<CloudLayer> get iter => _layersList.map((e) => e);
  List<CloudLayer> get toList => _layersList;
  CloudLayer get first => _first;
  CloudLayer get second => _second;
  CloudLayer get third => _third;
  CloudLayer get fourth => _fourth;
}
