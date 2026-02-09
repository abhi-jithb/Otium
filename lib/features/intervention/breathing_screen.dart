import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../state/fatigue_provider.dart';
import '../../widgets/full_screen_container.dart';
import '../../widgets/primary_button.dart';

class BreathingScreen extends StatefulWidget {
  const BreathingScreen({super.key});

  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _secondsRemaining = 60;
  Timer? _timer;
  String _phase = "Inhale";

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _animation = Tween<double>(
      begin: 1.0,
      end: 1.5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _startBreathingCycle();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _timer?.cancel();
      }
    });
  }

  void _startBreathingCycle() async {
    while (mounted) {
      // Inhale (4s)
      if (!mounted) return;
      setState(() => _phase = "Inhale");
      await _controller.forward();

      // Hold (4s)
      if (!mounted) return;
      setState(() => _phase = "Hold");
      await Future.delayed(const Duration(seconds: 4));

      // Exhale (4s)
      if (!mounted) return;
      setState(() => _phase = "Exhale");
      await _controller.reverse();

      // Hold (4s)
      if (!mounted) return;
      setState(() => _phase = "Hold");
      await Future.delayed(const Duration(seconds: 4));
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FullScreenContainer(
      child: Column(
        children: [
          const SizedBox(height: 40),
          const Text(
            "Regulating Nervous System",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            "Seconds remaining: $_secondsRemaining",
            style: const TextStyle(color: Colors.grey),
          ),
          const Spacer(),
          ScaleTransition(
            scale: _animation,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.withOpacity(0.1),
                border: Border.all(
                  color: Colors.blue.withOpacity(0.5),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  _phase,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ),
          const Spacer(),
          if (_secondsRemaining > 0)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.grey.shade400),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Relax... $_secondsRemaining',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            )
          else
            PrimaryButton(
              label: 'Resume Sprint',
              onPressed: () {
                context.read<FatigueProvider>().clearFatigue();
                context.go('/sprint');
              },
            ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
