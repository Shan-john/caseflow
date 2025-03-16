import 'dart:developer';

import 'package:caseflow/model/Usermodel.dart';
import 'package:caseflow/presentation/auth/login.dart';
import 'package:caseflow/presentation/home.dart';
import 'package:caseflow/service/firebase_auth_helper.dart';
import 'package:caseflow/service/firebaseservice.dart';
import 'package:caseflow/service/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  @override
  void initState() {
    super.initState();
    
     
    Future.delayed(const Duration(seconds: 3), () {
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) => StreamBuilder(
                stream: FirebaseAuth_Helper.instance.getAuthChange,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return HomeScreen();
                  } //  return if the user is driver goto drivermain page() other wize mechanic homepage;
                  else {
                    return const LoginPage();
                  }
                },
              ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 18, 18, 34),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
              Image(image: AssetImage('assets/image/logo.png'), height: 250),
           Opacity(
  opacity: 0.5, // Set the opacity (0.0 is fully transparent, 1.0 is fully visible)
  child: Image(image : AssetImage("assets/image/SupremeCourt-red.png")),
)
          ],
        ),
      ),
    );
  }
}
