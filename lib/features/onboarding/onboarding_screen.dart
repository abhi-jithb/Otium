import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../state/user_provider.dart';
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
    'Student / Learner': Icons.school,
    'Knowledge Worker': Icons.work,
    'Creative / Builder': Icons.brush,
    'Heavy Screen User': Icons.smartphone,
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
            'We’ll adapt the Otium experience to your biological cognitive rhythms.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: ListView(
              children: roles.entries.map((entry) {
                return RoleCard(
                  title: entry.key,
                  icon: entry.value,
                  isSelected: selectedRole == entry.key,
                  onTap: () => setState(() => selectedRole = entry.key),
                );
              }).toList(),
            ),
          ),
          PrimaryButton(
            label: 'Continue',
            onPressed: selectedRole == null
                ? () {}
                : () {
                    context.read<UserProvider>().setRole(selectedRole!);
                    context.go('/');
                  },
          ),
        ],
      ),
    );
  }
}
