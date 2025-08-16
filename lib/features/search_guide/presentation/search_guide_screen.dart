import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/legal_guide_repository.dart';

// Enum to manage the different states of the search UI
enum SearchState { initial, loading, success, error }

class SearchGuideScreen extends StatefulWidget {
  const SearchGuideScreen({super.key});

  @override
  State<SearchGuideScreen> createState() => _SearchGuideScreenState();
}

class _SearchGuideScreenState extends State<SearchGuideScreen> {
  final _repository = LegalGuideRepository();
  final _searchController = TextEditingController();

  SearchState _state = SearchState.initial;
  MapEntry<String, String>? _result;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Performs the search operation and updates the UI state.
  Future<void> _performSearch(String query) async {
    if (query.isEmpty) return;
    
    setState(() {
      _state = SearchState.loading;
    });

    final result = await _repository.search(query);

    if (mounted) {
      setState(() {
        if (result != null) {
          _state = SearchState.success;
          _result = result;
        } else {
          _state = SearchState.error;
          _result = null;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search & Seizure Guide',
          style: GoogleFonts.oswald(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          _buildSearchBar(theme),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _buildBody(),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the search bar widget.
  Widget _buildSearchBar(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        autofocus: true,
        textInputAction: TextInputAction.search,
        onSubmitted: _performSearch,
        decoration: InputDecoration(
          hintText: "Ask about a principle (e.g., 'Plain View')",
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              setState(() {
                _state = SearchState.initial;
                _result = null;
              });
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          filled: true,
        ),
      ),
    );
  }

  /// Builds the body of the screen based on the current search state.
  Widget _buildBody() {
    switch (_state) {
      case SearchState.initial:
        return _buildInitialState();
      case SearchState.loading:
        return const Center(child: CircularProgressIndicator());
      case SearchState.success:
        return _buildSuccessState(_result!);
      case SearchState.error:
        return _buildErrorState();
    }
  }

  /// The UI shown before any search is performed.
  Widget _buildInitialState() {
    return ListView(
      key: const ValueKey('initial'),
      padding: const EdgeInsets.all(16.0),
      children: [
        Text(
          'Common Topics',
          style: GoogleFonts.oswald(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _TopicChip(
          label: 'Plain View Doctrine',
          onTap: () => _performSearch('Plain View'),
        ),
        _TopicChip(
          label: 'Terry Frisk',
          onTap: () => _performSearch('Terry Frisk'),
        ),
        _TopicChip(
          label: 'Search Incident to Arrest',
          onTap: () => _performSearch('Search Incident to Arrest'),
        ),
        _TopicChip(
          label: 'Exclusionary Rule',
          onTap: () => _performSearch('Exclusionary Rule'),
        ),
      ],
    );
  }

  /// The UI shown when a search result is successfully found.
  Widget _buildSuccessState(MapEntry<String, String> result) {
    final title = result.key.replaceAll('_', ' ').split(' ').map((word) => '${word[0].toUpperCase()}${word.substring(1)}').join(' ');
    final description = result.value;

    return SingleChildScrollView(
      key: ValueKey(result.key),
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.oswald(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const Divider(height: 20),
              Text(
                description,
                style: GoogleFonts.lato(fontSize: 16, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// The UI shown when no results are found.
  Widget _buildErrorState() {
    return Center(
      key: const ValueKey('error'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'No matching principles found.',
            style: GoogleFonts.lato(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _TopicChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _TopicChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      onPressed: onTap,
      label: Text(label),
      avatar: const Icon(Icons.gavel_outlined),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
    );
  }
}
