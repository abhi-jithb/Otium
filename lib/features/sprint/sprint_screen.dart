import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../state/sprint_provider.dart';
import '../../state/fatigue_provider.dart';
import '../../widgets/full_screen_container.dart';
import 'sprint_timer.dart';

class SprintScreen extends StatefulWidget {
  const SprintScreen({super.key});

  @override
  State<SprintScreen> createState() => _SprintScreenState();
}

class _SprintScreenState extends State<SprintScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SprintProvider>().startSprint();
      context.read<FatigueProvider>().reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final sprint = context.watch<SprintProvider>();
    final fatigue = context.watch<FatigueProvider>();

    // Mock logic to trigger intervention
    if (fatigue.isFatigued) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/intervention');
      });
    }

    // When timer reaches 0 or state becomes recovery
    if (sprint.sessionState == SessionState.recovery) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/recovery');
      });
    }

    return GestureDetector(
      onTap: () => context.read<FatigueProvider>().incrementFriction(),
      child: FullScreenContainer(
        backgroundColor: Colors.blueGrey.shade50,
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text(
              'Focus sprint in progress',
              style: TextStyle(fontSize: 18, color: Colors.blueGrey),
            ),
            const Spacer(),
            SprintTimer(timeLeft: sprint.timeLeft),
            const Spacer(),
            Text(
              'Interactions: ${fatigue.interactionCount}',
              style: TextStyle(color: Colors.blueGrey.withOpacity(0.5)),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
