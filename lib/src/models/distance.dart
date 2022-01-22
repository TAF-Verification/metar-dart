part of models;

/// Basic structure for distance attributes.
class Distance extends Numeric {
  Distance(String? code) : super(null) {
    code ??= '//\//';

    if (code == '9999') {
      code = '10000';
    }

    final _distance = double.tryParse(code);
    _value = _distance;
  }

  @override
  String toString() {
    if (_value != null) {
      return super.toString() + ' m';
    }

    return super.toString();
  }
}
