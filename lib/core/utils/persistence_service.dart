import 'package:shared_preferences/shared_preferences.dart';

/// Local-first persistence service for storing user data on-device.
/// All data remains private and never leaves the user's device.
class PersistenceService {
  // Storage keys
  static const String _keyUserType = 'user_type';
  static const String _keyInteractionCount = 'interaction_count';
  static const String _keyOverloadEvents = 'overload_events';
  static const String _keyLastSprint = 'last_sprint_timestamp';

  final SharedPreferences _prefs;

  PersistenceService._(this._prefs);

  /// Initialize the persistence service
  static Future<PersistenceService> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return PersistenceService._(prefs);
    } catch (e) {
      throw Exception('Failed to initialize persistence: $e');
    }
  }

  // User profile
  String? get userType => _prefs.getString(_keyUserType);
  
  Future<bool> setUserType(String type) async {
    try {
      return await _prefs.setString(_keyUserType, type);
    } catch (e) {
      return false;
    }
  }

  // Interaction tracking (cross-session)
  int get dailyInteractionCount => _prefs.getInt(_keyInteractionCount) ?? 0;
  
  Future<bool> setDailyInteractionCount(int count) async {
    try {
      return await _prefs.setInt(_keyInteractionCount, count);
    } catch (e) {
      return false;
    }
  }

  // Overload events
  int get overloadEventsCount => _prefs.getInt(_keyOverloadEvents) ?? 0;
  
  Future<bool> incrementOverloadEvents() async {
    try {
      final current = overloadEventsCount;
      return await _prefs.setInt(_keyOverloadEvents, current + 1);
    } catch (e) {
      return false;
    }
  }

  // Sprint tracking
  String? get lastSprintTimestamp => _prefs.getString(_keyLastSprint);
  
  Future<bool> setLastSprintTimestamp(String timestamp) async {
    try {
      return await _prefs.setString(_keyLastSprint, timestamp);
    } catch (e) {
      return false;
    }
  }

  /// Clear all stored data (for testing or reset)
  Future<bool> clearAll() async {
    try {
      return await _prefs.clear();
    } catch (e) {
      return false;
    }
  }
}
