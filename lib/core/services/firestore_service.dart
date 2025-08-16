import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/statute.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveRecentActivity(String userId, Statute statute) async {
    final docRef = _db.collection('users').doc(userId).collection('recentActivity').doc(statute.number);
    await docRef.set({
      'title': statute.title,
      'number': statute.number,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<List<Statute>> getRecentActivity(String userId) async {
    final snapshot = await _db
        .collection('users')
        .doc(userId)
        .collection('recentActivity')
        .orderBy('timestamp', descending: true)
        .limit(10)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Statute(
        title: data['title'],
        number: data['number'],
      );
    }).toList();
  }
}
