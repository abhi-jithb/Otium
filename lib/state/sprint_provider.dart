import 'dart:async';
import 'package:flutter/material.dart';
import '../core/constants/durations.dart';

class SprintProvider with ChangeNotifier {
  bool _isRunning = false;
  Duration _timeLeft = AppDurations.focusSprint;
  Timer? _timer;

  bool get isRunning => _isRunning;
  Duration get timeLeft => _timeLeft;

  void startSprint() {
    _isRunning = true;
    _timeLeft = AppDurations.focusSprint;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft.inSeconds > 0) {
        _timeLeft -= const Duration(seconds: 1);
        notifyListeners();
      } else {
        stopSprint();
      }
    });
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
    notifyListeners();
  }
}
