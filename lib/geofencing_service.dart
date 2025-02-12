import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:telephony/telephony.dart';

class GeofenceService {
  static const double allowedRadius = 100.0; // 100 meters
  late StreamSubscription<Position> _positionStream;
  List<Map<String, double>> safeZones = [];
  final Telephony telephony = Telephony.instance;
  final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

  GeofenceService() {
    _loadSafeZones();
    _initNotifications();
    _startGeofencing();
  }

  // Load saved safe locations
  Future<void> _loadSafeZones() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? savedLocations = prefs.getStringList("safe_zones");

    if (savedLocations != null) {
      safeZones = savedLocations.map((location) {
        List<String> parts = location.split(",");
        return {
          "lat": double.parse(parts[0]),
          "lng": double.parse(parts[1]),
        };
      }).toList();
    }
  }

  // Initialize local notifications
  Future<void> _initNotifications() async {
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings = InitializationSettings(android: androidSettings);
    await notificationsPlugin.initialize(initSettings);
  }

  // Start geofencing
  void _startGeofencing() {
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 10),
    ).listen((Position position) {
      bool isSafe = _isUserInsideSafeZone(position.latitude, position.longitude);
      if (!isSafe) {
        _sendAlert();
      }
    });
  }

  // Check if user is inside any safe zone
  bool _isUserInsideSafeZone(double lat, double lng) {
    for (var safeZone in safeZones) {
      double distance = Geolocator.distanceBetween(lat, lng, safeZone["lat"]!, safeZone["lng"]!);
      if (distance <= allowedRadius) {
        return true;
      }
    }
    return false;
  }

  // Send alert notification & SMS
  void _sendAlert() async {
    _sendNotification("Safety Alert", "You've exited your safe zone!");
    _sendSMS("You have left your safe zone! Please check in.");
  }

  // Send local notification
  Future<void> _sendNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'geofence_alerts', 'Geofence Alerts',
      importance: Importance.high, priority: Priority.high,
    );
    const NotificationDetails details = NotificationDetails(android: androidDetails);
    await notificationsPlugin.show(0, title, body, details);
  }

  // Send SMS alert to trusted contacts
  void _sendSMS(String message) async {
    List<String> contacts = await _getTrustedContacts();
    for (String contact in contacts) {
      telephony.sendSms(to: contact, message: message);
    }
  }

  // Get trusted contacts
  Future<List<String>> _getTrustedContacts() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList("trusted_contacts") ?? [];
  }

  // Dispose the stream when not needed
  void dispose() {
    _positionStream.cancel();
  }
}
