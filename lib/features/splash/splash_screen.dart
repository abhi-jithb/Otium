import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/colors.dart';
import '../../state/user_provider.dart';
import '../../widgets/full_screen_container.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _breathController;
  late AnimationController _textController;
  late AnimationController _loadingController;

  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _breathAnimation;
  late Animation<double> _textOpacity;
  late Animation<Offset> _textSlide;

  @override
  void initState() {
    super.initState();

    // Logo entrance animation
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // Breathing pulse animation
    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat(reverse: true);

    // Text entrance animation
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Loading indicator rotation
    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _breathAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOutSine),
    );

    _textOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    _textSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
        );

    // Staggered animation sequence
    _logoController.forward();
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) _textController.forward();
    });

    // Navigate after animations
    Future.delayed(const Duration(milliseconds: 3200), () {
      if (mounted) _checkNavigation();
    });
  }

  void _checkNavigation() {
    final userProvider = context.read<UserProvider>();
    if (userProvider.profile.hasRole) {
      context.go('/');
    } else {
      context.go('/onboarding');
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _breathController.dispose();
    _textController.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FullScreenContainer(
      backgroundColor: AppColors.background,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 3),
            // Premium logo with organic breathing animation
            AnimatedBuilder(
              animation: Listenable.merge([_logoController, _breathController]),
              builder: (context, child) {
                final breathValue = _breathAnimation.value;
                return FadeTransition(
                  opacity: _logoOpacity,
                  child: Transform.scale(
                    scale: _logoScale.value,
                    child: SizedBox(
                      width: 140,
                      height: 140,
                      child: CustomPaint(
                        painter: _OtiumLogoPainter(
                          breathPhase: breathValue,
                          primaryColor: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 48),
            // Brand name with refined typography
            SlideTransition(
              position: _textSlide,
              child: FadeTransition(
                opacity: _textOpacity,
                child: Column(
                  children: [
                    Text(
                      'OTIUM',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w200,
                        letterSpacing: 12,
                        color: AppColors.textBody,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 40,
                      height: 1,
                      color: AppColors.primary.withOpacity(0.3),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'cognitive restoration',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 3,
                        color: AppColors.textDim,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(flex: 2),
            // App logo with rotation animation
            FadeTransition(
              opacity: _textOpacity,
              child: AnimatedBuilder(
                animation: _loadingController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _loadingController.value * 2 * math.pi,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.2),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}

/// Custom painter for the Otium logo - organic, breathing circles
class _OtiumLogoPainter extends CustomPainter {
  final double breathPhase;
  final Color primaryColor;

  _OtiumLogoPainter({required this.breathPhase, required this.primaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    // Outer glow ring (breathes)
    final outerRadius = maxRadius * (0.85 + breathPhase * 0.15);
    final outerPaint = Paint()
      ..color = primaryColor.withOpacity(0.08 + breathPhase * 0.04)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, outerRadius, outerPaint);

    // Middle ring
    final middleRadius = maxRadius * (0.6 + breathPhase * 0.08);
    final middlePaint = Paint()
      ..color = primaryColor.withOpacity(0.15 + breathPhase * 0.05)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, middleRadius, middlePaint);

    // Core circle (solid, subtle shadow)
    final coreRadius = maxRadius * 0.35;

    // Shadow
    final shadowPaint = Paint()
      ..color = primaryColor.withOpacity(0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawCircle(center.translate(0, 4), coreRadius, shadowPaint);

    // Core
    final corePaint = Paint()
      ..shader = RadialGradient(
        colors: [primaryColor, primaryColor.withOpacity(0.85)],
        stops: const [0.3, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: coreRadius));
    canvas.drawCircle(center, coreRadius, corePaint);

    // Inner highlight
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.25)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      center.translate(-coreRadius * 0.25, -coreRadius * 0.25),
      coreRadius * 0.2,
      highlightPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _OtiumLogoPainter oldDelegate) {
    return oldDelegate.breathPhase != breathPhase;
  }
}
