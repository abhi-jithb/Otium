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

  DateTime? _lastInteractionTime;

  /// Increments friction based on user interaction (taps/clicks).
  /// Uses Time-Weighted Density: Rapid taps (<500ms) count more.
  void incrementFriction() {
    final now = DateTime.now();
    int frictionPoints = 1;

    if (_lastInteractionTime != null) {
      final difference = now.difference(_lastInteractionTime!).inMilliseconds;
      
      if (difference < 500) {
        // Rapid fire interaction (e.g. doomscrolling or panic tapping)
        frictionPoints = 3;
      } else if (difference < 1500) {
        // Moderate pace
        frictionPoints = 2;
      }
    }

    _lastInteractionTime = now;
    _interactionCount += frictionPoints;
    _persistence.setDailyInteractionCount(_interactionCount);
    _checkThreshold();
  }

  /// Specialized friction for when a user switches away from the focus app.
  /// Context switching is the highest cost (Task Switching Penalty).
  void reportAppSwitch() {
    // App switching is heavily penalized as a sign of distraction
    int switchPenalty = 10;
    
    // Check if this is a "Rapid Switch" (e.g. within 10s of last interaction)
    if (_lastInteractionTime != null) {
       final difference = DateTime.now().difference(_lastInteractionTime!).inSeconds;
       if (difference < 10) {
         switchPenalty = 20; // Rapid context switching is fatal to focus
       }
    }
    
    _interactionCount += switchPenalty;
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
