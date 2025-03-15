import 'package:caseflow/core/coretyype.dart';
import 'package:caseflow/core/routes.dart';
import 'package:caseflow/presentation/auth/login.dart';
import 'package:caseflow/presentation/auth/splashScreen.dart';
import 'package:caseflow/presentation/chatRoom.dart';
import 'package:caseflow/presentation/searchScreen.dart';
import 'package:caseflow/presentation/uploadScreen.dart';
import 'package:caseflow/service/firebase_auth_helper.dart';
import 'package:caseflow/service/firebaseservice.dart';
import 'package:caseflow/service/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UserProvider provider = Provider.of(context, listen: false);
      provider.fetchUserData();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB22222),
       
      body: SingleChildScrollView(
        
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              alignment: AlignmentDirectional.bottomEnd,
              children: [
                Image.asset("assets/image/SupremeCourt.png"),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),
                    const Text(
                      'CASEFLOW',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 60),
                    const Text(
                      'Explore Legal\nJudgements Effortlessly',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchScreen(),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "'search by case, respondents, judge........",
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 16,
                                ),
                              ),
                              Icon(Icons.search, color: Colors.grey[400]),
                            ],
                          ),
                          decoration: BoxDecoration(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildActionButton(
                                  icon: Icons.upload_file,
                                  label: 'Upload',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UploadScreen(),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(width: 20),
                              ],
                            
                        
                    ),

                    const SizedBox(height: 40),
                    // Court building illustration would go here
                    InkWell(
                      
                        onTap: () {
                        
                          Routes.instance.push(
                            widget: ChatScreen(),
                            context: context,
                          ); 
                        },
                        child: const Align(
                          alignment: Alignment.bottomRight,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 30,
                            child: Icon(
                              Icons.balance,
                              color: Color(0xFFB22222),
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                
                 Align(
                  alignment: Alignment.topRight,
                   child: Padding(
                     padding: const EdgeInsets.only(top :20.0),
                     child: IconButton(
                                 icon: const Icon(Icons.logout,color: Colors.white,),
                                 onPressed: () {
                                   FirebaseAuth_Helper.instance.logout();
                                   Navigator.pushReplacement(
                                     context,
                                     MaterialPageRoute(
                      builder: (context) => SplashScreen(),
                                     ),
                                   );
                                 },
                               ),
                   ),
                 ),
              ],
            ),
          ),
        ),
      ),
      
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: const Color.fromARGB(166, 255, 255, 255),
      borderRadius: BorderRadius.circular(25),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(25),
        child: Container(
          height: 150,
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: const Color(0xFFB22222), width: 3),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: const Color(0xFFB22222), size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFFB22222),
                  fontSize: 23,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
