part of models;

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
}
