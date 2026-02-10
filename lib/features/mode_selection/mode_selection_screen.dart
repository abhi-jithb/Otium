import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../state/user_provider.dart';
import '../../state/fatigue_provider.dart';
import '../../widgets/full_screen_container.dart';
import '../../widgets/primary_button.dart';

/// ModeSelectionScreen: Context-aware cognitive profile selection.
///
/// Shown before each sprint because:
/// - A student might be doing creative work right now
/// - A knowledge worker might be in heavy-usage mode today
/// - What you're doing NOW matters more than your general label
///
/// Philosophy: The same person has different cognitive needs at different moments.
class ModeSelectionScreen extends StatefulWidget {
  const ModeSelectionScreen({super.key});

  @override
  State<ModeSelectionScreen> createState() => _ModeSelectionScreenState();
}

class _ModeSelectionScreenState extends State<ModeSelectionScreen>
    with SingleTickerProviderStateMixin {
  String? selectedMode;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  // Modes describe WHAT you're doing now, not WHO you are
  final List<ModeOption> modes = [
    ModeOption(
      id: 'learning',
      title: 'Learning',
      subtitle: 'Reading, studying, absorbing',
      icon: Icons.menu_book_rounded,
      threshold: 30,
      sprintMinutes: 60,
      color: const Color(0xFF5C6BC0),
    ),
    ModeOption(
      id: 'deep_work',
      title: 'Deep Work',
      subtitle: 'Writing, coding, analyzing',
      icon: Icons.psychology_rounded,
      threshold: 40,
      sprintMinutes: 90,
      color: const Color(0xFF26A69A),
    ),
    ModeOption(
      id: 'creating',
      title: 'Creating',
      subtitle: 'Designing, building, making',
      icon: Icons.brush_rounded,
      threshold: 50,
      sprintMinutes: 90,
      color: const Color(0xFFFF7043),
    ),
    ModeOption(
      id: 'scattered',
      title: 'Already Scattered',
      subtitle: 'Need gentler thresholds today',
      icon: Icons.scatter_plot_rounded,
      threshold: 25,
      sprintMinutes: 45,
      color: const Color(0xFF78909C),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();

    // Pre-select the last used mode if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentRole = context.read<UserProvider>().profile.role;
      if (currentRole.isNotEmpty) {
        // Map old roles to new modes
        final modeMap = {
          'Student': 'learning',
          'Knowledge': 'deep_work',
          'Creative': 'creating',
          'Heavy': 'scattered',
        };
        setState(() {
          selectedMode = modeMap[currentRole] ?? currentRole.toLowerCase();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startSprint() {
    if (selectedMode == null) return;

    final userProvider = context.read<UserProvider>();
    final fatigueProvider = context.read<FatigueProvider>();

    // Map mode to role for the provider (maintains compatibility)
    final roleMap = {
      'learning': 'Student',
      'deep_work': 'Knowledge',
      'creating': 'Creative',
      'scattered': 'Heavy',
    };

    userProvider.setRole(roleMap[selectedMode] ?? 'Knowledge');
    fatigueProvider.updateProfile(userProvider.profile);

    context.go('/sprint');
  }

  @override
  Widget build(BuildContext context) {
    return FullScreenContainer(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back button row
            Row(
              children: [
                IconButton(
                  onPressed: () => context.go('/home'),
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.grey.shade600,
                  ),
                  tooltip: 'Back to Home',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Header
            const Text(
              'What are you doing\nright now?',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                height: 1.3,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your cognitive needs change moment to moment.\nSelect what fits this session.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),

            // Mode cards
            Expanded(
              child: ListView.builder(
                itemCount: modes.length,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  final mode = modes[index];
                  final isSelected = selectedMode == mode.id;

                  return TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: Duration(milliseconds: 400 + (index * 100)),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: Opacity(opacity: value, child: child),
                      );
                    },
                    child: GestureDetector(
                      onTap: () => setState(() => selectedMode = mode.id),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? mode.color.withOpacity(0.08)
                              : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? mode.color.withOpacity(0.4)
                                : Colors.grey.shade200,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            // Icon
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? mode.color.withOpacity(0.15)
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                mode.icon,
                                color: isSelected
                                    ? mode.color
                                    : Colors.grey.shade500,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Text
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    mode.title,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: isSelected
                                          ? mode.color
                                          : Colors.grey.shade800,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    mode.subtitle,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Duration badge
                            if (isSelected)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: mode.color.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${mode.sprintMinutes}min',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: mode.color,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Info text about selected mode
            if (selectedMode != null)
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Container(
                  key: ValueKey(selectedMode),
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 18,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _getModeExplanation(selectedMode!),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Start button
            PrimaryButton(
              label: 'Begin Sprint',
              onPressed: selectedMode == null ? null : _startSprint,
            ),
            const SizedBox(height: 12),

            // Privacy note
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.offline_bolt_outlined,
                    size: 14,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Your selection stays on-device',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getModeExplanation(String modeId) {
    switch (modeId) {
      case 'learning':
        return 'Lower threshold for frequent micro-breaks. Your brain needs time to consolidate new information.';
      case 'deep_work':
        return 'Balanced threshold for sustained analytical work. Intervention only when fragmentation builds.';
      case 'creating':
        return 'Higher threshold to protect flow states. Creative work needs longer uninterrupted stretches.';
      case 'scattered':
        return 'Gentler thresholds because you\'re already starting depleted. Shorter sprint, earlier intervention.';
      default:
        return '';
    }
  }
}

class ModeOption {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final int threshold;
  final int sprintMinutes;
  final Color color;

  const ModeOption({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.threshold,
    required this.sprintMinutes,
    required this.color,
  });
}
