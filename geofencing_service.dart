
// import 'dart:async';
// import 'package:geolocator/geolocator.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:telephony_sms/telephony_sms.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';

// class GeofenceService {
//   static const double allowedRadius = 100.0; // 50 meters
//   late StreamSubscription<Position> _positionStream;
//   List<Map<String, double>> safeZones = [];
//   final telephony = TelephonySMS();
//   final FlutterLocalNotificationsPlugin notificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   GeofenceService() {
//     _initializeFirebase();
//   }

//   Future<void> _initializeFirebase() async {
//     await Firebase.initializeApp(); 
//     await _loadSafeZones();
//     await _initNotifications();
//     _startGeofencing();
//   }


//   Future<void> _loadSafeZones() async {
//     final prefs = await SharedPreferences.getInstance();
//     List<String>? savedLocations = prefs.getStringList("safe_zones");

//     if (savedLocations != null) {
//       safeZones = savedLocations.map((location) {
//         List<String> parts = location.split(",");
//         return {
//           "lat": double.parse(parts[0]),
//           "lng": double.parse(parts[1]),
//         };
//       }).toList();
//     }
//   }

//   // Initialize local notifications
//   Future<void> _initNotifications() async {
//     const AndroidInitializationSettings androidSettings =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//     const InitializationSettings initSettings =
//         InitializationSettings(android: androidSettings);
//     await notificationsPlugin.initialize(initSettings);
//   }

 
//   void _startGeofencing() {
//     _positionStream = Geolocator.getPositionStream(
//       locationSettings: const LocationSettings(
//           accuracy: LocationAccuracy.high, distanceFilter: 10),
//     ).listen((Position position) {
//       bool isSafe =
//           _isUserInsideSafeZone(position.latitude, position.longitude);
//       if (!isSafe) {
//         _sendAlert();
//       }
//     });
//   }

//   bool _isUserInsideSafeZone(double lat, double lng) {
//     for (var safeZone in safeZones) {
//       double distance = Geolocator.distanceBetween(
//           lat, lng, safeZone["lat"]!, safeZone["lng"]!);
//       if (distance <= allowedRadius) {
//         return true;
//       }
//     }
//     return false;
//   }

//   void _sendAlert() async {
//     print("Sending alert");
//     _sendNotification("Safety Alert", "You've exited your safe zone!");
//     _sendSMS("I have left a safe zone! Please check on me.");
//   }

//   Future<void> _sendNotification(String title, String body) async {
//     const AndroidNotificationDetails androidDetails =
//         AndroidNotificationDetails(
//       'geofence_alerts',
//       'Geofence Alerts',
//       importance: Importance.high,
//       priority: Priority.high,
//     );
//     const NotificationDetails details =
//         NotificationDetails(android: androidDetails);
//     await notificationsPlugin.show(0, title, body, details);
//   }

//   // Fetch trusted contacts from Firebase
//   Future<List<String>> _getTrustedContacts() async {
//     try {
//       QuerySnapshot snapshot =
//           await FirebaseFirestore.instance.collection('emergency_contacts').get();
//       List<String> contacts = snapshot.docs
//           .map((doc) => doc['phone'].toString()) 
//           .toList();
//       return contacts;
//     } catch (e) {
//       print("Error fetching contacts: $e");
//       return [];
//     }
//   }

//   void _sendSMS(String message) async {
//     List<String> contacts = await _getTrustedContacts();
//     for (String contact in contacts) {
//       telephony.sendSMS(phone: contact, message: message);
//       print("SMS sent to: $contact");
//     }
//   }

//   void dispose() {
//     _positionStream.cancel();
//   }
// }

import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:telephony_sms/telephony_sms.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class GeofenceService {
  late StreamSubscription<Position> _positionStream;
  List<Map<String, dynamic>> safeZones = []; // Store name, lat, lng, and radius
  final telephony = TelephonySMS();
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  GeofenceService() {
    _initializeFirebase();
  }

  Future<void> _initializeFirebase() async {
    await Firebase.initializeApp();
    await _loadSafeZones();
    await _initNotifications();
    _startGeofencing();
  }

  // Load safe zones from SharedPreferences
  Future<void> _loadSafeZones() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? savedLocations = prefs.getStringList("safe_zones");

    if (savedLocations != null) {
      safeZones = savedLocations.map((location) {
        List<String> parts = location.split(",");
        return {
          "name": parts[0], // Location name
          "lat": double.parse(parts[1]),
          "lng": double.parse(parts[2]),
          "radius": double.parse(parts[3]), // Custom radius
        };
      }).toList();
    }
  }

  // Save a new safe zone with name, lat, lng, and radius
  Future<void> saveSafeZone(String name, double lat, double lng, double radius) async {
    final prefs = await SharedPreferences.getInstance();
    safeZones.add({
      "name": name,
      "lat": lat,
      "lng": lng,
      "radius": radius,
    });

    // Save to SharedPreferences
    List<String> savedLocations = safeZones.map((zone) {
      return "${zone["name"]},${zone["lat"]},${zone["lng"]},${zone["radius"]}";
    }).toList();
    await prefs.setStringList("safe_zones", savedLocations);
  }

  // Initialize local notifications
  Future<void> _initNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings =
        InitializationSettings(android: androidSettings);
    await notificationsPlugin.initialize(initSettings);
  }

  // Start geofencing
  void _startGeofencing() {
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high, distanceFilter: 10),
    ).listen((Position position) {
      bool isSafe =
          _isUserInsideSafeZone(position.latitude, position.longitude);
      if (!isSafe) {
        _sendAlert();
      }
    });
  }

  // Check if the user is inside any safe zone
  bool _isUserInsideSafeZone(double lat, double lng) {
    for (var safeZone in safeZones) {
      double distance = Geolocator.distanceBetween(
          lat, lng, safeZone["lat"]!, safeZone["lng"]!);
      if (distance <= safeZone["radius"]!) { // Use custom radius
        return true;
      }
    }
    return false;
  }

  // Send alert when the user exits a safe zone
  void _sendAlert() async {
    print("Sending alert");
    _sendNotification("Safety Alert", "You've exited your safe zone!");
    _sendSMS("I have left a safe zone! Please check on me.");
  }

  // Send local notification
  Future<void> _sendNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'geofence_alerts',
      'Geofence Alerts',
      importance: Importance.high,
      priority: Priority.high,
    );
    const NotificationDetails details =
        NotificationDetails(android: androidDetails);
    await notificationsPlugin.show(0, title, body, details);
  }

  // Fetch trusted contacts from Firebase
  Future<List<String>> _getTrustedContacts() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('emergency_contacts').get();
      List<String> contacts = snapshot.docs
          .map((doc) => doc['phone'].toString())
          .toList();
      return contacts;
    } catch (e) {
      print("Error fetching contacts: $e");
      return [];
    }
  }

  // Send SMS to trusted contacts
  void _sendSMS(String message) async {
    List<String> contacts = await _getTrustedContacts();
    for (String contact in contacts) {
      telephony.sendSMS(phone: contact, message: message);
      print("SMS sent to: $contact");
    }
  }

  // Dispose the position stream
  void dispose() {
    _positionStream.cancel();
  }
}