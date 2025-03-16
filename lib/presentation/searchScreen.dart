// import 'package:caseflow/model/cardModel.dart';
// import 'package:caseflow/service/firebaseservice.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';

// class SearchScreen extends StatefulWidget {
//   const SearchScreen({super.key});

//   @override
//   State<SearchScreen> createState() => _SearchScreenState();
// }

// class _SearchScreenState extends State<SearchScreen> {
//   List<CaseModel> Listofcases = [];
//   bool isLoading = true; // Loading state

//   @override
//   void initState() {
//     super.initState();
//     fetch();
//   }

//   Future<void> fetch() async {
//     await Firebase.initializeApp();
//     List<CaseModel> cases = await Firebaseservice.instance.fetchCaseDetails();

//     setState(() {
//       Listofcases = cases;
//       isLoading = false; // Data loaded
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // 🔍 Search Bar
//             Container(
//               padding: const EdgeInsets.all(16),
//               color: const Color(0xFFB22222),
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 child: Row(
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.arrow_back),
//                       color: Colors.grey,
//                       onPressed: () => Navigator.pop(context),
//                     ),
//                     Expanded(
//                       child: TextField(
//                         decoration: InputDecoration(
//                           hintText: 'Search by case, respondents, judge...',
//                           hintStyle: TextStyle(
//                             color: Colors.grey[400],
//                             fontSize: 16,
//                           ),
//                           border: InputBorder.none,
//                           contentPadding: const EdgeInsets.symmetric(
//                             horizontal: 16,
//                             vertical: 12,
//                           ),
//                         ),
//                       ),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.search),
//                       color: Colors.grey,
//                       onPressed: () {},
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             // 📜 Results List
//             Expanded(
//               child: Stack(
//                 children: [
//                   // 🏛️ Background Court Illustration
//                   Positioned.fill(
//                     child: Container(
//                       decoration: const BoxDecoration(
//                         color: Color(0xFFFCE4EC),
//                         image: DecorationImage(
//                           image: AssetImage('assets/image/SupremeCourt.png'),
//                           fit: BoxFit.cover,
//                           opacity: 0.1,
//                         ),
//                       ),
//                     ),
//                   ),

//                   // 📌 Case List (with Loading)
//                   isLoading
//                       ? const Center(child: CircularProgressIndicator())
//                       : Listofcases.isEmpty
//                           ? const Center(
//                               child: Text(
//                                 "No cases found",
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   color: Colors.black54,
//                                 ),
//                               ),
//                             )
//                           : ListView.builder(
//                               padding: const EdgeInsets.all(16),
//                               itemCount: Listofcases.length,
//                               itemBuilder: (context, index) {
//                                 return _buildCaseCard(
//                                   caseName: Listofcases[index].caseName,
//                                   caseDate: Listofcases[index].caseDate,
//                                   caseType: Listofcases[index].caseType,
//                                   judgeName: Listofcases[index].judgeNumber, // Fixed from judgeNumber
//                                 );
//                               },
//                             ),

//                   // ⚖️ Bottom Right Justice Icon
//                   Positioned(
//                     right: 16,
//                     bottom: 16,
//                     child: Container(
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Colors.white,
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.1),
//                             blurRadius: 10,
//                             offset: const Offset(0, 5),
//                           ),
//                         ],
//                       ),
//                       child: const CircleAvatar(
//                         backgroundColor: Colors.white,
//                         radius: 30,
//                         child: Icon(
//                           Icons.balance,
//                           color: Color(0xFFB22222),
//                           size: 30,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // 📌 Case Card Widget
//   Widget _buildCaseCard({
//     required String caseName,
//     required String caseDate,
//     required String caseType,
//     required String judgeName,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           // 📄 PDF Icon
//           Container(
//             width: 100,
//             height: 100,
//             decoration: BoxDecoration(
//               color: const Color(0xFFB22222),
//               borderRadius: BorderRadius.circular(16),
//             ),
//             margin: const EdgeInsets.all(12),
//             child: const Center(
//               child: Text(
//                 'PDF',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//           // 📜 Case Details
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(12),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildDetailRow('Case Name:', caseName),
//                   _buildDetailRow('Case Date:', caseDate),
//                   _buildDetailRow('Case Type:', caseType),
//                   _buildDetailRow('Judge Name:', judgeName),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // 🔹 Case Detail Row Widget
//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 6),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: const TextStyle(
//               color: Color(0xFFB22222),
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Text(
//               value,
//               style: const TextStyle(
//                 color: Colors.black87,
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:caseflow/core/routes.dart';
import 'package:caseflow/model/cardModel.dart';
import 'package:caseflow/presentation/casedetailScreen.dart';
import 'package:caseflow/presentation/chatRoom.dart';
import 'package:caseflow/service/firebaseservice.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<CaseModel> listOfCases = [];
  List<CaseModel> filteredCases = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCases();
  }

  Future<void> fetchCases() async {
    await Firebase.initializeApp();
    listOfCases = await Firebaseservice.instance.fetchCaseDetails();
    setState(() {
      filteredCases = List.from(listOfCases);
    });
  }

  void searchCases(String query) {
    if (query.isEmpty) {
      setState(() => filteredCases = List.from(listOfCases));
      return;
    }

    List<CaseModel> tempList = [];

    for (var caseItem in listOfCases) {
      var bestMatch = extractOne(
        query: query.toLowerCase(),
        choices: [
          caseItem.caseName.toLowerCase(),
          caseItem.caseType.toLowerCase(),
        ],
      );

      if (bestMatch.score > 60) {
        // Threshold for matching
        tempList.add(caseItem);
      }
    }

    setState(() {
      filteredCases = tempList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.all(16),
              color: const Color(0xFFB22222),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      color: Colors.grey,
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        onChanged: searchCases,
                        decoration: InputDecoration(
                          hintText:
                              'Search by case name, respondents, judge...',
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 16 ,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search),
                      color: Colors.grey,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),

            // Results List
            Expanded(
              child: Stack(
                children: [
                  // Background with court illustration (pink tinted)
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFFFCE4EC),
                        image: DecorationImage(
                          image: AssetImage('assets/image/SupremeCourt-red.png'),
                          fit: BoxFit.cover,
                          opacity: 0.1,
                        ),
                      ),
                    ),
                  ),

                  // Case List
                  ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredCases.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => CaseDetailScreen(
                                    caseId: filteredCases[index].id,
                                  ),
                            ),
                          );
                        },
                        child: _buildCaseCard(
                          caseName: filteredCases[index].caseName,
                          caseDate: filteredCases[index].caseDate,
                          caseType: filteredCases[index].caseType,
                          judgeName: filteredCases[index].judgeNumber,
                        ),
                      );
                    },
                  ),

                  // Bottom Right Justice Icon
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: InkWell(
                      onTap: (){
                         Routes.instance.push(
                            widget: ChatScreen(),
                            context: context,
                          ); 
                      },
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
                          child: Icon(
                            Icons.balance,
                            color: Color(0xFFB22222),
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCaseCard({
    required String caseName,
    required String caseDate,
    required String caseType,
    required String judgeName,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // PDF Icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFB22222),
              borderRadius: BorderRadius.circular(16),
              image: const DecorationImage(
                image: AssetImage('assets/image/casefile.png'),
              ),
            ),
            margin: const EdgeInsets.all(12),
            child: const Center(
              
            ),
          ),
          // Case Details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow('Case Name :', caseName),
                  const SizedBox(height: 8),
                  _buildDetailRow('Case Date :', caseDate),
                  const SizedBox(height: 8),
                  _buildDetailRow('Case Type :', caseType),
                  const SizedBox(height: 8),
                  _buildDetailRow('Judge Name :', judgeName),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFB22222),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
