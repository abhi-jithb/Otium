import 'package:shared_preferences/shared_preferences.dart';

/// Local-first persistence service for storing user data on-device.
/// All data remains private and never leaves the user's device.
///
/// CRITICAL: This service persists ALL state required to survive:
/// - App minimize/restore
/// - App kill/restart
/// - Device reboot
class PersistenceService {
  // Storage keys
  static const String _keyUserType = 'user_type';
  static const String _keyInteractionCount = 'interaction_count';
  static const String _keyOverloadEvents = 'overload_events';
  static const String _keyLastSprint = 'last_sprint_timestamp';
  static const String _keyThreshold = 'cognitive_threshold';
  static const String _keyIsFatigued = 'is_fatigued';
  static const String _keyFrictionScore = 'friction_score';
  static const String _keySprintState = 'sprint_state';
  static const String _keySprintTimeLeft = 'sprint_time_left_seconds';
  static const String _keySprintStartTime = 'sprint_start_time';
  static const String _keyLastActiveTime = 'last_active_time';
  static const String _keyDailyResetDate = 'daily_reset_date';
  static const String _keySessionMode = 'session_mode';
  static const String _keyInterventionInProgress = 'intervention_in_progress';
  static const String _keyInterventionSecondsLeft = 'intervention_seconds_left';
  // Last day stats (for adaptation)
  static const String _keyLastDayInteractionCount = 'last_day_interaction_count';
  static const String _keyLastDayOverloadEvents = 'last_day_overload_events';

  final SharedPreferences _prefs;

  PersistenceService._(this._prefs);

  /// Initialize the persistence service
  static Future<PersistenceService> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final service = PersistenceService._(prefs);
      await service._checkDailyReset();
      return service;
    } catch (e) {
      throw Exception('Failed to initialize persistence: $e');
    }
  }

  /// Check if we need to reset daily counters
  /// Archives yesterday's stats before resetting for the new day
  Future<void> _checkDailyReset() async {
    final lastResetDate = _prefs.getString(_keyDailyResetDate);
    final today = DateTime.now().toIso8601String().substring(0, 10);

    // Initial run or same day
    if (lastResetDate == null) {
      await _prefs.setString(_keyDailyResetDate, today);
      return;
    }

    if (lastResetDate != today) {
      // New day - archive yesterday's stats first
      final currentInteractions = _prefs.getInt(_keyInteractionCount) ?? 0;
      final currentOverloads = _prefs.getInt(_keyOverloadEvents) ?? 0;

      await _prefs.setInt(_keyLastDayInteractionCount, currentInteractions);
      await _prefs.setInt(_keyLastDayOverloadEvents, currentOverloads);

      // Reset daily counters
      await _prefs.setInt(_keyInteractionCount, 0);
      await _prefs.setInt(_keyOverloadEvents, 0);
      await _prefs.setString(_keyDailyResetDate, today);
    }
  }

  // ==================== LAST DAY STATS ====================

  int get lastDayInteractionCount => _prefs.getInt(_keyLastDayInteractionCount) ?? 0;
  int get lastDayOverloadEvents => _prefs.getInt(_keyLastDayOverloadEvents) ?? 0;

  // ==================== ADAPTATION STATE ====================

  static const String _keyLastAdaptationDate = 'last_adaptation_date';

  String? get lastAdaptationDate => _prefs.getString(_keyLastAdaptationDate);

  Future<bool> setLastAdaptationDate(String date) async {
    try {
      return await _prefs.setString(_keyLastAdaptationDate, date);
    } catch (e) {
      return false;
    }
  }

  // ==================== USER PROFILE ====================

  String? get userType => _prefs.getString(_keyUserType);

  Future<bool> setUserType(String type) async {
    try {
      return await _prefs.setString(_keyUserType, type);
    } catch (e) {
      return false;
    }
  }

  // ==================== COGNITIVE THRESHOLD ====================

  int? get threshold => _prefs.getInt(_keyThreshold);

  Future<bool> setThreshold(int threshold) async {
    try {
      return await _prefs.setInt(_keyThreshold, threshold);
    } catch (e) {
      return false;
    }
  }

  // ==================== FATIGUE STATE ====================

  bool get isFatigued => _prefs.getBool(_keyIsFatigued) ?? false;

  Future<bool> setFatigued(bool fatigued) async {
    try {
      return await _prefs.setBool(_keyIsFatigued, fatigued);
    } catch (e) {
      return false;
    }
  }

  int get frictionScore => _prefs.getInt(_keyFrictionScore) ?? 0;

  Future<bool> setFrictionScore(int score) async {
    try {
      return await _prefs.setInt(_keyFrictionScore, score);
    } catch (e) {
      return false;
    }
  }

  // ==================== INTERACTION TRACKING ====================

  int get dailyInteractionCount => _prefs.getInt(_keyInteractionCount) ?? 0;

  Future<bool> setDailyInteractionCount(int count) async {
    try {
      return await _prefs.setInt(_keyInteractionCount, count);
    } catch (e) {
      return false;
    }
  }

  Future<bool> incrementInteractionCount() async {
    return await setDailyInteractionCount(dailyInteractionCount + 1);
  }

  // ==================== OVERLOAD EVENTS ====================

  int get overloadEventsCount => _prefs.getInt(_keyOverloadEvents) ?? 0;

  Future<bool> incrementOverloadEvents() async {
    try {
      final current = overloadEventsCount;
      return await _prefs.setInt(_keyOverloadEvents, current + 1);
    } catch (e) {
      return false;
    }
  }

  // ==================== SPRINT STATE ====================

  static const String _keySprintDurationMinutes = 'sprint_duration_minutes';

  int? get sprintDurationMinutes => _prefs.getInt(_keySprintDurationMinutes);

  Future<bool> setSprintDurationMinutes(int minutes) async {
    try {
      return await _prefs.setInt(_keySprintDurationMinutes, minutes);
    } catch (e) {
      return false;
    }
  }

  /// Sprint state: 'idle', 'focus', 'recovery'
  String get sprintState => _prefs.getString(_keySprintState) ?? 'idle';

  Future<bool> setSprintState(String state) async {
    try {
      return await _prefs.setString(_keySprintState, state);
    } catch (e) {
      return false;
    }
  }

  int get sprintTimeLeftSeconds => _prefs.getInt(_keySprintTimeLeft) ?? 0;

  Future<bool> setSprintTimeLeftSeconds(int seconds) async {
    try {
      return await _prefs.setInt(_keySprintTimeLeft, seconds);
    } catch (e) {
      return false;
    }
  }

  String? get sprintStartTime => _prefs.getString(_keySprintStartTime);

  Future<bool> setSprintStartTime(String? timestamp) async {
    try {
      if (timestamp == null) {
        return await _prefs.remove(_keySprintStartTime);
      }
      return await _prefs.setString(_keySprintStartTime, timestamp);
    } catch (e) {
      return false;
    }
  }

  String? get lastSprintTimestamp => _prefs.getString(_keyLastSprint);

  Future<bool> setLastSprintTimestamp(String timestamp) async {
    try {
      return await _prefs.setString(_keyLastSprint, timestamp);
    } catch (e) {
      return false;
    }
  }

  // ==================== SESSION MODE ====================

  String? get sessionMode => _prefs.getString(_keySessionMode);

  Future<bool> setSessionMode(String mode) async {
    try {
      return await _prefs.setString(_keySessionMode, mode);
    } catch (e) {
      return false;
    }
  }

  // ==================== INTERVENTION STATE ====================

  bool get interventionInProgress =>
      _prefs.getBool(_keyInterventionInProgress) ?? false;

  Future<bool> setInterventionInProgress(bool inProgress) async {
    try {
      return await _prefs.setBool(_keyInterventionInProgress, inProgress);
    } catch (e) {
      return false;
    }
  }

  int get interventionSecondsLeft =>
      _prefs.getInt(_keyInterventionSecondsLeft) ?? 60;

  Future<bool> setInterventionSecondsLeft(int seconds) async {
    try {
      return await _prefs.setInt(_keyInterventionSecondsLeft, seconds);
    } catch (e) {
      return false;
    }
  }

  // ==================== LAST ACTIVE TIME ====================

  String? get lastActiveTime => _prefs.getString(_keyLastActiveTime);

  Future<bool> setLastActiveTime(String timestamp) async {
    try {
      return await _prefs.setString(_keyLastActiveTime, timestamp);
    } catch (e) {
      return false;
    }
  }

  /// Calculate elapsed time since last active (for background time tracking)
  Duration? get timeSinceLastActive {
    final lastActive = lastActiveTime;
    if (lastActive == null) return null;

    final lastTime = DateTime.tryParse(lastActive);
    if (lastTime == null) return null;

    return DateTime.now().difference(lastTime);
  }

  // ==================== CLEAR ALL ====================

  /// Clear all stored data (for testing or reset)
  Future<bool> clearAll() async {
    try {
      return await _prefs.clear();
    } catch (e) {
      return false;
    }
  }

  /// Clear only session-related data (keeps user profile)
  Future<void> clearSession() async {
    await _prefs.remove(_keyIsFatigued);
    await _prefs.remove(_keyFrictionScore);
    await _prefs.remove(_keySprintState);
    await _prefs.remove(_keySprintTimeLeft);
    await _prefs.remove(_keySprintStartTime);
    await _prefs.remove(_keyInterventionInProgress);
    await _prefs.remove(_keyInterventionSecondsLeft);
  }
}
