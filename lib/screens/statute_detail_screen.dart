import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import '../models/statute.dart';
import '../providers/recent_activity_provider.dart';
import '../services/ai_service.dart';

class StatuteDetailScreen extends StatefulWidget {
  final Statute statute;

  const StatuteDetailScreen({super.key, required this.statute});

  @override
  State<StatuteDetailScreen> createState() => _StatuteDetailScreenState();
}

class _StatuteDetailScreenState extends State<StatuteDetailScreen> {
  late Future<Statute> _statuteDetailsFuture;
  final AiGenService _aiGenService = AiGenService();

  @override
  void initState() {
    super.initState();
    // Fetch details and add the statute to recent activity
    _statuteDetailsFuture = _aiGenService.generateStatuteDetails(widget.statute.title).then((details) {
      // Once details (including the number) are fetched, add to recent activity
      Provider.of<RecentActivityProvider>(context, listen: false).addRecent(details);
      return details;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: FutureBuilder<Statute>(
        future: _statuteDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              appBar: AppBar(title: Text(widget.statute.title)),
              body: const Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.severity.isEmpty) {
            return Scaffold(
              appBar: AppBar(title: const Text("Error")),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    snapshot.error?.toString() ?? "Could not load details. Please check your connection and try again.",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              ),
            );
          }

          final statute = snapshot.data!;

          return Scaffold(
             appBar: AppBar(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    statute.title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                  ),
                  if (statute.number.isNotEmpty)
                    Text(
                      "Statute ${statute.number}",
                      style: theme.textTheme.titleSmall?.copyWith(color: Colors.white70),
                    ),
                ],
              ),
               backgroundColor: theme.colorScheme.primary,
               elevation: 4,
            ),
            body: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildSectionCard(
                  context: context,
                  icon: Icons.gavel,
                  title: 'Severity',
                  content: Text(
                    statute.severity,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildSectionCard(
                  context: context,
                  icon: Icons.list_alt,
                  title: 'Elements of the Crime',
                  content: MarkdownBody(
                    data: statute.elements,
                    styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                      p: theme.textTheme.bodyLarge,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildSectionCard(
                  context: context,
                  icon: Icons.visibility,
                  title: 'Real-World Examples',
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: statute.examples.map((example) => Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.check_circle_outline, size: 20, color: theme.colorScheme.secondary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              example,
                              style: theme.textTheme.bodyLarge,
                            ),
                          ),
                        ],
                      ),
                    )).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Widget content,
  }) {
    final theme = Theme.of(context);
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: theme.colorScheme.primary, size: 28),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),
            content,
          ],
        ),
      ),
    );
  }
}
