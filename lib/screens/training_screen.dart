import 'package:flutter/material.dart';
import '../models/training_scenario.dart';
import '../services/training_service.dart';
import 'chat_screen.dart';

class TrainingScreen extends StatefulWidget {
  const TrainingScreen({super.key});

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  final TrainingService _trainingService = TrainingService();
  late List<TrainingScenario> _scenarios;

  @override
  void initState() {
    super.initState();
    _scenarios = _trainingService.getScenarios();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Interactive Training",
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _scenarios.length,
        padding: const EdgeInsets.all(8.0),
        itemBuilder: (context, index) {
          final scenario = _scenarios[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            elevation: 3,
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(
                scenario.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(scenario.description),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(scenario: scenario),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
