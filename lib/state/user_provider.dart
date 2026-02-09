import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../core/utils/persistence_service.dart';

class UserProvider with ChangeNotifier {
  final PersistenceService _persistence;
  UserProfile _profile = UserProfile.empty();

  UserProvider(this._persistence) {
    final savedRole = _persistence.userType;
    if (savedRole != null) {
      _profile = UserProfile(role: savedRole);
    }
  }

  UserProfile get profile => _profile;

  void setRole(String role) {
    _profile = UserProfile(role: role);
    _persistence.setUserType(role);
    notifyListeners();
  }
}
