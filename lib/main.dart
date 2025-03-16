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
  