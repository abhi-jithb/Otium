import 'dart:collection';
import 'package:flutter/material.dart';
import '../core/utils/persistence_service.dart';
import '../core/utils/intervention_service.dart';
import '../models/user_profile.dart';

/// Represents a single interaction event with its weight and timestamp.
/// Used for rolling window friction calculation.
class InteractionEvent {
  final DateTime timestamp;
  final int weight;
  final String type;

  InteractionEvent({
    required this.timestamp,
    required this.weight,
    required this.type,
  });

  bool isExpired(Duration windowDuration) {
    return DateTime.now().difference(timestamp) > windowDuration;
  }

  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.toIso8601String(),
    'weight': weight,
    'type': type,
  };

  factory InteractionEvent.fromJson(Map<String, dynamic> json) {
    return InteractionEvent(
      timestamp: DateTime.parse(json['timestamp']),
      weight: json['weight'],
      type: json['type'],
    );
  }
}

/// FatigueProvider implements context-aware, weighted interaction sensing.
///
/// Core Philosophy:
/// - Cognitive overload manifests as FRAGMENTATION, not duration
/// - Rapid context switching signals nervous-system strain
/// - We detect loss of cognitive continuity, NOT content
///
/// Friction Weights:
/// - Simple tap/scroll = 1 (normal interaction)
/// - Rapid tap (<500ms) = 2 (slight agitation)
/// - Scroll gesture = 1 per 500ms of scrolling
/// - App switch = 3 (context break)
/// - Rapid app switch (<10s) = 5 (cognitive fragmentation)
///
/// LIFECYCLE AWARE: State is persisted and restored across app restarts.
class FatigueProvider with ChangeNotifier {
  final PersistenceService _persistence;
  final InterventionService _interventionService = InterventionService();

  /// Rolling window of interaction events (60-second window)
  final Queue<InteractionEvent> _interactionWindow = Queue<InteractionEvent>();

  /// Window duration for friction calculation
  static const Duration _windowDuration = Duration(seconds: 60);

  /// Adaptive threshold based on user's cognitive profile
  int _threshold = 40;

  /// Whether cognitive overload has been detected
  bool _isFatigued = false;

  /// Last interaction timestamp for detecting rapid interactions
  DateTime? _lastInteractionTime;

  /// Last app switch timestamp for detecting rapid context switching
  DateTime? _lastAppSwitchTime;

  /// Tracks ongoing scroll for continuous gesture detection
  DateTime? _scrollStartTime;
  bool _isScrolling = false;

  /// Background state tracking
  DateTime? _backgroundedAt;
  bool _isInBackground = false;

  FatigueProvider(this._persistence) {
    _restoreState();
  }

  /// Restore state from persistence on startup
  void _restoreState() {
    _isFatigued = _persistence.isFatigued;
    _threshold = _persistence.threshold ?? 40;

    // Check if there's stale fatigue state from a previous session
    final lastActive = _persistence.timeSinceLastActive;
    if (lastActive != null && lastActive.inMinutes > 30) {
      // If app was inactive for 30+ minutes, clear fatigue state
      // User has likely already recovered naturally
      _isFatigued = false;
      _persistence.setFatigued(false);
    }

    notifyListeners();
  }

  /// Current friction score (sum of weights in rolling window)
  int get frictionScore {
    _pruneExpiredEvents();
    return _interactionWindow.fold(0, (sum, event) => sum + event.weight);
  }

  /// Number of events in current window (for debugging/display)
  int get interactionCount => _interactionWindow.length;

  bool get isFatigued => _isFatigued;
  int get threshold => _threshold;
  bool get isInBackground => _isInBackground;

  /// Update threshold based on user's cognitive profile
  void updateProfile(UserProfile profile) {
    _threshold = profile.cognitiveProfile.interactionThreshold;
    _persistence.setThreshold(_threshold);
    _checkThreshold();
  }

  /// Remove events that have fallen outside the 60-second window
  void _pruneExpiredEvents() {
    while (_interactionWindow.isNotEmpty &&
        _interactionWindow.first.isExpired(_windowDuration)) {
      _interactionWindow.removeFirst();
    }
  }

  /// Records a simple interaction (tap, scroll, etc.)
  ///
  /// Weight calculation:
  /// - Normal tap: weight 1
  /// - Rapid tap (<500ms since last): weight 2
  ///
  /// Rapid tapping indicates slight agitation but is not as
  /// cognitively costly as context switching.
  void incrementFriction() {
    if (_isInBackground) return; // Don't count interactions while backgrounded

    final now = DateTime.now();
    int weight = 1;
    String type = 'tap';

    if (_lastInteractionTime != null) {
      final gap = now.difference(_lastInteractionTime!).inMilliseconds;

      if (gap < 500) {
        // Rapid fire interaction (agitation signal)
        weight = 2;
        type = 'rapid_tap';
      }
    }

    _lastInteractionTime = now;
    _addEvent(InteractionEvent(timestamp: now, weight: weight, type: type));
    _persistence.incrementInteractionCount();
  }

  /// Records scroll start - called when user begins scrolling
  void onScrollStart() {
    if (_isInBackground) return;

    _scrollStartTime = DateTime.now();
    _isScrolling = true;
  }

  /// Records scroll end - calculates scroll duration and adds friction
  ///
  /// Weight calculation:
  /// - 1 point per 500ms of continuous scrolling
  /// - Max 5 points per scroll gesture (prevents runaway from long scrolls)
  void onScrollEnd() {
    if (!_isScrolling || _scrollStartTime == null) return;

    final duration = DateTime.now().difference(_scrollStartTime!);
    _isScrolling = false;
    _scrollStartTime = null;

    // Calculate weight based on scroll duration
    // 1 point per 500ms, max 5 points
    final weight = (duration.inMilliseconds / 500).clamp(1, 5).toInt();

    _addEvent(
      InteractionEvent(
        timestamp: DateTime.now(),
        weight: weight,
        type: 'scroll',
      ),
    );
    _persistence.incrementInteractionCount();
  }

  /// Records continuous scroll updates - for tracking scroll velocity
  /// Called periodically during scroll
  void onScrollUpdate() {
    if (_isInBackground || !_isScrolling) return;

    // Reset scroll start time to track continuous engagement
    _lastInteractionTime = DateTime.now();
  }

  /// Records an app switch event (user left and returned to Otium).
  ///
  /// Context switching is the PRIMARY signal of cognitive fragmentation.
  ///
  /// Weight calculation:
  /// - Normal app switch: weight 3
  /// - Rapid switch (<10s since last switch): weight 5
  ///
  /// Rapid context switching is the strongest indicator of nervous-system
  /// strain and loss of cognitive continuity.
  void reportAppSwitch() {
    final now = DateTime.now();
    int weight = 3;
    String type = 'app_switch';

    if (_lastAppSwitchTime != null) {
      final gap = now.difference(_lastAppSwitchTime!).inSeconds;

      if (gap < 10) {
        // Rapid context switching - cognitive fragmentation detected
        weight = 5;
        type = 'rapid_switch';
        debugPrint('⚠️ Rapid context switch detected (${gap}s gap)');
      }
    }

    _lastAppSwitchTime = now;
    _lastInteractionTime = now;
    _addEvent(InteractionEvent(timestamp: now, weight: weight, type: type));
  }

  /// Called when app enters background
  void onAppBackgrounded() {
    _isInBackground = true;
    _backgroundedAt = DateTime.now();
    _persistence.setLastActiveTime(DateTime.now().toIso8601String());

    // End any ongoing scroll
    if (_isScrolling) {
      onScrollEnd();
    }

    debugPrint('📱 App backgrounded');
  }

  /// Called when app returns to foreground
  void onAppForegrounded() {
    _isInBackground = false;

    if (_backgroundedAt != null) {
      final backgroundDuration = DateTime.now().difference(_backgroundedAt!);

      // If user was away for more than 10 seconds, count as app switch
      if (backgroundDuration.inSeconds > 10) {
        reportAppSwitch();
      }

      // If user was away for more than 30 minutes, consider them recovered
      if (backgroundDuration.inMinutes > 30 && _isFatigued) {
        clearFatigue();
        debugPrint(
          '🧘 Natural recovery detected (${backgroundDuration.inMinutes}min away)',
        );
      }
    }

    _backgroundedAt = null;
    _persistence.setLastActiveTime(DateTime.now().toIso8601String());
    debugPrint('📱 App foregrounded');
  }

  /// Adds an event to the rolling window and checks threshold
  void _addEvent(InteractionEvent event) {
    _pruneExpiredEvents();
    _interactionWindow.addLast(event);
    _checkThreshold();
  }

  /// Manual override to trigger intervention
  void triggerManualIntervention() {
    _isFatigued = true;
    _persistence.setFatigued(true);
    _persistence.incrementOverloadEvents();
    notifyListeners();
  }

  /// Checks if friction score exceeds threshold
  void _checkThreshold() {
    final score = frictionScore;

    if (score > _threshold && !_isFatigued) {
      _isFatigued = true;
      _persistence.setFatigued(true);
      _persistence.incrementOverloadEvents();
      _persistence.setFrictionScore(score);
      debugPrint(
        '🛑 Cognitive overload detected! Score: $score > Threshold: $_threshold',
      );

      // If app is in background, show system overlay intervention
      if (_isInBackground) {
        _showOverlayIntervention();
      }
    }

    notifyListeners();
  }

  /// Show system overlay intervention (works over other apps)
  Future<void> _showOverlayIntervention() async {
    if (_interventionService.isAndroid) {
      final shown = await _interventionService.showIntervention();
      if (shown) {
        debugPrint('🫁 Overlay intervention triggered over other apps');
      }
    }
  }

  /// Full reset (clears window and fatigue state)
  void reset() {
    _interactionWindow.clear();
    _lastInteractionTime = null;
    _lastAppSwitchTime = null;
    _isFatigued = false;
    _isScrolling = false;
    _scrollStartTime = null;

    _persistence.setFatigued(false);
    _persistence.setFrictionScore(0);

    notifyListeners();
  }

  /// Soft reset after regulation (clears fatigue but keeps some history)
  void clearFatigue() {
    _isFatigued = false;
    _persistence.setFatigued(false);

    // Clear half the window to give user a fresh start after recovery
    final eventsToKeep = _interactionWindow.length ~/ 2;
    while (_interactionWindow.length > eventsToKeep) {
      _interactionWindow.removeFirst();
    }

    _persistence.setFrictionScore(frictionScore);
    notifyListeners();
  }

  /// Returns a breakdown of current friction sources (for debugging)
  Map<String, int> get frictionBreakdown {
    _pruneExpiredEvents();
    final breakdown = <String, int>{};
    for (final event in _interactionWindow) {
      breakdown[event.type] = (breakdown[event.type] ?? 0) + event.weight;
    }
    return breakdown;
  }
}
