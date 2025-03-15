import 'dart:convert';

import 'package:http/http.dart' as http;

Future<String> generateFormattedAIResponse(String prompt) async {
  const String apiKey = "AIzaSyAVQu4A7iLsbkf38T_pXcDOayMNhP7bPYI"; // Replace with your API key
  const String url =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey";

  final Map<String, dynamic> requestBody = {
    "contents": [
      {
        "parts": [
          {
            "text": "Format the response in Markdown and explain:\n\n$prompt"
          }
        ]
      }
    ]
  };

  final response = await http.post(
    Uri.parse(url),
    headers: {
      "Content-Type": "application/json",
    },
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
