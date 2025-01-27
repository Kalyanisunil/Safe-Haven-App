import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  void _sendMessage() {
    String userMessage = _controller.text.trim();
    print('Message before sending: $userMessage');

    if (userMessage.isNotEmpty) {
      setState(() {
        _messages.add({'sender': 'user', 'message': userMessage});
        _isLoading = true;
      });
      print('Messages after sending: $_messages');

      _scrollToBottom();

      Future.delayed(Duration(seconds: 1), () {
        String botResponse = _getBotResponse(userMessage);
        setState(() {
          _messages.add({'sender': 'bot', 'message': botResponse});
          _isLoading = false;
        });
        print('Messages after bot response: $_messages');

        _scrollToBottom();
      });

      _controller.clear();
    }
  }

  String _getBotResponse(String userMessage) {
    userMessage = userMessage.toLowerCase();
    if (userMessage.contains(RegExp(r'hello|hi'))) {
      return "Hello! How can I assist you today?";
    } else if (userMessage.contains('how are you')) {
      return "I'm doing great! Thanks for asking. How can I help you today?";
    } else if (userMessage.contains(RegExp(r'bye|goodbye'))) {
      return "Goodbye! Have a nice day!";
    } else if (userMessage.contains('help')) {
      return "Sure, I'm here to help. Please tell me what you need assistance with.";
    } else if (userMessage.contains(RegExp(r'thanks|thank you'))) {
      return "You're welcome! Is there anything else I can help with?";
    } else {
      return "I'm sorry, I didn't understand that. Could you please rephrase your message?";
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
