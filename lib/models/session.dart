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
