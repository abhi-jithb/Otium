import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../core/utils/persistence_service.dart';
import '../core/utils/adaptation_engine.dart';

class UserProvider with ChangeNotifier {
  final PersistenceService _persistence;
  final AdaptationEngine _adaptationEngine;
  UserProfile _profile = UserProfile.empty();

  UserProvider(this._persistence)
      : _adaptationEngine = AdaptationEngine(_persistence) {
    _loadProfile();
  }

  UserProfile get profile => _profile;

  Future<void> _loadProfile() async {
    final savedRole = _persistence.userType;
    if (savedRole != null) {
      // 1. Start with Role Defaults
      final roleDefault = CognitiveProfile.fromRole(savedRole);
      
      // 2. Apply Cumulative Learning (Persisted Overrides)
      // If we have saved threshold/duration, use them instead of defaults
      final savedThreshold = _persistence.threshold;
      final savedDurationMinutes = _persistence.sprintDurationMinutes;
      
      var currentProfile = CognitiveProfile(
        interactionThreshold: savedThreshold ?? roleDefault.interactionThreshold,
        sprintDuration: savedDurationMinutes != null 
            ? Duration(minutes: savedDurationMinutes)
            : roleDefault.sprintDuration,
        recoveryDuration: roleDefault.recoveryDuration,
        description: roleDefault.description,
      );
      
      // 3. Apply Daily Adaptation
      final adaptedProfile = await _adaptationEngine.checkDailyAdaptation(
        currentProfile,
      );
      
      if (adaptedProfile != null) {
        currentProfile = adaptedProfile;
        debugPrint('🧠 Profile adapted: ${adaptedProfile.description}');
        
        // Persist the NEW adaptation so it becomes the new baseline
        await _persistence.setThreshold(currentProfile.interactionThreshold);
        await _persistence.setSprintDurationMinutes(
            currentProfile.sprintDuration.inMinutes
        );
      }
      
      _profile = UserProfile(
        role: savedRole,
        cognitiveProfile: currentProfile,
      );
      
      notifyListeners();
    }
  }

  void setRole(String role) {
    // When changing role, we reset to that role's defaults
    // This clears previous adaptations for the old role
    final newProfile = UserProfile(role: role);
    _profile = newProfile;
    
    _persistence.setUserType(role);
    
    // Persist the new baseline
    _persistence.setThreshold(newProfile.cognitiveProfile.interactionThreshold);
    _persistence.setSprintDurationMinutes(
        newProfile.cognitiveProfile.sprintDuration.inMinutes
    );
    
    notifyListeners();
  }

  Future<void> recordSprintCompletion() async {
    await _adaptationEngine.recordSprintCompletion();
  }
}
