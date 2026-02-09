import 'package:flutter/material.dart';

class StateIndicator extends StatefulWidget {
  final String status;
  final Color color;

  const StateIndicator({super.key, required this.status, required this.color});

  @override
  State<StateIndicator> createState() => _StateIndicatorState();
}

class _StateIndicatorState extends State<StateIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _animation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: widget.color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: widget.color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FadeTransition(
            opacity: _animation,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.color,
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withOpacity(0.4),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            widget.status,
            style: TextStyle(
              color: widget.color,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
