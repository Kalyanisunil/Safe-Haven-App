import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();
final stt.SpeechToText speech = stt.SpeechToText();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeService();
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
    ),
  );

  service.startService();
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  
  // Ensure Speech is Available
  bool available = await speech.initialize(
    onStatus: (status) => print("Speech Status: $status"),
    onError: (error) => print("Speech Error: $error"),
  );

  if (!available) {
    print("Speech recognition not available");
    return;
  }

  print("Speech recognition started!");

  // Start listening
  speech.listen(
    onResult: (result) {
      print("Recognized Words: ${result.recognizedWords}");
      if (result.recognizedWords.toLowerCase().contains("help me")) {
        triggerAlert();
      }
    },
    listenFor: Duration(seconds: 30),
    pauseFor: Duration(seconds: 3),
    cancelOnError: false,
    partialResults: true,
  );
}

void triggerAlert() {
  notificationsPlugin.show(
    0,
    "Emergency Alert!",
    "Wake word detected: Sending alert...",
    NotificationDetails(
      android: AndroidNotificationDetails(
        'alert_channel',
        'Emergency Alerts',
        importance: Importance.max,
        priority: Priority.high,
      ),
    ),
  );

  print("🚨 ALERT TRIGGERED! 🚨");
}
