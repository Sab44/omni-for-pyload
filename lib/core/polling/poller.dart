import 'dart:async';

/// Polls data: fetches right away, then again [interval] after each fetch
/// finished, so requests never overlap.
///
/// Polling runs while it is started and not paused. Starting/stopping is
/// what the owner wants polled (e.g. the selected tab), pausing/resuming is
/// whether its screen is visible; both can change independently.
///
/// Results of a fetch that was overtaken by [stop], [pause], [refresh],
/// [resume] or [dispose] are dropped, so [onData] and [onError] are never
/// called after [dispose].
class Poller<T> {
  final Duration interval;
  final Future<T> Function() fetch;
  final void Function(T data) onData;
  final void Function(Object error, StackTrace stackTrace) onError;

  /// Errors for which the next fetch starts right away instead of after
  /// [interval]
  final bool Function(Object error)? retryNowOn;

  Timer? _timer;

  /// Incremented whenever running fetches become outdated
  int _generation = 0;
  bool _isStarted = false;
  bool _isPaused = false;
  bool _isDisposed = false;

  Poller({
    required this.interval,
    required this.fetch,
    required this.onData,
    required this.onError,
    this.retryNowOn,
  });

  bool get _isRunning => _isStarted && !_isPaused && !_isDisposed;

  /// Start polling, fetching right away unless paused
  void start() {
    _isStarted = true;
    _restart();
  }

  /// Stop polling until the next [start]
  void stop() {
    _isStarted = false;
    _cancel();
  }

  /// Suspend polling until [resume]
  void pause() {
    _isPaused = true;
    _cancel();
  }

  /// Continue polling after [pause], fetching right away if started
  void resume() {
    _isPaused = false;
    _restart();
  }

  /// Fetch right away if polling runs, e.g. after the data was changed
  void refresh() => _restart();

  void dispose() {
    _isDisposed = true;
    _cancel();
  }

  void _restart() {
    _cancel();
    if (_isRunning) _fetch(_generation);
  }

  void _cancel() {
    _generation++;
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _fetch(int generation) async {
    var retryNow = false;
    try {
      final data = await fetch();
      if (generation != _generation) return;
      onData(data);
    } catch (error, stackTrace) {
      if (generation != _generation) return;
      onError(error, stackTrace);
      retryNow = retryNowOn?.call(error) ?? false;
    }
    // onData / onError may have stopped or restarted polling
    if (generation != _generation) return;
    if (retryNow) {
      _fetch(generation);
    } else {
      _timer = Timer(interval, () => _fetch(generation));
    }
  }
}
