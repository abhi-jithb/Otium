import 'package:flutter/material.dart';
import '../core/theme/theme.dart';
import 'router.dart';

class OtiumApp extends StatelessWidget {
  const OtiumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Otium',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: AppRouter.router,
    );
  }
}
