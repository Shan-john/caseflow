import 'dart:convert';
import 'dart:developer';

import 'package:caseflow/service/firebaseservice.dart';
import 'package:flutter/material.dart';
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
          {
            "text":
                """I have a large block of text obtained from OCR. The text is unformatted, lacks proper punctuation, and might have errors. I need you to clean it up by:
Correcting any spacing, punctuation, and grammatical errors.
Structuring it into readable paragraphs.
Adding headings and subheadings where relevant to improve readability.
Extracting key points and summarizing the content in a concise yet detailed manner.
Providing a brief summary (2-3 sentences) and a detailed summary (5-7 sentences).
Here is the raw OCR text:$prompt""",
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
    return responseData["candidates"]?[0]["content"]?["parts"]?[0]["text"] ??
        "No response";
  } else {
    throw Exception("Failed to fetch response: ${response.body}");
  }
}

generateKeyWords(
  String prompt,
  String extractedtext,
  String base64image,
  BuildContext context,
) async {
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
                "extract the petitioner as the case name , date from the text , case type from the text and the judge number from the text $extractedtext",
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
    log("first");
    log("fullText" + responseData.toString());
    log("end");
    // Extracting case details using RegExp
    String caseName =
        RegExp(r'\*\*Petitioner:\*\* (.+)').firstMatch(fullText)?.group(1) ??
        "Unknown";
    String caseDate =
        RegExp(r'\*\*Date:\*\* (.+)').firstMatch(fullText)?.group(1) ??
        "Unknown";
    String caseType =
        RegExp(r'\*\*Case Type:\*\* (.+)').firstMatch(fullText)?.group(1) ??
        "Unknown";
    String judgeNumber =
        RegExp(r'\*\*Judge:\*\* (.+)').firstMatch(fullText)?.group(1) ??
        "1234";
     

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
      base64image,
      context,
    );
    caseName = "";
    caseDate = "";
    caseType = "";
    judgeNumber = "";
    extractedtext = "";
    uniqueId = "";
    base64image = "";
  } else {
    throw Exception("Failed to fetch response: ${response.body}");
  }
}

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible:
        false, // Prevents user from closing it by tapping outside
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Colors.red),
              SizedBox(height: 16),
              Text("Loading, please wait...", style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      );
    },
  );
}

// Example usage: Call `showLoadingDialog(context);` before an async task,
// and then use `Navigator.pop(context);` to close it when the task is done.
