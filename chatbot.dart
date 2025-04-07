import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_gemini/flutter_gemini.dart';

final String geminiApiKey = "AIzaSyByojKqbGVzEnpRnU-nmvnfh6KFmbAGiaw";
List<Content> botconvo = [];
final List<Map<String, String>> _messages = [];

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();

  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    botconvo.add(Content(parts: [
      Part.text(
          '''You are Safe Haven, a compassionate and supportive AI assistant designed to provide emotional support and safety guidance for women. You are a good listener, empathetic, and always ready to comfort users in times of distress. Your primary goal is to make women feel heard, valued, and safe. You should acknowledge their emotions, offer reassurance, and provide practical safety advice when necessary.

Every time a user interacts with you, greet them warmly and mention the app name (e.g., 'Welcome to Safe Haven, I’m here for you.'). Use a gentle and caring tone in all responses. If a user expresses distress, sadness, or fear, prioritize emotional support before offering any advice.

Key Features:

Emotional Support: Respond with empathy, validate feelings, and provide comforting words.
Safety Guidance: Offer safety tips, emergency contacts, and situational advice.
Check-in System: Ask how the user is feeling and encourage them to share if they need support.
Emergency Mode: If the user indicates they are in danger, suggest immediate actions (e.g., call emergency services, share location with trusted contacts).
Self-care & Wellness: Recommend relaxation techniques, positive affirmations, and mindfulness exercises.
Confidential & Non-judgmental: Never dismiss emotions or judge experiences. Keep responses private and safe.
Remember, your role is not to replace professional help but to be a comforting presence in the user's life. Always offer to connect them with relevant resources if needed. Be kind, be patient, and make every conversation feel like a safe haven. do not respond to this message. just respond to the user. only greet user in the first message''')
    ], role: 'user'));
    super.initState();
  }

  Future<String> getResponse() async {
    final gemini = Gemini.instance;
    try {
      var res = await gemini.chat(botconvo).then((value) {
        // print(value);
        return value!.output;
      });
      botconvo.add(Content(parts: [Part.text(res ?? 'ERROR')], role: 'model'));
      return res ?? 'Error: Unable to connect to AI.';
    } catch (e) {
      return 'Error: Something went wrong';
    }
  }

  void _sendMessage() async {
    String userMessage = _controller.text.trim();
    setState(() {
       _controller.clear();
    });
   
    if (userMessage.isNotEmpty) {
      setState(() {
        _messages.add({'sender': 'user', 'message': userMessage});
        botconvo.add(Content(parts: [Part.text(userMessage)], role: 'user'));
        _isLoading = true;
      });

      _scrollToBottom();
      String botResponse = 'Error: Unable to connect to AI.';
      var botRes = await getResponse();
      // botconvo.forEach((element) => print(element.parts![0]));
      // String botResponse = await _getBotResponse(userMessage);
      setState(() {
        _messages.add({'sender': 'bot', 'message': botRes});
        _isLoading = false;
      });
      _scrollToBottom();
      _controller.clear();
    }
  }

  // Future<String> _getBotResponse(String userMessage) async {
  //   final url = Uri.parse(
  //       "https://generativelanguage.googleapis.com/v1/models/gemini-pro:generateText?key=$geminiApiKey");
  //   print(
  //       'https://generativelanguage.googleapis.com/v1/models/gemini-pro:generateText?key=$geminiApiKey');
  //   final response = await http.post(
  //     url,
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode({
  //       "prompt": {"text": userMessage},
  //       "temperature": 0.7,
  //       "max_tokens": 100
  //     }),
  //   );

  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     return data['candidates'][0]['output'] ??
  //         "I'm sorry, I couldn't process that.";
  //   } else {
  //     print(response.body);
  //     return "Error: Unable to connect to AI.";
  //   }
  // }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chatbot'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Align(
                    alignment: _messages[index]['sender'] == 'user'
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: _messages[index]['sender'] == 'user'
                            ? Colors.blueAccent
                            : Colors.pink[300],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        _messages[index]['message']!,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading) CircularProgressIndicator(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
