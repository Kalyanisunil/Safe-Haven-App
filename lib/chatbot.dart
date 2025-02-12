import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
final String geminiApiKey = "AIzaSyByojKqbGVzEnpRnU-nmvnfh6KFmbAGiaw";
class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  void _sendMessage() async {
  String userMessage = _controller.text.trim();

  if (userMessage.isNotEmpty) {
    setState(() {
      _messages.add({'sender': 'user', 'message': userMessage});
      _isLoading = true;
    });

    _scrollToBottom();

    String botResponse = await _getBotResponse(userMessage);

    setState(() {
      _messages.add({'sender': 'bot', 'message': botResponse});
      _isLoading = false;
    });

    _scrollToBottom();
    _controller.clear();
  }
}


 

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
