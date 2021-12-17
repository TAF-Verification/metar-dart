part of models;

abstract class Group {
  final String? _code;

  Group(this._code);

  /// Get the code of the group.
  String? get code => _code;
}
