import 'package:flutter/foundation.dart';
import '../models/statute.dart';

class RecentActivityProvider with ChangeNotifier {
  final List<Statute> _recentStatutes = [];
  final int _maxRecents = 5;

  List<Statute> get recentStatutes => _recentStatutes;

  void addRecent(Statute statute) {
    // Avoid duplicates by removing the statute if it already exists
    _recentStatutes.removeWhere((s) => s.title == statute.title);

    // Add the new statute to the beginning of the list
    _recentStatutes.insert(0, statute);

    // Ensure the list doesn't grow too large
    if (_recentStatutes.length > _maxRecents) {
      _recentStatutes.removeLast();
    }

    notifyListeners();
  }
}
