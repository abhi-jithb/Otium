import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app/app.dart';
import 'state/user_provider.dart';
import 'state/sprint_provider.dart';
import 'state/fatigue_provider.dart';
import 'core/utils/persistence_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final persistenceService = await PersistenceService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider(persistenceService)),
        ChangeNotifierProvider(
          create: (_) => SprintProvider(persistenceService),
        ),
        ChangeNotifierProvider(
          create: (_) => FatigueProvider(persistenceService),
        ),
      ],
      child: const OtiumApp(),
    ),
  );
}
