/// Session states with explicit naming for cognitive clarity
enum SessionState {
  focus,       // Active work state
  recovery,    // DMN activation / forced idle
  reflection,  // Post-session review
  ready,       // Regulated and ready to resume
}

/// Helper extension for state descriptions
extension SessionStateDescription on SessionState {
  String get description {
    switch (this) {
      case SessionState.focus:
        return 'Active Focus';
      case SessionState.recovery:
        return 'Recovery Mode (DMN Active)';
      case SessionState.reflection:
        return 'Reflection';
      case SessionState.ready:
        return 'Regulated & Ready';
    }
  }
}

class Session {
  final int focusMinutes;
  final int recoveryMinutes;
  final int energyAfter;
  final DateTime timestamp;

  Session({
    required this.focusMinutes,
    required this.recoveryMinutes,
    required this.energyAfter,
    required this.timestamp,
  });
}
