import 'dart:async';
import 'package:flutter/material.dart';
import '../core/constants/durations.dart';
import '../models/session.dart';

class SprintProvider with ChangeNotifier {
  bool _isRunning = false;
  Duration _timeLeft = AppDurations.focusSprint;
  Timer? _timer;
  SessionState _sessionState = SessionState.focus;

  bool get isRunning => _isRunning;
  Duration get timeLeft => _timeLeft;
  SessionState get sessionState => _sessionState;

  void startSprint() {
    _isRunning = true;
    _sessionState = SessionState.focus;
    _timeLeft = AppDurations.focusSprint;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft.inSeconds > 0) {
        _timeLeft -= const Duration(seconds: 1);
        notifyListeners();
      } else {
        completeSprint();
      }
    });
    notifyListeners();
  }

  void completeSprint() {
    _isRunning = false;
    _sessionState = SessionState.recovery;
    _timer?.cancel();
    notifyListeners();
  }

  void stopSprint() {
    _isRunning = false;
    _timer?.cancel();
    notifyListeners();
  }

  void reset() {
    stopSprint();
    _timeLeft = AppDurations.focusSprint;
    _sessionState = SessionState.focus;
    notifyListeners();
  }
}
