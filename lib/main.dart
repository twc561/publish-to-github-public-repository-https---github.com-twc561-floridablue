import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'core/presentation/main_navigator.dart';
import 'features/auth/presentation/auth_wrapper.dart';
import 'firebase_options.dart';
import 'core/providers/recent_activity_provider.dart';
import 'features/auth/data/auth_service.dart';
import 'core/services/firestore_service.dart';
import 'core/providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthService()),
        Provider(create: (_) => FirestoreService()),
        ChangeNotifierProxyProvider<AuthService, RecentActivityProvider>(
          create: (context) => RecentActivityProvider(
            Provider.of<AuthService>(context, listen: false),
            Provider.of<FirestoreService>(context, listen: false),
          ),
          update: (context, auth, previous) =>
              previous!..onAuthStateChanged(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        // Define base TextTheme
        final TextTheme baseTextTheme = GoogleFonts.interTextTheme(
          Theme.of(context).textTheme,
        );

        // Apply the text scale factor
        final TextTheme appTextTheme = baseTextTheme.apply(
          fontSizeFactor: themeProvider.textScaleFactor,
        ).copyWith(
          displayLarge: GoogleFonts.inter(fontWeight: FontWeight.bold),
          titleLarge: GoogleFonts.inter(fontWeight: FontWeight.w600),
          bodyMedium: GoogleFonts.inter(),
          labelLarge: GoogleFonts.inter(fontWeight: FontWeight.w500),
        );

        const Color primarySeedColor = Color(0xFF0A2342);
        const Color accentColor = Color(0xFFD9A404);

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
          cardTheme: CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: Colors.white,
          ),
        );

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
          cardTheme: CardThemeData(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: Colors.grey[900],
          ),
        );

        return MaterialApp(
          title: 'Florida Blue Guide',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeProvider.themeMode,
          home: const AuthWrapper(),
        );
      },
    );
  }
}
