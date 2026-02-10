import 'persistence_service.dart';
import '../../models/user_profile.dart';

/// Adaptive learning engine that adjusts thresholds based on observed patterns
class AdaptationEngine {
  final PersistenceService _persistence;

  AdaptationEngine(this._persistence);

  /// Check if adaptation is needed based on yesterday's data
  Future<CognitiveProfile?> checkDailyAdaptation(
      CognitiveProfile currentProfile) async {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    
    // Prevent multiple adaptations per day
    if (_persistence.lastAdaptationDate == today) {
      return null;
    }

    // Check if we have data from a previous day
    // If no sprint has ever been recorded, we can't adapt
    final lastSprintTimestamp = _persistence.lastSprintTimestamp;
    if (lastSprintTimestamp == null) return null;

    final lastSprint = DateTime.tryParse(lastSprintTimestamp);
    if (lastSprint == null) return null;

    // Check if the last sprint was indeed from a PREVIOUS day
    // If the user just used the app today, we shouldn't adapt based on today's partial data
    // But PersistenceService archives data ONLY when date changes.
    // So lastDayOverloadEvents is GUARANTEED to be from the previous active day.
    
    // However, we want to ensure we don't adapt if the user hasn't used the app for a long time
    // e.g. if last usage was a month ago, the archived data is stale.
    // But for MVP, let's assume any past data is valid context.

    // Mark as adapted for today so we don't retry
    await _persistence.setLastAdaptationDate(today);

    final prevOverloadCount = _persistence.lastDayOverloadEvents;
    
    // Adaptation Rule 1: frequent overload (>2) → reduce sprint duration
    if (prevOverloadCount > 2) {
      final newDurationMinutes = (currentProfile.sprintDuration.inMinutes - 15)
          .clamp(30, 120);
      
      return CognitiveProfile(
        interactionThreshold: currentProfile.interactionThreshold,
        sprintDuration: Duration(minutes: newDurationMinutes),
        recoveryDuration: currentProfile.recoveryDuration,
        description:
            'Adapted: Sprint reduced to ${newDurationMinutes}m due to fatigue ($prevOverloadCount overloads yesterday)',
      );
    }

    // Adaptation Rule 2: No overloads → slightly increase threshold (build resilience)
    if (prevOverloadCount == 0) {
      final newThreshold = (currentProfile.interactionThreshold + 5).clamp(20, 80);
      
      // Only return new profile if it actually changed
      if (newThreshold != currentProfile.interactionThreshold) {
        return CognitiveProfile(
          interactionThreshold: newThreshold,
          sprintDuration: currentProfile.sprintDuration,
          recoveryDuration: currentProfile.recoveryDuration,
          description: 'Adapted: Threshold +5 (Resilience building)',
        );
      }
    }

    return null; // No adaptation needed
  }

  /// Reset daily counters (call this after adaptation check)
  /// DEPRECATED: PersistenceService handles this internally now
  Future<void> resetDailyCounters() async {
    // No-op
  }

  /// Record that a sprint just completed
  Future<void> recordSprintCompletion() async {
    await _persistence.setLastSprintTimestamp(DateTime.now().toIso8601String());
  }
}
