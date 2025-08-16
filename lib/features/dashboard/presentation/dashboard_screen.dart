import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/models/daily_fact.dart';
import '../../../core/models/statute.dart';
import '../../../core/providers/recent_activity_provider.dart';
import '../../../core/services/ai_service.dart';
import '../../legal_library/presentation/statute_detail_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController _searchController = TextEditingController();
  final AiGenService _aiGenService = AiGenService();
  late Future<DailyFact> _dailyFactFuture;

  @override
  void initState() {
    super.initState();
    _dailyFactFuture = _aiGenService.getDailyFact();
  }

  void _performSearch() {
    if (_searchController.text.isEmpty) {
      return;
    }
    final searchedStatute = Statute(title: _searchController.text);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StatuteDetailScreen(statute: searchedStatute),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final recentActivityProvider = Provider.of<RecentActivityProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Florida Blue Guide',
          style: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode
                ? [const Color(0xFF1a237e), const Color(0xFF121212)]
                : [theme.colorScheme.primary.withOpacity(0.1), const Color(0xFFf0f2f5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: [
              const SizedBox(height: 50),
              _buildHeroSearch(theme),
              const SizedBox(height: 32),
              _buildDailyFactSection(theme),
              const SizedBox(height: 32),
              if (recentActivityProvider.recentStatutes.isNotEmpty)
                _buildRecentActivitySection(theme, recentActivityProvider),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildDailyFactSection(ThemeData theme) {
    return FutureBuilder<DailyFact>(
      future: _dailyFactFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return const SizedBox.shrink();
        }
        
        final fact = snapshot.data!.text;

        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 30 * (1 - value)),
                child: child,
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: theme.cardColor.withOpacity(0.8),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  spreadRadius: -3,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb_outline, color: theme.colorScheme.secondary, size: 28),
                      const SizedBox(width: 12),
                      Text(
                        "Did You Know?",
                        style: GoogleFonts.oswald(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    fact,
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      color: theme.colorScheme.onSurface.withOpacity(0.8),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeroSearch(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: -5,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Street Smart Search",
              style: GoogleFonts.oswald(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Get instant, AI-powered breakdowns of any Florida statute.",
              style: GoogleFonts.lato(
                fontSize: 16,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 20),
            _buildSearchField(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField(ThemeData theme) {
    return TextField(
      controller: _searchController,
      onSubmitted: (_) => _performSearch(),
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'e.g., "Use of force on a fleeing felon"',
        hintStyle: GoogleFonts.lato(),
        prefixIcon: Icon(Icons.search, color: theme.colorScheme.primary),
        suffixIcon: IconButton(
          icon: const Icon(Icons.send),
          onPressed: _performSearch,
          color: theme.colorScheme.secondary,
        ),
        filled: true,
        fillColor: theme.scaffoldBackgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildRecentActivitySection(ThemeData theme, RecentActivityProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Recent Activity",
          style: GoogleFonts.oswald(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: provider.recentStatutes.length,
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemBuilder: (context, index) {
              final statute = provider.recentStatutes[index];
              return SizedBox(
                width: 220,
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  shadowColor: Colors.black.withOpacity(0.2),
                  margin: const EdgeInsets.only(right: 16),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StatuteDetailScreen(statute: statute),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            statute.title,
                            style: GoogleFonts.lato(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Spacer(),
                          Text(
                            "Statute ${statute.number}",
                            style: GoogleFonts.lato(
                              color: theme.colorScheme.onSurface.withOpacity(0.6),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
