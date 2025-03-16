import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
 
  const ChatScreen({Key? key,  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();

  Future<String> generateAIResponse(String prompt) async {
    const String apiKey =
        "AIzaSyAVQu4A7iLsbkf38T_pXcDOayMNhP7bPYI"; // Replace with your API key
    const String url =
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey";

    final Map<String, dynamic> requestBody = {
      "contents": [
        {
          "parts": [
            {"text": "speak like a professional lawyer : $prompt"},
          ],
        },
      ],
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return responseData["candidates"]?[0]["content"]?["parts"]?[0]["text"] ??
          "No response";
    } else {
      throw Exception("Failed to fetch response: ${response.body}");
    }
  }

  void _sendMessage() async {
    if (_messageController.text.isEmpty) return;

    String userMessage = _messageController.text;
    setState(() {
      _messages.add({"sender": "user", "message": userMessage});
      _isLoading = true;
    });
    _messageController.clear();
    _scrollToBottom();

    try {
      String aiResponse = await generateAIResponse(userMessage);
      setState(() {
        _messages.add({"sender": "ai", "message": aiResponse});
      });
    } catch (e) {
      setState(() {
        _messages.add({"sender": "ai", "message": "Error fetching response."});
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Container(
       
        decoration: const BoxDecoration(
         image: DecorationImage(image:  AssetImage("assets/image/SupremeCourt-red.png",),opacity: 0.2,fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            // Custom App Bar with curved bottom
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top,
                left: 8,
                right: 8,
                bottom: 16,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFFB22222),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Gap(50),
                       Image.asset('assets/image/logo_Ai.png', height: 40),
                    
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Conversation on Case',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            // Chat Messages
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                reverse: true,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[_messages.length - 1 - index];
                  final isUser = message["sender"] == "user";

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment:
                          isUser
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!isUser) _buildAvatarIcon(),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color:
                                  isUser
                                      ? Colors.white
                                      : const Color(0xFFF0F0F0),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color:
                                    isUser
                                        ? const Color(0xFFB22222)
                                        : Colors.transparent,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              message["message"]!,
                              style: TextStyle(
                                color:
                                    isUser
                                        ? const Color(0xFFB22222)
                                        : Colors.black87,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (isUser)
                          const CircleAvatar(
                            radius: 16,
                            backgroundColor: Color(0xFFB22222),
                            child: Text(
                              'you',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Loading Indicator
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFB22222)),
                ),
              ),

            // Message Input
            Container(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 8,
                bottom: 8 + MediaQuery.of(context).padding.bottom,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFFB22222)),
                      ),
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: "type your message...",
                          hintStyle: TextStyle(color: Colors.grey,fontSize: 16 ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFB22222),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarIcon() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFB22222), width: 2),
      ),
      child: const CircleAvatar(
        radius: 16,
        backgroundColor: Colors.white,
        child: Icon(
          Icons.smart_toy_outlined,
          size: 20,
          color: Color(0xFFB22222),
        ),
      ),
    );
  }
}
