import 'dart:convert';
import 'package:http/http.dart' as http;

final String geminiApiKey = "AIzaSyByojKqbGVzEnpRnU-nmvnfh6KFmbAGiaw";

Future<String> _getBotResponse(String userMessage) async {
  final url = Uri.parse("https://generativelanguage.googleapis.com/v1/models/gemini-pro:generateText?key=$geminiApiKey");

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      "prompt": {"text": userMessage},
      "temperature": 0.7,
      "max_tokens": 100
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['candidates'][0]['output'] ?? "I'm sorry, I couldn't process that.";
  } else {
    return "Error: Unable to connect to AI.";
  }
}
