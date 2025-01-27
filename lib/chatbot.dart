import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final ScrollController _scrollController =
      ScrollController(); // Scroll controller to auto-scroll

  void _sendMessage() {
    print('Message before sending: ${_controller.text}');
    if (_controller.text.isNotEmpty) {
      setState(() {
        // Add the user's message
        _messages.add({'sender': 'user', 'message': _controller.text});
      });

      // Scroll to the bottom after adding the user's message
      _scrollToBottom();

      // Simulate a delay for bot response
      Future.delayed(Duration(seconds: 1), () {
        // print(${_controller.text});
        String botResponse = _getBotResponse(_controller.text);
        setState(() {
          _messages.add({'sender': 'bot', 'message': botResponse});
        });

        // Scroll to the bottom after adding the bot's message
        _scrollToBottom();
      });

      // Clear the text input field
      _controller.clear();
    }
  }

  String _getBotResponse(String userMessage) {
    // Predefined bot responses
    userMessage = userMessage.trim().toLowerCase();
    print('User Message: $userMessage');
    if (userMessage.toLowerCase().contains('hello')) {
      return "Hello! How can I assist you today?";
    } else if (userMessage.toLowerCase().contains('how are you')) {
      return "I'm doing great! Thanks for asking.";
    } else if (userMessage.toLowerCase().contains('bye')) {
      return "Goodbye! Have a nice day!";
    } else {
      return "I'm sorry, I didn't understand that.";
    }
  }

  // Scroll to the bottom of the list
  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
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
              controller: _scrollController, // Attach the scroll controller
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
