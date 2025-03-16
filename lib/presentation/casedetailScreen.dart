import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gap/gap.dart';

class CaseDetailScreen extends StatefulWidget {
  final String caseId; // Get the case ID from the previous screen

  const CaseDetailScreen({super.key, required this.caseId});

  @override
  _CaseDetailScreenState createState() => _CaseDetailScreenState();
}

class _CaseDetailScreenState extends State<CaseDetailScreen> {
  String caseName = "";
  String fullText = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCaseDetails();
  }

  late DocumentSnapshot fullDetailsSnapshot;
  Future<void> fetchCaseDetails() async {
    try {
      // Get the main case document
      DocumentSnapshot caseSnapshot =
          await FirebaseFirestore.instance
              .collection('pdf')
              .doc(widget.caseId)
              .get();

      if (caseSnapshot.exists) {
        setState(() {
          caseName = caseSnapshot['case_name'] ?? "Unknown Case";
        });

        // Get the full details from the subcollection
          fullDetailsSnapshot =
            await FirebaseFirestore.instance
                .collection('pdf')
                .doc(widget.caseId)
                .collection('full_details')
                .doc(widget.caseId)
                .get();

        if (fullDetailsSnapshot.exists) {
          setState(() {
            fullText = fullDetailsSnapshot['text'] ?? "No details available.";
          });
        }
      }
    } catch (e) {
      print("Error fetching case details: $e");
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        actions:  [
       isLoading == false?   InkWell(
            onTap: () => _showImageDialog(context, fullDetailsSnapshot['image']),
            child: Icon(Icons.format_align_center, color: Colors.white),
          ) :SizedBox(),
          Gap(20),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'CASEFLOW',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body:
          isLoading
              ? const Center(
                child: CircularProgressIndicator(),
              ) // Show loader while fetching data
              : Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              caseName,
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              fullText,
                              style: const TextStyle(fontSize: 16, height: 1.5),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}

Image base64ToImage(String base64String) {
  Uint8List bytes = base64Decode(base64String);
  return Image.memory(bytes);
}
//  base64ToImage(base64String),

/// Function to show the image in a dialog

/// Function to show the image in a zoomable dialog

/// Function to show the image in a full-screen zoomable dialog
void _showImageDialog(BuildContext context, String base64String) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: EdgeInsets.zero, // Make dialog full screen
        backgroundColor: Colors.black, // Full black background for better visibility
        child: Stack(
          children: [
            InteractiveViewer(
              panEnabled: true, // Enable panning
              boundaryMargin: EdgeInsets.all(0),
              minScale: 1.0,
              maxScale: 5.0,
              child: Center(child: base64ToImage(base64String)),
            ),
            Positioned(
              top: 40, // Adjust position
              right: 20,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      );
    },
  );
}

