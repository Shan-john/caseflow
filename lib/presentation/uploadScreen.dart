import 'dart:io';

import 'package:caseflow/service/firebaseservice.dart';
import 'package:caseflow/service/http.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  String? longImagePath;
  String? selectedPdfPath;
  String scannedText = "";
  bool isLoading = false;
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background with court illustration (pink tinted)
          Positioned.fill(
            child: Container(
              color: const Color(0xFFFCE4EC), // Light pink background
            ),
          ),

          // Main Content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Bar
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  color: const Color(0xFFB22222),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Expanded(
                        child: Text(
                          'CASEFLOW',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.search, color: Colors.white),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),

                // Main Content Area
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: ()async {
                            pickPDFAndConvert();
                            if (!isProcessing) {
                           
                              
                            }
                          },
                          child: const Text(
                            'Upload your Documents\nHere!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFB22222),
                              height: 1.2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        // Upload Box
                        InkWell(
                          onTap: () {
                            // Handle file picker
                          },
                          child: Container(
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: const Color(0xFFB22222),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.cloud_upload_outlined,
                                  size: 64,
                                  color: const Color(0xFFB22222),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Tap Here to Access the File Manager',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Right Justice Icon
          Positioned(
            right: 16,
            bottom: 16,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 30,
                child: Icon(Icons.balance, color: Color(0xFFB22222), size: 30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> pickPDFAndConvert() async {
    try {
      setState(() {
        isLoading = true;
      });

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          selectedPdfPath = result.files.single.path!;
          longImagePath = null;
          scannedText = "";
        });

        await convertPDFToLongImage(selectedPdfPath!);
        if (longImagePath != null) {
          setState(() {
            isProcessing = true;
          });
          await getRecognisedText(File(longImagePath!));
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    } finally {
      setState(() {
        isLoading = false;
        isProcessing = false;
      });
    }
  }

  Future<void> convertPDFToLongImage(String pdfPath) async {
    final doc = await PdfDocument.openFile(pdfPath);
    List<img.Image> images = [];

    for (int i = 1; i <= doc.pagesCount; i++) {
      final page = await doc.getPage(i);
      final pageImage = await page.render(
        width: page.width,
        height: page.height,
        format: PdfPageImageFormat.png,
      );
      await page.close();

      if (pageImage != null) {
        final image = img.decodeImage(pageImage.bytes);
        if (image != null) {
          images.add(image);
        }
      }
    }

    if (images.isNotEmpty) {
      final longImage = mergeImagesVertically(images);
      final imagePath = await saveImageToFile(longImage);
      setState(() {
        longImagePath = imagePath;
      });
    }

    await doc.close();
  }

  img.Image mergeImagesVertically(List<img.Image> images) {
    int totalHeight = images.fold(0, (sum, image) => sum + image.height);
    int width = images.first.width;

    img.Image longImage = img.Image(width: width, height: totalHeight);
    int yOffset = 0;

    for (var image in images) {
      img.compositeImage(longImage, image, dstY: yOffset);
      yOffset += image.height;
    }

    return longImage;
  }

  Future<String> saveImageToFile(img.Image image) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/long_image.png';
    final file = File(path);
    file.writeAsBytesSync(img.encodePng(image));
    return path;
  }

 

Future<void> getRecognisedText(File image) async {
  try {
     String formatedtext = await  generateFormattedAIResponse(scannedText);
    final inputImage = InputImage.fromFile(image);
    final textRecognizer = TextRecognizer();
    final RecognizedText recognisedText = await textRecognizer.processImage(inputImage);
    await textRecognizer.close();

    String extractedText = "";
    for (TextBlock block in recognisedText.blocks) {
      for (TextLine line in block.lines) {
        extractedText += line.text + "\n";
      }
    }

    if (extractedText.isEmpty) {
      setState(() {
        scannedText = "No text found.";
      });
      return;
    }

    // 🔥 Extract Key Case Details Using Regex
    String caseName = RegExp(r'Case Name:\s*(.+)').firstMatch(extractedText)?.group(1) ?? "Unknown";
    String caseDate = RegExp(r'Date:\s*(.+)').firstMatch(extractedText)?.group(1) ?? "Unknown";
    String caseType = RegExp(r'Case Type:\s*(.+)').firstMatch(extractedText)?.group(1) ?? "Unknown";
    String judgeNumber = RegExp(r'Judge Number:\s*(\d+)').firstMatch(extractedText)?.group(1) ?? "Unknown";

    // 🔥 Upload Extracted Data to Firestore
    await Firebaseservice.instance.uploadCaseDetails(caseName, caseDate, caseType, judgeNumber, formatedtext);

    setState(() {
      scannedText = extractedText;
    });

  } catch (e) {
    setState(() {
      scannedText = "Error during text recognition: ${e.toString()}";
    });
  }
}


Future<void> processOCRAndUpload(List<File> imageFiles) async {
  final textRecognizer = TextRecognizer();
  String fullText = "";

  for (File image in imageFiles) {
    final inputImage = InputImage.fromFile(image);
    final RecognizedText recognizedText = await textRecognizer.processImage(
      inputImage,
    );
    fullText += recognizedText.text + "\n\n";
  }

  textRecognizer.close();

  // Extract details from the full text (Use regex or NLP for better extraction)
  String caseName =
      RegExp(r'Case Name: (.+)').firstMatch(fullText)?.group(1) ?? "Unknown";
  String caseDate =
      RegExp(r'Date: (.+)').firstMatch(fullText)?.group(1) ?? "Unknown";
  String caseType =
      RegExp(r'Case Type: (.+)').firstMatch(fullText)?.group(1) ?? "Unknown";
  String judgeNumber =
      RegExp(r'Judge Number: (\d+)').firstMatch(fullText)?.group(1) ??
      "Unknown";

  // Upload to Firestore
  await Firebaseservice.instance.uploadCaseDetails(
    caseName,
    caseDate,
    caseType,
    judgeNumber,
    fullText,
  );
}}
