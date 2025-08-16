import 'package:flutter/foundation.dart';
import '../models/statute.dart';
import '../../features/auth/data/auth_service.dart';
import '../services/firestore_service.dart';

class RecentActivityProvider with ChangeNotifier {
  final AuthService _authService;
  final FirestoreService _firestoreService;
  
  List<Statute> _recentStatutes = [];
  final int _maxRecents = 10;

  RecentActivityProvider(this._authService, this._firestoreService) {
    _authService.addListener(onAuthStateChanged);
    onAuthStateChanged(); // Initial check
  }

  List<Statute> get recentStatutes => _recentStatutes;

  void onAuthStateChanged() {
    if (_authService.isAuthenticated) {
      _fetchRecentActivity();
    } else {
      _recentStatutes = [];
      notifyListeners();
    }
  }

  Future<void> _fetchRecentActivity() async {
    final userId = _authService.user?.uid;
    if (userId == null) return;
    
    _recentStatutes = await _firestoreService.getRecentActivity(userId);
    notifyListeners();
  }

  Future<void> addRecent(Statute statute) async {
    final userId = _authService.user?.uid;
    if (userId == null) return;

    // UI Update First (for responsiveness)
    _recentStatutes.removeWhere((s) => s.number == statute.number);
    _recentStatutes.insert(0, statute);
    if (_recentStatutes.length > _maxRecents) {
      _recentStatutes.removeLast();
    }
    notifyListeners();
    
    // Save to Firestore
    await _firestoreService.saveRecentActivity(userId, statute);
  }

  @override
  void dispose() {
    _authService.removeListener(onAuthStateChanged);
    super.dispose();
  }
}
