import 'dart:developer';
import 'dart:io';
import 'package:caseflow/firebase_options.dart';
import 'package:caseflow/presentation/auth/splashScreen.dart';
import 'package:caseflow/presentation/home.dart';
import 'package:caseflow/service/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CaseFlow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFBF2412),
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: Colors.white,
            fontSize: 80,
            
            fontWeight: FontWeight.w400,
          ),
          headlineLarge: TextStyle(
            color: Color(0xFFBF2412),
            fontSize: 80,
           
            fontWeight: FontWeight.w400,
          ),
          bodyLarge: TextStyle(
            color: Color(0xFFBF2412),
            fontSize: 30,
           
            fontWeight: FontWeight.w300,
          ),
          bodyMedium: TextStyle(
            color: Colors.black,
            fontSize: 25,
            
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
      home:  SplashScreen(),
    );
  }
}

class PDFToLongImageScreen extends StatefulWidget {
  const PDFToLongImageScreen({Key? key}) : super(key: key);

  @override
  _PDFToLongImageScreenState createState() => _PDFToLongImageScreenState();
}

class _PDFToLongImageScreenState extends State<PDFToLongImageScreen> {
  String? longImagePath;
  String? selectedPdfPath;
  String scannedText = "";
  bool isLoading = false;
  bool isProcessing = false;

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
      final inputImage = InputImage.fromFile(image);
      final textRecognizer = TextRecognizer();

      final RecognizedText recognisedText = await textRecognizer.processImage(
        inputImage,
      );
      await textRecognizer.close();

      String extractedText = "";
      for (TextBlock block in recognisedText.blocks) {
        for (TextLine line in block.lines) {
          extractedText += line.text + "\n";
        }
      }

      setState(() {
        scannedText =
            extractedText.isNotEmpty ? extractedText : "No text found.";
      });
    } catch (e) {
      setState(() {
        scannedText = "Error during text recognition: ${e.toString()}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PDF to Text Converter"), elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Select PDF",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      selectedPdfPath != null
                          ? "Selected: ${selectedPdfPath!.split('/').last}"
                          : "No PDF selected",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: isLoading ? null : pickPDFAndConvert,
                      icon: const Icon(Icons.upload_file),
                      label: Text(isLoading ? "Processing..." : "Pick PDF"),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (isProcessing)
              const Center(child: CircularProgressIndicator())
            else if (scannedText.isNotEmpty)
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Extracted Text",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: SingleChildScrollView(
                            child: SelectableText(
                              scannedText,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
