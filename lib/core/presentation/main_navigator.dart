import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/legal_library/presentation/legal_library_screen.dart';
import '../../features/training/presentation/training_screen.dart';
import '../widgets/overflow_menu.dart'; // We'll show this as a modal

class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    DashboardScreen(),
    LegalLibraryScreen(),
    TrainingScreen(),
  ];

  void _onItemTapped(int index) {
    // If the 'Menu' tab is tapped
    if (index == 3) {
      showCustomOverflowMenu(context);
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: _onItemTapped,
        selectedIndex: _selectedIndex,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        indicatorColor: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Library',
          ),
          NavigationDestination(
            icon: Icon(Icons.model_training_outlined),
            selectedIcon: Icon(Icons.model_training),
            label: 'Training',
          ),
          NavigationDestination(
            icon: Icon(Icons.more_horiz_outlined),
            selectedIcon: Icon(Icons.more_horiz),
            label: 'Menu',
          ),
        ],
      ),
    );
  }
}
