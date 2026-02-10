import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/theme.dart';
import '../state/fatigue_provider.dart';
import '../state/sprint_provider.dart';
import 'router.dart';

/// OtiumApp: Root widget with app-level lifecycle management.
///
/// Handles:
/// - Foreground/background transitions
/// - State persistence triggers
/// - Global gesture detection for scroll sensing
class OtiumApp extends StatefulWidget {
  const OtiumApp({super.key});

  @override
  State<OtiumApp> createState() => _OtiumAppState();
}

class _OtiumAppState extends State<OtiumApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final fatigue = context.read<FatigueProvider>();
    final sprint = context.read<SprintProvider>();

    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        // App going to background
        fatigue.onAppBackgrounded();
        sprint.pauseSprint();
        debugPrint('📱 App lifecycle: backgrounded');
        break;

      case AppLifecycleState.resumed:
        // App returning to foreground
        fatigue.onAppForegrounded();
        // Sprint will be resumed by the sprint screen itself
        debugPrint('📱 App lifecycle: resumed');
        break;

      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        // App being terminated or hidden
        debugPrint('📱 App lifecycle: detached/hidden');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      // Global scroll detection for friction tracking
      onNotification: (notification) {
        final fatigue = context.read<FatigueProvider>();

        if (notification is ScrollStartNotification) {
          fatigue.onScrollStart();
        } else if (notification is ScrollEndNotification) {
          fatigue.onScrollEnd();
        } else if (notification is ScrollUpdateNotification) {
          fatigue.onScrollUpdate();
        }

        return false; // Allow notification to continue propagating
      },
      child: MaterialApp.router(
        title: 'Otium',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
