import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechService {
  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _recognizedText = "";

  Future<void> startListening() async {
    bool available = await _speech.initialize(
      onStatus: (status) => print('Speech Status: $status'),
      onError: (error) => print('Speech Error: $error'),
    );

    if (available) {
      _isListening = true;
      _speech.listen(
        onResult: (result) {
          _recognizedText = result.recognizedWords;
          print("Recognized: $_recognizedText");
        },
      );
    } else {
      print("Speech recognition not available");
    }
  }

  void stopListening() {
    _isListening = false;
    _speech.stop();
  }
}
