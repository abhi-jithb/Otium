import 'package:flutter/material.dart';
import '../../core/utils/time_utils.dart';

class SprintTimer extends StatelessWidget {
  final Duration timeLeft;

  const SprintTimer({super.key, required this.timeLeft});

  @override
  Widget build(BuildContext context) {
    return Text(
      TimeUtils.formatDuration(timeLeft),
      style: const TextStyle(
        fontSize: 80,
        fontWeight: FontWeight.w300,
        letterSpacing: -2,
      ),
    );
  }
}
