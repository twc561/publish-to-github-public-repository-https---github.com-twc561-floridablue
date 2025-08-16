import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../auth/data/auth_service.dart';
import '../../../core/providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.oswald(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSettingsSection(
            theme,
            title: 'Appearance',
            children: [
              const SizedBox(height: 8),
              SegmentedButton<ThemeMode>(
                segments: const [
                  ButtonSegment(value: ThemeMode.light, label: Text('Light'), icon: Icon(Icons.light_mode)),
                  ButtonSegment(value: ThemeMode.dark, label: Text('Dark'), icon: Icon(Icons.dark_mode)),
                  ButtonSegment(value: ThemeMode.system, label: Text('System'), icon: Icon(Icons.auto_mode)),
                ],
                selected: {themeProvider.themeMode},
                onSelectionChanged: (newSelection) {
                  themeProvider.setThemeMode(newSelection.first);
                },
              ),
              const SizedBox(height: 24),
              Text(
                'Text Size',
                style: theme.textTheme.titleMedium,
              ),
              Slider(
                value: themeProvider.textScaleFactor,
                min: 0.8,
                max: 1.5,
                divisions: 7,
                label: themeProvider.textScaleFactor.toStringAsFixed(1),
                onChanged: (value) {
                  themeProvider.setTextScaleFactor(value);
                },
              ),
              Center(
                child: Text(
                  'This is how the text will look.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontSize: 16 * themeProvider.textScaleFactor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSettingsSection(
            theme,
            title: 'Account',
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  await authService.signOut();
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.error,
                  foregroundColor: theme.colorScheme.onError,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(ThemeData theme, {required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.oswald(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }
}
