import 'package:telephony/telephony.dart';
import 'firebase_services.dart';

class AlertService {
  static final Telephony telephony = Telephony.instance;
  static final FirebaseService _firebaseService = FirebaseService();

  static void sendSMSAlert() async {
    List<String> contacts = await _getEmergencyContacts();
    
    for (String contact in contacts) {
      telephony.sendSms(
        to: contact,
        message: "🚨 Emergency! Suspicious activity detected. Please check."
      );
    }
  }

  static Future<List<String>> _getEmergencyContacts() async {
    List<String> phoneNumbers = [];
    final snapshot = await _firebaseService.getEmergencyContacts().first;
    for (var doc in snapshot.docs) {
      phoneNumbers.add(doc["phone"]);
    }
    return phoneNumbers;
  }
}
