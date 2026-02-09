import 'package:flutter/material.dart';

class FatigueProvider with ChangeNotifier {
  int _interactionCount = 0;
  final int _threshold = 40; // Example threshold
  bool _isFatigued = false;

  int get interactionCount => _interactionCount;
  bool get isFatigued => _isFatigued;

  void trackInteraction() {
    _interactionCount++;
    if (_interactionCount > _threshold) {
      _isFatigued = true;
    }
    notifyListeners();
  }

  void reset() {
    _interactionCount = 0;
    _isFatigued = false;
    notifyListeners();
  }
}
