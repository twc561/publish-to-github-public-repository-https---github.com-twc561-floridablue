import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/services/ai_service.dart';
import 'package:myapp/theme_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _searchText = '';
  String _searchResults = '';
  bool _isLoading = false;

  Future<void> _performSearch() async {
    setState(() {
      _isLoading = true;
    });
    final results = await AiService.generateText(_searchText);
    setState(() {
      _searchResults = results;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: Icon(themeProvider.themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => themeProvider.toggleTheme(),
            tooltip: 'Toggle Theme',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search statutes, case law...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onChanged: (text) {
                  setState(() {
                    _searchText = text;
                  });
                },
                onSubmitted: (text) {
                  _performSearch();
                },
              ),
              const SizedBox(height: 20),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: _performSearch,
                  child: const Text('Search'),
                ),
              const SizedBox(height: 20),
              Text(_searchResults),
              const SizedBox(height: 20),
              // Quick Actions Grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildDashboardItem(
                    context,
                    icon: Icons.book,
                    label: 'Legal Library',
                    onTap: () {},
                  ),
                  _buildDashboardItem(
                    context,
                    icon: Icons.cases,
                    label: 'Case Law',
                    onTap: () {},
                  ),
                  _buildDashboardItem(
                    context,
                    icon: Icons.location_on,
                    label: 'Contextual Guidance',
                    onTap: () {},
                  ),
                  _buildDashboardItem(
                    context,
                    icon: Icons.psychology,
                    label: 'AI Scenarios',
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardItem(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withAlpha(25),
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Theme.of(context).primaryColor),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Theme.of(context).colorScheme.secondary),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
      ),
    );
  }
}
