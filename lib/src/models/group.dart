/// Basic structure of a group in a aeronautical report from land stations.
abstract class Group {
  final String? _code;

  Group(this._code);

  @override
  String toString() {
    return _code.toString();
  }

  /// Get the length of the code of the group.
  int get length {
    if (_code == null) {
      return 0;
    }

    return _code!.length;
  }

  /// Get the code of the group.
  String? get code => _code;
}
