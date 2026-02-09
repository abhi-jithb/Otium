/// User cognitive profile with adaptive thresholds
class UserProfile {
  final String role;
  final CognitiveProfile cognitiveProfile;

  UserProfile({
    required this.role,
    CognitiveProfile? cognitiveProfile,
  }) : cognitiveProfile = cognitiveProfile ?? CognitiveProfile.fromRole(role);

  factory UserProfile.empty() => UserProfile(role: '');

  bool get hasRole => role.isNotEmpty;
}

/// Cognitive tolerance configuration based on user type
class CognitiveProfile {
  final int interactionThreshold;
  final Duration sprintDuration;
  final Duration recoveryDuration;
  final String description;

  const CognitiveProfile({
    required this.interactionThreshold,
    required this.sprintDuration,
    required this.recoveryDuration,
    required this.description,
  });

  /// Factory: Create profile based on user role
  factory CognitiveProfile.fromRole(String role) {
    switch (role.toLowerCase()) {
      case 'student':
      case 'learner':
        return const CognitiveProfile(
          interactionThreshold: 30,
          sprintDuration: Duration(minutes: 60),
          recoveryDuration: Duration(minutes: 12),
          description: 'Lower threshold for learning-focused work',
        );

      case 'knowledge':
      case 'knowledge worker':
        return const CognitiveProfile(
          interactionThreshold: 40,
          sprintDuration: Duration(minutes: 90),
          recoveryDuration: Duration(minutes: 15),
          description: 'Balanced threshold for sustained focus',
        );

      case 'creative':
      case 'builder':
        return const CognitiveProfile(
          interactionThreshold: 50,
          sprintDuration: Duration(minutes: 90),
          recoveryDuration: Duration(minutes: 18),
          description: 'Higher threshold for flow-state work',
        );

      case 'heavy':
      case 'heavy screen user':
        return const CognitiveProfile(
          interactionThreshold: 25,
          sprintDuration: Duration(minutes: 45),
          recoveryDuration: Duration(minutes: 10),
          description: 'Adaptive threshold for high-stimulation users',
        );

      default:
        return const CognitiveProfile(
          interactionThreshold: 40,
          sprintDuration: Duration(minutes: 90),
          recoveryDuration: Duration(minutes: 15),
          description: 'Default balanced profile',
        );
    }
  }
}
