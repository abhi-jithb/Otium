import 'package:flutter/material.dart';
import '../core/utils/persistence_service.dart';
import '../models/user_profile.dart';

class FatigueProvider with ChangeNotifier {
  final PersistenceService _persistence;
  int _interactionCount = 0;
  int _threshold = 40; // Default, will be updated by profile
  bool _isFatigued = false;

  FatigueProvider(this._persistence) {
    _interactionCount = _persistence.dailyInteractionCount;
  }

  int get interactionCount => _interactionCount;
  bool get isFatigued => _isFatigued;
  int get threshold => _threshold;

  /// Update threshold based on user's cognitive profile
  void updateProfile(UserProfile profile) {
    _threshold = profile.cognitiveProfile.interactionThreshold;
    // Re-check threshold with new value
    _checkThreshold();
  }

  /// Increments friction based on user interaction (taps/clicks).
  void incrementFriction() {
    _interactionCount++;
    _persistence.setDailyInteractionCount(_interactionCount);
    _checkThreshold();
  }

  /// Specialized friction for when a user switches away from the focus app.
  void reportAppSwitch() {
    // App switching is heavily penalized as a sign of distraction
    _interactionCount += 10;
    _persistence.setDailyInteractionCount(_interactionCount);
    _checkThreshold();
  }

  /// Manual override to trigger intervention (e.g., if logic detects compulsive patterns)
  void triggerManualIntervention() {
    _isFatigued = true;
    _persistence.incrementOverloadEvents();
    notifyListeners();
  }

  void _checkThreshold() {
    if (_interactionCount > _threshold) {
      if (!_isFatigued) {
        _persistence.incrementOverloadEvents();
      }
      _isFatigued = true;
    }
    notifyListeners();
  }

  void reset() {
    _interactionCount = 0;
    _persistence.setDailyInteractionCount(0);
    _isFatigued = false;
    notifyListeners();
  }

  // Soft reset after regulation (keeps count but clears fatigue state)
  void clearFatigue() {
    _isFatigued = false;
    notifyListeners();
  }
}
