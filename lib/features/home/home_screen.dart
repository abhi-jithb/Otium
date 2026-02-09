import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/colors.dart';
import '../../widgets/full_screen_container.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/state_indicator.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FullScreenContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const StateIndicator(status: 'CALM', color: AppColors.calm),
          const Spacer(),
          const Text(
            'Ready to focus?',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            'Start a 90-minute sprint to reclaim your biological capacity to think.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const Spacer(),
          PrimaryButton(
            label: 'Start Focus Sprint',
            onPressed: () => context.go('/sprint'),
          ),
          const SizedBox(height: 16),
          Text(
            'Last recovery: 2h ago',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
