import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme_provider.dart';
import '../screens/settings_screen.dart';

class OverflowMenu extends StatelessWidget {
  const OverflowMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor.withOpacity(0.85),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
            _buildMenuItem(
              context: context,
              icon: Icons.settings,
              title: 'Settings',
              onTap: () {
                Navigator.pop(context); // Close the menu first
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
              },
            ),
            _buildMenuItem(
              context: context,
              icon: themeProvider.themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
              title: themeProvider.themeMode == ThemeMode.dark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
              onTap: () {
                themeProvider.toggleTheme();
                Navigator.pop(context);
              },
            ),
            _buildMenuItem(
              context: context,
              icon: Icons.info_outline,
              title: 'About',
              onTap: () {
                // Placeholder for About screen
                Navigator.pop(context);
              },
            ),
            const Divider(height: 20),
            _buildMenuItem(
              context: context,
              icon: Icons.logout,
              title: 'Logout',
              color: Colors.redAccent,
              onTap: () {
                // Placeholder for Logout
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    final theme = Theme.of(context);
    final itemColor = color ?? theme.colorScheme.onSurface;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        child: Row(
          children: [
            Icon(icon, color: itemColor),
            const SizedBox(width: 16),
            Text(
              title,
              style: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: itemColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showCustomOverflowMenu(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => const OverflowMenu(),
  );
}
