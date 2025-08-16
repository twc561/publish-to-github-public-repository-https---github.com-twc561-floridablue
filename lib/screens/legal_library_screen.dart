import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/statute.dart';
import '../providers/recent_activity_provider.dart';
import '../services/legal_library_service.dart';
import 'statute_detail_screen.dart';

class LegalLibraryScreen extends StatefulWidget {
  const LegalLibraryScreen({super.key});

  @override
  State<LegalLibraryScreen> createState() => _LegalLibraryScreenState();
}

class _LegalLibraryScreenState extends State<LegalLibraryScreen> {
  final LegalLibraryService _legalLibraryService = LegalLibraryService();
  late List<Statute> _statutes;
  late List<Statute> _filteredStatutes;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _statutes = _legalLibraryService.getStatutes();
    _filteredStatutes = _statutes;
    _searchController.addListener(_filterStatutes);
  }

  void _filterStatutes() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredStatutes = _statutes.where((statute) {
        return statute.title.toLowerCase().contains(query) ||
            statute.number.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterStatutes);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Legal Library',
          style: GoogleFonts.oswald(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search statutes by title or number...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredStatutes.length,
              itemBuilder: (context, index) {
                final statute = _filteredStatutes[index];
                return ListTile(
                  title: Text(statute.title),
                  subtitle: Text("Statute ${statute.number}"),
                  onTap: () {
                    Provider.of<RecentActivityProvider>(context, listen: false).addRecent(statute);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StatuteDetailScreen(statute: statute),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
