import 'dart:async';
import 'package:flutter/material.dart';
import '../core/utils/persistence_service.dart';
import '../models/session.dart';

/// SprintProvider manages the ultradian focus sprint cycle.
///
/// LIFECYCLE AWARE: State is persisted and restored across app restarts.
/// When the app is killed during a sprint, it will resume from where it left off.
class SprintProvider with ChangeNotifier {
  final PersistenceService _persistence;

  Timer? _timer;
  Duration _timeLeft = const Duration(minutes: 90);
  Duration _totalDuration = const Duration(minutes: 90);
  SessionState _sessionState = SessionState.idle;
  bool _isRunning = false;
  DateTime? _sprintStartTime;

  SprintProvider(this._persistence) {
    _restoreState();
  }

  /// Restore state from persistence on startup
  void _restoreState() {
    final savedState = _persistence.sprintState;
    final savedTimeLeft = _persistence.sprintTimeLeftSeconds;
    final savedStartTime = _persistence.sprintStartTime;

    if (savedState == 'focus' && savedTimeLeft > 0) {
      // Resume interrupted sprint
      _sessionState = SessionState.focus;
      _isRunning = false; // Will be started when user returns to sprint screen

      // Calculate how much time has passed since app was closed
      if (savedStartTime != null) {
        final startTime = DateTime.tryParse(savedStartTime);
        if (startTime != null) {
          final elapsed = DateTime.now().difference(startTime);
          final originalTimeLeft = Duration(seconds: savedTimeLeft);
          final adjustedTimeLeft = originalTimeLeft - elapsed;

          if (adjustedTimeLeft.isNegative || adjustedTimeLeft.inSeconds <= 0) {
            // Sprint would have completed while app was closed
            _sessionState = SessionState.recovery;
            _timeLeft = Duration.zero;
            _persistence.setSprintState('recovery');
          } else {
            _timeLeft = adjustedTimeLeft;
          }
        } else {
          _timeLeft = Duration(seconds: savedTimeLeft);
        }
      } else {
        _timeLeft = Duration(seconds: savedTimeLeft);
      }

      debugPrint('🔄 Sprint restored: ${_timeLeft.inMinutes}min remaining');
    } else if (savedState == 'recovery') {
      _sessionState = SessionState.recovery;
      _timeLeft = Duration.zero;
    } else {
      _sessionState = SessionState.idle;
    }

    notifyListeners();
  }

  bool get isRunning => _isRunning;
  Duration get timeLeft => _timeLeft;
  Duration get totalDuration => _totalDuration;
  SessionState get sessionState => _sessionState;

  /// Set the sprint duration based on user's mode selection
  void setDuration(Duration duration) {
    _totalDuration = duration;
    _timeLeft = duration;
  }

  /// Start a new sprint or resume an interrupted one
  void startSprint({Duration? duration}) {
    if (duration != null) {
      _totalDuration = duration;
      _timeLeft = duration;
    } else if (_sessionState == SessionState.focus && _timeLeft.inSeconds > 0) {
      // Resuming interrupted sprint - keep existing time
    } else {
      _timeLeft = _totalDuration;
    }

    _isRunning = true;
    _sessionState = SessionState.focus;
    _sprintStartTime = DateTime.now();
    _timer?.cancel();

    // Persist state
    _persistence.setSprintState('focus');
    _persistence.setSprintTimeLeftSeconds(_timeLeft.inSeconds);
    _persistence.setSprintStartTime(_sprintStartTime!.toIso8601String());

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft.inSeconds > 0) {
        _timeLeft -= const Duration(seconds: 1);

        // Persist every 10 seconds to reduce writes
        if (_timeLeft.inSeconds % 10 == 0) {
          _persistence.setSprintTimeLeftSeconds(_timeLeft.inSeconds);
        }

        notifyListeners();
      } else {
        completeSprint();
      }
    });

    notifyListeners();
    debugPrint('▶️ Sprint started: ${_timeLeft.inMinutes}min');
  }

  /// Called when sprint timer reaches zero
  void completeSprint() {
    _isRunning = false;
    _sessionState = SessionState.recovery;
    _timer?.cancel();

    _persistence.setSprintState('recovery');
    _persistence.setSprintTimeLeftSeconds(0);
    _persistence.setSprintStartTime(null);
    _persistence.setLastSprintTimestamp(DateTime.now().toIso8601String());

    notifyListeners();
    debugPrint('✅ Sprint completed');
  }

  /// Pause the sprint (when app goes to background)
  void pauseSprint() {
    if (!_isRunning) return;

    _isRunning = false;
    _timer?.cancel();

    _persistence.setSprintTimeLeftSeconds(_timeLeft.inSeconds);
    _persistence.setSprintStartTime(DateTime.now().toIso8601String());

    debugPrint('⏸️ Sprint paused: ${_timeLeft.inMinutes}min remaining');
  }

  /// Resume the sprint (when app returns to foreground)
  void resumeSprint() {
    if (_sessionState != SessionState.focus || _timeLeft.inSeconds <= 0) return;

    _isRunning = true;
    _sprintStartTime = DateTime.now();
    _timer?.cancel();

    _persistence.setSprintStartTime(_sprintStartTime!.toIso8601String());

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft.inSeconds > 0) {
        _timeLeft -= const Duration(seconds: 1);

        if (_timeLeft.inSeconds % 10 == 0) {
          _persistence.setSprintTimeLeftSeconds(_timeLeft.inSeconds);
        }

        notifyListeners();
      } else {
        completeSprint();
      }
    });

    debugPrint('▶️ Sprint resumed: ${_timeLeft.inMinutes}min remaining');
  }

  /// Stop the sprint completely
  void stopSprint() {
    _isRunning = false;
    _timer?.cancel();

    _persistence.setSprintState('idle');
    _persistence.setSprintTimeLeftSeconds(0);
    _persistence.setSprintStartTime(null);

    notifyListeners();
  }

  /// Reset to initial state
  void reset() {
    stopSprint();
    _timeLeft = _totalDuration;
    _sessionState = SessionState.idle;
    _sprintStartTime = null;

    notifyListeners();
  }

  /// Mark recovery as complete
  void completeRecovery() {
    _sessionState = SessionState.idle;
    _persistence.setSprintState('idle');
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
