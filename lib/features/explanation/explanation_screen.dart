import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/colors.dart';
import '../../widgets/full_screen_container.dart';

class ExplanationScreen extends StatelessWidget {
  const ExplanationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FullScreenContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, size: 20),
                color: Colors.grey.shade600,
                onPressed: () => context.pop(),
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    'How Otium Works',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 40), // Balance the back button
            ],
          ),
          const SizedBox(height: 24),
          
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                _buildSection(
                  title: 'Seatbelt, Not Steering Wheel',
                  content: 'Otium is not a productivity tracker. It is a nervous system regulator. It only intervenes when your cognitive patterns show signs of fragmentation.',
                  icon: Icons.safety_check_outlined,
                  color: AppColors.primary,
                ),
                
                _buildSection(
                  title: 'Ultradian Rhythms',
                  content: 'Your brain can only focus deeply for about 90 minutes. Otium tracks these biological cycles and suggests recovery before you burnout.',
                  icon: Icons.timer_outlined,
                  color: AppColors.accent,
                ),
                
                _buildSection(
                  title: 'Pattern Sensing',
                  content: 'We detect "Cognitive Friction" by monitoring rapid app switching and compulsive tapping. High friction triggers a mandatory breathing break.',
                  icon: Icons.touch_app_outlined,
                  color: AppColors.calm,
                ),
                
                _buildSection(
                  title: 'Default Mode Network',
                  content: 'The 60-second breathing exercise is designed to activate your brain\'s Default Mode Network (DMN), which is essential for creativity and problem solving.',
                  icon: Icons.psychology_outlined,
                  color: Colors.purple.shade300,
                ),
                
                _buildSection(
                  title: '100% Private',
                  content: 'No cloud. No login. No data leaves this device. All pattern recognition happens locally on your phone.',
                  icon: Icons.privacy_tip_outlined,
                  color: Colors.green.shade400,
                ),
                
                const SizedBox(height: 32),
                
                Center(
                  child: Text(
                    'Built for human biology,\nnot machine efficiency.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
