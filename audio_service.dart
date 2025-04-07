// import 'package:flutter_sound/flutter_sound.dart';
// import 'alert_services.dart';

// class AudioService {
//   FlutterSoundRecorder? _recorder;
//   bool isRecording = false;

//   AudioService() {
//     _recorder = FlutterSoundRecorder();
//   }

//   Future<void> startRecording() async {
//     await _recorder!.openRecorder();
//     await _recorder!.startRecorder(toStream: (data) {
//       analyzeAudio(data);
//     });
//     isRecording = true;
//   }

//   void stopRecording() async {
//     await _recorder!.stopRecorder();
//     await _recorder!.closeRecorder();
//     isRecording = false;
//   }

//   void analyzeAudio(List<int> audioData) {
//     double avgAmplitude = audioData.fold(0, (sum, val) => sum + val.abs()) / audioData.length;

//     if (avgAmplitude > 1000) {  // Adjust threshold after testing
//       AlertService.triggerEmergencyAlert();
//     }
//   }
// }
