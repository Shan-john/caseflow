import 'package:caseflow/presentation/searchScreen.dart';
import 'package:caseflow/presentation/uploadScreen.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB22222),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
                 alignment: AlignmentDirectional.bottomEnd ,
            children: [
            
              Image.asset("assets/image/SupremeCourt.png"),
                     Column(
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen()));
                  },
                  child: Container(
                    padding:  
                       EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("'search by case, respondents, judge........",style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 16,
                          ),),
                           Icon(
                        Icons.search,
                        color: Colors.grey[400],
                      ),
                      ],
                    ),
                    decoration: BoxDecoration(
                         
                     
                      
                    
                    ),
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => UploadScreen()));
                    },
                  ),
                  const SizedBox(width: 20),
               
                ],
              ),
              
              
              const SizedBox(height: 40),
             // Court building illustration would go here
              const Align(
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
            ],
          ),
            ],
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
      color: Colors.white,
      borderRadius: BorderRadius.circular(25),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(25),
        child: Container(
          height: 150,
           width: 200,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: const Color(0xFFB22222),
                size: 20,
              ),
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