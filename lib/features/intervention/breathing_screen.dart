import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../state/fatigue_provider.dart';
import '../../core/utils/persistence_service.dart';
import '../../widgets/full_screen_container.dart';
import '../../widgets/primary_button.dart';

/// BreathingScreen: 60-second breathing intervention for cognitive regulation.
///
/// LIFECYCLE AWARE: Persists timer state across app restarts.
/// If user leaves mid-intervention and returns, timer resumes correctly.
class BreathingScreen extends StatefulWidget {
  const BreathingScreen({super.key});

  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _breathController;
  late AnimationController _particleController;
  late AnimationController _textController;
  late Animation<double> _breathAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _textFadeAnimation;

  static const int _totalSeconds = 60;
  int _secondsRemaining = _totalSeconds;
  Timer? _timer;
  String _phase = "Inhale";
  int _breathCycle = 0;
  bool _isActive = true;

  final List<Color> _phaseColors = [
    const Color(0xFF4FC3F7), // Inhale - Light blue
    const Color(0xFF81C784), // Hold - Green
    const Color(0xFF9575CD), // Exhale - Purple
    const Color(0xFFFFB74D), // Hold - Orange
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _breathAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOutSine),
    );

    _glowAnimation = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOutSine),
    );

    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
    );

    _textController.forward();
    _initializeTimer();
  }

  Future<void> _initializeTimer() async {
    // Check persistence for interrupted intervention
    final persistence = await PersistenceService.init();

    if (persistence.interventionInProgress) {
      final savedSeconds = persistence.interventionSecondsLeft;
      if (savedSeconds > 0 && savedSeconds < _totalSeconds) {
        _secondsRemaining = savedSeconds;
        debugPrint('🔄 Resuming intervention: ${_secondsRemaining}s left');
      }
    }

    // Mark intervention as in progress
    await persistence.setInterventionInProgress(true);
    await persistence.setInterventionSecondsLeft(_secondsRemaining);

    _startBreathingCycle();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0 && _isActive) {
        setState(() => _secondsRemaining--);

        // Persist every 5 seconds
        if (_secondsRemaining % 5 == 0) {
          _persistState();
        }
      } else if (_secondsRemaining <= 0) {
        _timer?.cancel();
        _onInterventionComplete();
      }
    });
  }

  Future<void> _persistState() async {
    final persistence = await PersistenceService.init();
    await persistence.setInterventionSecondsLeft(_secondsRemaining);
  }

  Future<void> _onInterventionComplete() async {
    final persistence = await PersistenceService.init();
    await persistence.setInterventionInProgress(false);
    await persistence.setInterventionSecondsLeft(_totalSeconds);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _isActive = false;
      _timer?.cancel();
      _persistState();
      debugPrint('⏸️ Intervention paused');
    } else if (state == AppLifecycleState.resumed) {
      _isActive = true;
      if (_secondsRemaining > 0) {
        _startTimer();
        debugPrint('▶️ Intervention resumed: ${_secondsRemaining}s left');
      }
    }
  }

  void _startBreathingCycle() async {
    while (mounted && _isActive) {
      // Inhale (4s)
      if (!mounted) return;
      _updatePhase("Inhale", 0);
      await _breathController.forward();

      // Hold (4s)
      if (!mounted) return;
      _updatePhase("Hold", 1);
      await Future.delayed(const Duration(seconds: 4));

      // Exhale (4s)
      if (!mounted) return;
      _updatePhase("Exhale", 2);
      await _breathController.reverse();

      // Hold (4s)
      if (!mounted) return;
      _updatePhase("Hold", 3);
      await Future.delayed(const Duration(seconds: 4));

      _breathCycle++;
    }
  }

  void _updatePhase(String phase, int colorIndex) {
    if (mounted) {
      setState(() {
        _phase = phase;
      });
    }
  }

  Color get _currentColor {
    switch (_phase) {
      case "Inhale":
        return _phaseColors[0];
      case "Exhale":
        return _phaseColors[2];
      default:
        return _phaseColors[1];
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _breathController.dispose();
    _particleController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _resumeSprint() async {
    await _onInterventionComplete();
    if (mounted) {
      context.read<FatigueProvider>().clearFatigue();
      context.go('/sprint');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _secondsRemaining <= 0, // Only allow back when complete
      child: FullScreenContainer(
        backgroundColor: Colors.grey.shade50,
        child: Column(
          children: [
            const SizedBox(height: 20),
            FadeTransition(
              opacity: _textFadeAnimation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, -0.2),
                  end: Offset.zero,
                ).animate(_textController),
                child: Column(
                  children: [
                    const Text(
                      "Your mind needs a moment",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Let your nervous system settle",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Animated countdown
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: _currentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "${_secondsRemaining}s remaining",
                style: TextStyle(
                  color: _currentColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                "This idle state activates your brain's Default Mode Network—essential for recovery, insight, and emotional processing.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
            ),
            const Spacer(),
            // Main breathing circle with particles
            AnimatedBuilder(
              animation: Listenable.merge([
                _breathController,
                _particleController,
              ]),
              builder: (context, child) {
                return SizedBox(
                  width: 280,
                  height: 280,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Particle rings
                      ...List.generate(3, (index) {
                        final angle =
                            (_particleController.value * 2 * math.pi) +
                            (index * math.pi / 3);
                        return Positioned(
                          left: 140 + math.cos(angle) * (80 + index * 15) - 6,
                          top: 140 + math.sin(angle) * (80 + index * 15) - 6,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentColor.withOpacity(
                                0.4 - index * 0.1,
                              ),
                            ),
                          ),
                        );
                      }),
                      // Outer glow ring
                      Container(
                        width: 220 * _breathAnimation.value,
                        height: 220 * _breathAnimation.value,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _currentColor.withOpacity(0.2),
                            width: 2,
                          ),
                        ),
                      ),
                      // Middle ring
                      Container(
                        width: 200 * _breathAnimation.value,
                        height: 200 * _breathAnimation.value,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _currentColor.withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                      ),
                      // Main breathing circle
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 180 * _breathAnimation.value,
                        height: 180 * _breathAnimation.value,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              _currentColor.withOpacity(0.3),
                              _currentColor.withOpacity(0.1),
                            ],
                          ),
                          border: Border.all(
                            color: _currentColor.withOpacity(
                              _glowAnimation.value,
                            ),
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: _currentColor.withOpacity(
                                _glowAnimation.value * 0.5,
                              ),
                              blurRadius: 30 * _breathAnimation.value,
                              spreadRadius: 10 * _breathAnimation.value,
                            ),
                          ],
                        ),
                        child: Center(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (child, animation) {
                              return ScaleTransition(
                                scale: animation,
                                child: FadeTransition(
                                  opacity: animation,
                                  child: child,
                                ),
                              );
                            },
                            child: Text(
                              _phase,
                              key: ValueKey(_phase),
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                color: _currentColor,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            // Breath cycle indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: index < _breathCycle % 4 + 1 ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: index < _breathCycle % 4 + 1
                        ? _currentColor
                        : Colors.grey.shade300,
                  ),
                );
              }),
            ),
            const Spacer(),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _secondsRemaining > 0 ? 0.5 : 1.0,
              child: AnimatedScale(
                duration: const Duration(milliseconds: 300),
                scale: _secondsRemaining > 0 ? 0.95 : 1.0,
                child: PrimaryButton(
                  label: _secondsRemaining > 0
                      ? 'Breathe... ($_secondsRemaining)'
                      : 'Resume Sprint',
                  onPressed: _secondsRemaining > 0 ? null : _resumeSprint,
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
