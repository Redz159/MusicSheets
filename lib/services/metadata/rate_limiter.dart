/// Spaces calls at least [gap] apart. MusicBrainz allows about one request per second.
class RateLimiter {
  RateLimiter(this.gap, {DateTime Function()? now, Future<void> Function(Duration)? sleep})
      : _now = now ?? DateTime.now,
        _sleep = sleep ?? Future.delayed;

  final Duration gap;
  final DateTime Function() _now;
  final Future<void> Function(Duration) _sleep;
  DateTime? _next;
  Future<void> _tail = Future.value();

  /// Completes when the caller may send its request. Calls are served in order.
  Future<void> wait() {
    final turn = _tail.then((_) async {
      final next = _next;
      if (next != null) {
        final delay = next.difference(_now());
        if (delay > Duration.zero) await _sleep(delay);
      }
      _next = _now().add(gap);
    });
    _tail = turn.catchError((_) {});
    return turn;
  }
}
