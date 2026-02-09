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
      _profile = UserProfile(role: savedRole);
      
      // Check for daily adaptation
      final adaptedProfile = await _adaptationEngine.checkDailyAdaptation(
        _profile.cognitiveProfile,
      );
      
      if (adaptedProfile != null) {
        _profile = UserProfile(
          role: savedRole,
          cognitiveProfile: adaptedProfile,
        );
        debugPrint('🧠 Profile adapted: ${adaptedProfile.description}');
      }
      
      notifyListeners();
    }
  }

  void setRole(String role) {
    _profile = UserProfile(role: role);
    _persistence.setUserType(role);
    notifyListeners();
  }

  Future<void> recordSprintCompletion() async {
    await _adaptationEngine.recordSprintCompletion();
  }
}
