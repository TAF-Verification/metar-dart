part of reports;

class Cancelled extends Group {
  bool _isCancelled = false;

  Cancelled(String? code) : super(code) {
    if (code != null) {
      _isCancelled = true;
    }
  }

  @override
  String toString() {
    if (_isCancelled) {
      return 'cancelled';
    }

    return '';
  }

  /// Get if the TAF is cancelled.
  bool get isCancelled => _isCancelled;

  @override
  Map<String, Object?> asMap() {
    final map = super.asMap();
    map.addAll({'is_cancelled': isCancelled});
    return map;
  }
}
