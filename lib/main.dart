import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'main_navigator.dart';
import 'providers/recent_activity_provider.dart';
import 'theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => RecentActivityProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Define the color palette from the blueprint
    const Color primarySeedColor = Color(0xFF0A2342); // Deep Navy Blue
    const Color accentColor = Color(0xFFD9A404); // "Safety" Gold

    // Define a consistent and modern TextTheme using 'Inter'
    final TextTheme appTextTheme = GoogleFonts.interTextTheme(
      Theme.of(context).textTheme,
    ).copyWith(
      displayLarge: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 57),
      titleLarge: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 22),
      bodyMedium: GoogleFonts.inter(fontSize: 14),
      labelLarge: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 14),
    );

    // Light Theme
    final ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primarySeedColor,
        brightness: Brightness.light,
        primary: primarySeedColor,
        secondary: accentColor,
      ),
      textTheme: appTextTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: primarySeedColor,
        elevation: 0,
        titleTextStyle: appTextTheme.titleLarge?.copyWith(color: primarySeedColor),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        hintStyle: appTextTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
      ),
      cardTheme: CardThemeData( // Corrected from CardTheme
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.white,
      ),
    );

    // Dark Theme
    final ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primarySeedColor,
        brightness: Brightness.dark,
        primary: Colors.white,
        secondary: accentColor,
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
      textTheme: appTextTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: appTextTheme.titleLarge,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[800]?.withOpacity(0.8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        hintStyle: appTextTheme.bodyMedium?.copyWith(color: Colors.grey[400]),
      ),
      cardTheme: CardThemeData( // Corrected from CardTheme
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.grey[900],
      ),
    );

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Florida Blue Guide',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeProvider.themeMode,
          home: const MainNavigator(),
        );
      },
    );
  }
}
