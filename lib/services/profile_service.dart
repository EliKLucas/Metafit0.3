import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_profile.dart';

class ProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createProfile(UserProfile profile) async {
    await _firestore
        .collection('userProfiles')
        .doc(profile.userId)
        .set(profile.toMap());
  }

  Future<UserProfile?> getProfile(String userId) async {
    final doc = await _firestore.collection('userProfiles').doc(userId).get();
    if (doc.exists) {
      return UserProfile.fromMap(doc.data()!..['userId'] = doc.id);
    }
    return null;
  }

  Future<void> updateProfile(UserProfile profile) async {
    await _firestore
        .collection('userProfiles')
        .doc(profile.userId)
        .update(profile.toMap());
  }

  Stream<UserProfile?> profileStream(String userId) {
    return _firestore.collection('userProfiles').doc(userId).snapshots().map((
      doc,
    ) {
      if (doc.exists) {
        return UserProfile.fromMap(doc.data()!..['userId'] = doc.id);
      }
      return null;
    });
  }
}
