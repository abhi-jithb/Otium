import 'package:flutter/material.dart';
import '../models/user_profile.dart';

class UserProvider with ChangeNotifier {
  UserProfile _profile = UserProfile.empty();

  UserProfile get profile => _profile;

  void setRole(String role) {
    _profile = UserProfile(role: role);
    notifyListeners();
  }
}
