import '../core/utils/persistence_service.dart';
import '../models/user_profile.dart';

/// Adaptive learning engine that adjusts thresholds based on observed patterns
class AdaptationEngine {
  final PersistenceService _persistence;

  AdaptationEngine(this._persistence);

  /// Check if adaptation is needed based on yesterday's data
  Future<CognitiveProfile?> checkDailyAdaptation(
      CognitiveProfile currentProfile) async {
    final overloadCount = _persistence.overloadEventsCount;
    final lastSprintTimestamp = _persistence.lastSprintTimestamp;

    // Check if we have data from a previous day
    if (lastSprintTimestamp == null) return null;

    final lastSprint = DateTime.tryParse(lastSprintTimestamp);
    if (lastSprint == null) return null;

    final daysSinceLastSprint = DateTime.now().difference(lastSprint).inDays;

    // Only adapt if it's a new day
    if (daysSinceLastSprint < 1) return null;

    // Adaptation Rule 1: Too many overloads → reduce sprint duration
    if (overloadCount > 2) {
      return CognitiveProfile(
        interactionThreshold: currentProfile.interactionThreshold,
        sprintDuration: Duration(
          minutes: (currentProfile.sprintDuration.inMinutes - 10)
              .clamp(30, 120),
        ),
        recoveryDuration: currentProfile.recoveryDuration,
        description:
            'Adapted: Sprint reduced due to frequent overload (${overloadCount}x)',
      );
    }

    // Adaptation Rule 2: No overloads → slightly increase threshold
    if (overloadCount == 0) {
      return CognitiveProfile(
        interactionThreshold:
            (currentProfile.interactionThreshold + 5).clamp(20, 60),
        sprintDuration: currentProfile.sprintDuration,
        recoveryDuration: currentProfile.recoveryDuration,
        description: 'Adapted: Threshold increased (no overload detected)',
      );
    }

    return null; // No adaptation needed
  }

  /// Reset daily counters (call this after adaptation check)
  Future<void> resetDailyCounters() async {
    await _persistence.setDailyInteractionCount(0);
    // Note: We keep overloadEventsCount for historical tracking
  }

  /// Record that a sprint just completed
  Future<void> recordSprintCompletion() async {
    await _persistence.setLastSprintTimestamp(DateTime.now().toIso8601String());
  }
}
