import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

import 'lookup_service.dart';

/// Whether the current connection may be used for lookups.
Future<bool> networkAllowed({required bool wifiOnly}) async {
  final c = await Connectivity().checkConnectivity();
  if (c.contains(ConnectivityResult.none) || c.isEmpty) return false;
  if (!wifiOnly) return true;
  return c.contains(ConnectivityResult.wifi) || c.contains(ConnectivityResult.ethernet);
}

/// Drains the persistent queue one song at a time. Safe to call from several places:
/// a second call while a run is active does nothing.
class LookupRunner {
  LookupRunner(this.service, {required this.enabled, required this.wifiOnly, Future<bool> Function(bool wifiOnly)? network})
      : _network = network ?? ((w) => networkAllowed(wifiOnly: w));

  final LookupService service;
  final bool Function() enabled;
  final bool Function() wifiOnly;
  final Future<bool> Function(bool wifiOnly) _network;

  StreamSubscription<List<ConnectivityResult>>? _connectivity;
  bool _running = false;
  bool _stop = false;
  Timer? _retryTimer;

  bool get running => _running;

  /// Processes due songs until none are left, the budget is used up, or lookups are switched off.
  /// Returns true when the queue has nothing due any more.
  Future<bool> run({Duration? budget}) async {
    if (_running) return false;
    _running = true;
    _stop = false;
    _retryTimer?.cancel();
    final started = DateTime.now();
    try {
      while (!_stop && enabled()) {
        if (budget != null && DateTime.now().difference(started) > budget) return false;
        if (!await _network(wifiOnly())) return false;
        final outcome = await service.processNext();
        if (outcome == StepOutcome.idle) return true;
        if (outcome == StepOutcome.waiting) {
          await _scheduleRetry();
          return true;
        }
      }
      return false;
    } finally {
      _running = false;
    }
  }

  /// Restarts the queue when the connection changes, so a run that gave up for lack of a
  /// (Wi-Fi) connection continues as soon as one is there. Safe to call repeatedly.
  void watchConnectivity({Stream<List<ConnectivityResult>>? changes}) {
    _connectivity ??= (changes ?? Connectivity().onConnectivityChanged).listen((_) {
      if (!_running && enabled()) unawaited(run());
    });
  }

  Future<void> _scheduleRetry() async {
    final next = await service.db.earliestRetry();
    if (next == null) return;
    _retryTimer?.cancel();
    final delay = next.difference(service.now());
    _retryTimer = Timer(delay > Duration.zero ? delay : const Duration(seconds: 1), () => unawaited(run()));
  }

  void stop() {
    _stop = true;
    _retryTimer?.cancel();
  }

  void dispose() {
    stop();
    _connectivity?.cancel();
    _connectivity = null;
  }
}
