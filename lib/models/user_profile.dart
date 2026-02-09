class UserProfile {
  final String role;

  UserProfile({required this.role});

  factory UserProfile.empty() => UserProfile(role: '');
}
