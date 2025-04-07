import 'package:another_telephony/telephony.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telephony_sms/telephony_sms.dart';
import 'package:safehaven/services/location_service.dart';
import 'package:flutter/material.dart';

class VoiceSOSService {
  final Telephony tel = Telephony.instance;
  final stt.SpeechToText speech = stt.SpeechToText();
  bool _isListening = false;
  String _recognizedText = "";
  List<String> emergencyContacts = [];

  VoiceSOSService() {
    loadEmergencyContacts();
  }

  Future<void> loadEmergencyContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    emergencyContacts = prefs.getStringList('emergencyContacts') ?? [];
  }

  Future<void> sendEmergencySMS(BuildContext context) async {
    var loc = await LocationService.getLocationLink();
    var msg = "Emergency! I'm in danger. Please help and check on me immediately. Location: ${loc ?? 'Location not available'}";

    for (var contact in emergencyContacts) {
      tel.sendSms(to: contact, message: msg);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Emergency Alert Sent!')),
    );
  }

  void startVoiceSOS(BuildContext context) async {
    bool available = await speech.initialize(
      onStatus: (status) {
        print("Speech Status: $status");
      },
      onError: (error) {
        print("Speech Error: $error");
      },
    );

    if (available) {
      _isListening = true;
      speech.listen(
        onResult: (result) {
          _recognizedText = result.recognizedWords;
          print("Recognized: $_recognizedText");

          if (_recognizedText.toLowerCase().contains("help") || 
              _recognizedText.toLowerCase().contains("sos")
              || _recognizedText.toLowerCase().contains("")) {
            sendEmergencySMS(context);
          }
        },
      );
    }
  }

  void stopVoiceSOS() {
    speech.stop();
    _isListening = false;
  }

  bool get isListening => _isListening;
}
