import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../state/sprint_provider.dart';
import '../../state/fatigue_provider.dart';
import '../../models/session.dart';
import '../../widgets/full_screen_container.dart';
import 'sprint_timer.dart';

class SprintScreen extends StatefulWidget {
  const SprintScreen({super.key});

  @override
  State<SprintScreen> createState() => _SprintScreenState();
}

class _SprintScreenState extends State<SprintScreen>
    with WidgetsBindingObserver {
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<SprintProvider>().startSprint();
        context.read<FatigueProvider>().reset();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      context.read<FatigueProvider>().reportAppSwitch();
    }
  }

  void _navigateIfNeeded(String route) {
    if (!_hasNavigated && mounted) {
      _hasNavigated = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.go(route);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final sprint = context.watch<SprintProvider>();
    final fatigue = context.watch<FatigueProvider>();

    // Navigation guards
    if (fatigue.isFatigued) {
      _navigateIfNeeded('/intervention');
    } else if (sprint.sessionState == SessionState.recovery) {
      _navigateIfNeeded('/recovery');
    }

    return GestureDetector(
      onTap: () => context.read<FatigueProvider>().incrementFriction(),
      behavior: HitTestBehavior.opaque,
      child: FullScreenContainer(
        backgroundColor: Colors.blueGrey.shade50,
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text(
              'Focus sprint in progress',
              style: TextStyle(
                fontSize: 18,
                color: Colors.blueGrey,
                letterSpacing: 0.5,
              ),
            ),
            const Spacer(),
            SprintTimer(timeLeft: sprint.timeLeft),
            const Spacer(),
            Text(
              'Interactions: ${fatigue.interactionCount}',
              style: TextStyle(
                color: Colors.blueGrey.withOpacity(0.5),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
