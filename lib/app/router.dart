import 'package:go_router/go_router.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/home/home_screen.dart';
import '../features/sprint/sprint_screen.dart';
import '../features/intervention/breathing_screen.dart';
import '../features/recovery/recovery_screen.dart';
import '../features/reflection/reflection_screen.dart';
import '../features/dashboard/dashboard_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/onboarding',
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/sprint',
        builder: (context, state) => const SprintScreen(),
      ),
      GoRoute(
        path: '/intervention',
        builder: (context, state) => const BreathingScreen(),
      ),
      GoRoute(
        path: '/recovery',
        builder: (context, state) => const RecoveryScreen(),
      ),
      GoRoute(
        path: '/reflection',
        builder: (context, state) => const ReflectionScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
    ],
  );
}
