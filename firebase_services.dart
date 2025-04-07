import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<void> addEmergencyContact(String name, String phone) async {
    await _firestore.collection("emergency_contacts").add({
      "name": name,
      "phone": phone,
      "timestamp": FieldValue.serverTimestamp(),
    });
  }


  Stream<QuerySnapshot> getEmergencyContacts() {
    return _firestore.collection("emergency_contacts").orderBy("timestamp").snapshots();
  }

  Future<void> deleteEmergencyContact(String docId) async {
    await _firestore.collection("emergency_contacts").doc(docId).delete();
  }
}
