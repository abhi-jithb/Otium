import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/colors.dart';
import '../../core/utils/time_utils.dart';
import '../../widgets/full_screen_container.dart';

class RecoveryScreen extends StatefulWidget {
  const RecoveryScreen({super.key});

  @override
  State<RecoveryScreen> createState() => _RecoveryScreenState();
}

class _RecoveryScreenState extends State<RecoveryScreen> {
  final List<String> _nudges = [
    'Step away from the screen',
    'Sit quietly for 5 minutes',
    'Light movement or nature',
    'Hydrate and look at the horizon',
    'Practice 5-4-3-2-1 grounding',
  ];
  late String _currentNudge;
  Duration _timeLeft = const Duration(minutes: 15);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _currentNudge = (List.from(_nudges)..shuffle()).first;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft.inSeconds > 0) {
        setState(() => _timeLeft -= const Duration(seconds: 1));
      } else {
        _timer?.cancel();
        context.go('/reflection');
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _timeLeft.inSeconds == 0,
      child: FullScreenContainer(
        backgroundColor: AppColors.primary,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Recovery Mode Active',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 48),
            Text(
              TimeUtils.formatDuration(_timeLeft),
              style: const TextStyle(
                fontSize: 72,
                color: Colors.white,
                fontWeight: FontWeight.w200,
              ),
            ),
            const SizedBox(height: 48),
            Text(
              _currentNudge,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white70,
                height: 1.5,
              ),
            ),
            const Spacer(),
            // No button to exit, it exits automatically
            Opacity(
              opacity: 0.5,
              child: Text(
                'Recovery in progress...',
                style: TextStyle(color: Colors.white.withOpacity(0.5)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
