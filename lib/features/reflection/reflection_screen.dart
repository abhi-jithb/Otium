import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/full_screen_container.dart';
import '../../widgets/primary_button.dart';

class ReflectionScreen extends StatefulWidget {
  const ReflectionScreen({super.key});

  @override
  State<ReflectionScreen> createState() => _ReflectionScreenState();
}

class _ReflectionScreenState extends State<ReflectionScreen> {
  double _energyLevel = 5;

  @override
  Widget build(BuildContext context) {
    return FullScreenContainer(
      child: Column(
        children: [
          const Text(
            'How do you feel now?',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Text(
            _energyLevel.round().toString(),
            style: TextStyle(
              fontSize: 80,
              fontWeight: FontWeight.bold,
              color: Colors.green.withOpacity(_energyLevel / 10),
            ),
          ),
          Slider(
            value: _energyLevel,
            min: 1,
            max: 10,
            divisions: 9,
            onChanged: (val) => setState(() => _energyLevel = val),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Drained'),
              Text('Energized'),
            ],
          ),
          const Spacer(),
          PrimaryButton(
            label: 'Complete Session',
            onPressed: () => context.go('/dashboard'),
          ),
        ],
      ),
    );
  }
}
