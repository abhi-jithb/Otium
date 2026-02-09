import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../state/user_provider.dart';
import '../../state/fatigue_provider.dart';
import '../../widgets/full_screen_container.dart';
import '../../widgets/primary_button.dart';
import 'role_card.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  String? selectedRole;

  final Map<String, IconData> roles = {
    'Student': Icons.school,
    'Knowledge': Icons.work,
    'Creative': Icons.brush,
    'Heavy': Icons.smartphone,
  };

  final Map<String, String> roleDescriptions = {
    'Student': 'Lower threshold (30) • 60min sprints',
    'Knowledge': 'Balanced threshold (40) • 90min sprints',
    'Creative': 'Higher threshold (50) • Flow-optimized',
    'Heavy': 'Adaptive threshold (25) • 45min sprints',
  };

  @override
  Widget build(BuildContext context) {
    return FullScreenContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'How do you mostly use your phone?',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text(
            'This adapts your overload sensitivity to your cognitive tolerance.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: ListView(
              children: roles.entries.map((entry) {
                return Column(
                  children: [
                    RoleCard(
                      title: entry.key,
                      icon: entry.value,
                      isSelected: selectedRole == entry.key,
                      onTap: () => setState(() => selectedRole = entry.key),
                    ),
                    if (selectedRole == entry.key)
                      Padding(
                        padding: const EdgeInsets.only(left: 16, bottom: 8),
                        child: Text(
                          roleDescriptions[entry.key] ?? '',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                  ],
                );
              }).toList(),
            ),
          ),
          PrimaryButton(
            label: 'Continue',
            onPressed: selectedRole == null
                ? null
                : () {
                    final userProvider = context.read<UserProvider>();
                    final fatigueProvider = context.read<FatigueProvider>();
                    
                    userProvider.setRole(selectedRole!);
                    fatigueProvider.updateProfile(userProvider.profile);
                    
                    context.go('/');
                  },
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.privacy_tip_outlined,
                  size: 14, color: Colors.grey.shade500),
              const SizedBox(width: 4),
              Text(
                'No cloud. No tracking. Fully offline.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
