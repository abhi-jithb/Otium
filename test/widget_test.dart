import 'package:flutter_test/flutter_test.dart';
import 'package:otium/app/app.dart';
import 'package:provider/provider.dart';
import 'package:otium/state/user_provider.dart';
import 'package:otium/state/sprint_provider.dart';
import 'package:otium/state/fatigue_provider.dart';

void main() {
  testWidgets('App starts with onboarding screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserProvider()),
          ChangeNotifierProvider(create: (_) => SprintProvider()),
          ChangeNotifierProvider(create: (_) => FatigueProvider()),
        ],
        child: const OtiumApp(),
      ),
    );

    expect(find.text('How do you mostly use your phone?'), findsOneWidget);
  });
}
