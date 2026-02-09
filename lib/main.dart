import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app/app.dart';
import 'state/user_provider.dart';
import 'state/sprint_provider.dart';
import 'state/fatigue_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => SprintProvider()),
        ChangeNotifierProvider(create: (_) => FatigueProvider()),
      ],
      child: const OtiumApp(),
    ),
  );
}
