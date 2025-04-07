import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_profile.dart'; // Import the UserProfile model

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveUserProfile(UserProfile userProfile) async {
    // Save the user profile to the 'users' collection
    await _firestore.collection('users').doc(userProfile.id).set(userProfile.toMap());
  }
}