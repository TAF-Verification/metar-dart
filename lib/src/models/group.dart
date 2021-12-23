part of models;

abstract class Group {
  late final String? _code;

  Group(String? code) {
    if (code != null) {
      code = code.replaceAll('_', ' ');
    }

    _code = code;
  }

  /// Get the code of the group.
  String? get code => _code;
}
