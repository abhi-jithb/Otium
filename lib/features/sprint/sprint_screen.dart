import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../state/sprint_provider.dart';
import '../../state/fatigue_provider.dart';
import '../../models/session.dart';
import '../../widgets/full_screen_container.dart';
import 'sprint_timer.dart';

/// SprintScreen: Minimal, breathing-aligned focus timer.
///
/// Design Philosophy:
/// - ONLY the timer should be visible
/// - Zero cognitive load from UI chrome
/// - Interaction tracking is invisible (pattern sensing)
/// - Breathing rhythm through subtle pulse animation
///
/// LIFECYCLE AWARE: Handles app resume, pause, and state restoration.
class SprintScreen extends StatefulWidget {
  const SprintScreen({super.key});

  @override
  State<SprintScreen> createState() => _SprintScreenState();
}

class _SprintScreenState extends State<SprintScreen>
    with WidgetsBindingObserver {
  bool _hasNavigated = false;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_initialized) {
        _initialized = true;
        final sprint = context.read<SprintProvider>();
        final fatigue = context.read<FatigueProvider>();

        // Check if we're resuming an existing sprint or starting fresh
        if (sprint.sessionState == SessionState.focus &&
            sprint.timeLeft.inSeconds > 0) {
          // Resume existing sprint
          sprint.resumeSprint();
          debugPrint(
            '🔄 Resuming sprint: ${sprint.timeLeft.inMinutes}min left',
          );
        } else if (sprint.sessionState == SessionState.idle) {
          // Start new sprint
          sprint.startSprint();
          fatigue.reset();
          debugPrint('▶️ Starting new sprint');
        }
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
    if (!mounted) return;

    final fatigue = context.read<FatigueProvider>();
    final sprint = context.read<SprintProvider>();

    if (state == AppLifecycleState.resumed) {
      // App returning - check if sprint should resume
      if (sprint.sessionState == SessionState.focus &&
          sprint.timeLeft.inSeconds > 0 &&
          !sprint.isRunning) {
        sprint.resumeSprint();
      }
      // Record app switch for fatigue tracking
      fatigue.reportAppSwitch();
    } else if (state == AppLifecycleState.paused) {
      // App leaving - sprint provider handles pausing via app.dart
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

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'End Sprint?',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        content: const Text(
          'Your progress will be saved. You can resume anytime.',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Continue',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<SprintProvider>().pauseSprint();
              context.go('/mode-selection');
            },
            child: const Text(
              'End Sprint',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sprint = context.watch<SprintProvider>();
    final fatigue = context.watch<FatigueProvider>();

    // Navigation guards - check fatigue first (more urgent)
    if (fatigue.isFatigued) {
      _navigateIfNeeded('/intervention');
    } else if (sprint.sessionState == SessionState.recovery) {
      _navigateIfNeeded('/recovery');
    }

    return GestureDetector(
      // Invisible friction tracking - all gestures are sensed
      onTap: () => fatigue.incrementFriction(),
      onDoubleTap: () {
        // Double tap = more agitation
        fatigue.incrementFriction();
        fatigue.incrementFriction();
      },
      onLongPress: () {
        // Long press is intentional, don't count as friction
      },
      onPanStart: (_) => fatigue.onScrollStart(),
      onPanEnd: (_) => fatigue.onScrollEnd(),
      onPanUpdate: (_) => fatigue.onScrollUpdate(),
      behavior: HitTestBehavior.opaque,
      child: FullScreenContainer(
        backgroundColor: Colors.blueGrey.shade50,
        child: Stack(
          children: [
            // Main timer (centered)
            Center(child: SprintTimer(timeLeft: sprint.timeLeft)),

            // Top bar with close and friction counter
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Close button
                      IconButton(
                        onPressed: _showExitDialog,
                        icon: Icon(
                          Icons.close_rounded,
                          color: Colors.grey.shade600,
                        ),
                        tooltip: 'End Sprint',
                      ),

                      // Friction counter (live interaction count)
                      _FrictionCounter(
                        score: fatigue.frictionScore,
                        threshold: fatigue.threshold,
                        interactionCount: fatigue.interactionCount,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Live friction counter widget showing interaction score
class _FrictionCounter extends StatelessWidget {
  final int score;
  final int threshold;
  final int interactionCount;

  const _FrictionCounter({
    required this.score,
    required this.threshold,
    required this.interactionCount,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (score / threshold).clamp(0.0, 1.0);
    final isWarning = progress > 0.7;
    final isCritical = progress > 0.9;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isCritical
            ? Colors.red.shade50
            : isWarning
            ? Colors.orange.shade50
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isCritical
              ? Colors.red.shade200
              : isWarning
              ? Colors.orange.shade200
              : Colors.grey.shade300,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Interaction count icon
          Icon(
            Icons.touch_app_rounded,
            size: 16,
            color: isCritical
                ? Colors.red.shade600
                : isWarning
                ? Colors.orange.shade600
                : Colors.grey.shade600,
          ),
          const SizedBox(width: 6),
          // Score / Threshold
          Text(
            '$score',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isCritical
                  ? Colors.red.shade700
                  : isWarning
                  ? Colors.orange.shade700
                  : Colors.grey.shade700,
            ),
          ),
          Text(
            ' / $threshold',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
          const SizedBox(width: 8),
          // Progress bar
          SizedBox(
            width: 40,
            height: 4,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isCritical
                      ? Colors.red
                      : isWarning
                      ? Colors.orange
                      : Colors.teal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
