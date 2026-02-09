import 'package:flutter/material.dart';

class FullScreenContainer extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;

  const FullScreenContainer({
    super.key,
    required this.child,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: child,
        ),
      ),
    );
  }
}
