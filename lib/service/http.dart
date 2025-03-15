import 'dart:convert';
import 'dart:developer';

import 'package:caseflow/service/firebaseservice.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

Future<String> generateFormattedAIResponse(String prompt) async {
  const String apiKey =
      "AIzaSyAVQu4A7iLsbkf38T_pXcDOayMNhP7bPYI"; // Replace with your API key
  const String url =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey";

  final Map<String, dynamic> requestBody = {
    "contents": [
      {
        "parts": [
          {"text": "Format the response in Markdown and explain:\n\n$prompt"},
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

generateKeyWords(String prompt, String extractedtext,String base64image) async {
  const String apiKey =
      "AIzaSyAVQu4A7iLsbkf38T_pXcDOayMNhP7bPYI"; // Replace with your API key
  const String url =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey";

  final Map<String, dynamic> requestBody = {
    "contents": [
      {
        "parts": [
          {
            "text":
                "Provide a structured sentence containing the following details: Case Name, Date, Case Type, and Judge Number. Format it like: \n\n* **Case Name:** [name]\n* **Date:** [YYYY-MM-DD]\n* **Case Type:** [type]\n* **Judge Number:** [J-number] \n\n$prompt",
          },
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
    String fullText =
        responseData["candidates"]?[0]["content"]?["parts"]?[0]["text"] ??
        "No response";

    // Extracting case details using RegExp
    String caseName =
        RegExp(r'\*\*Case Name:\*\* (.+)').firstMatch(fullText)?.group(1) ??
        "Unknown";
    String caseDate =
        RegExp(r'\*\*Date:\*\* (.+)').firstMatch(fullText)?.group(1) ??
        "Unknown";
    String caseType =
        RegExp(r'\*\*Case Type:\*\* (.+)').firstMatch(fullText)?.group(1) ??
        "Unknown";
    String judgeNumber =
        RegExp(r'\*\*Judge Number:\*\* (.+)').firstMatch(fullText)?.group(1) ??
        "Unknown";
    log(caseName);
    var uuid = Uuid();
    String uniqueId = uuid.v4();
    ;
    Firebaseservice.instance.uploadCaseDetails(
      caseName,
      caseDate,
      caseType,
      judgeNumber,
      extractedtext,
      uniqueId,
      base64image
    );
  } else {
    throw Exception("Failed to fetch response: ${response.body}");
  }
}
