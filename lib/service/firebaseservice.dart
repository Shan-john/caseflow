import 'package:cloud_firestore/cloud_firestore.dart';

class Firebaseservice {
  static Firebaseservice  instance = Firebaseservice();
 

Future<void> uploadCaseDetails(
    String caseName, String caseDate, String caseType, String judgeNumber, String fullText) async {
  
  CollectionReference pdfCollection = FirebaseFirestore.instance.collection('pdf');

  // Create a new case document in the 'pdf' collection
  DocumentReference caseRef = await pdfCollection.add({
    'case_name': caseName,
    'case_date': caseDate,
    'case_type': caseType,
    'judge_number': judgeNumber,
    'timestamp': FieldValue.serverTimestamp()
  });

  // Add full case text to the 'full_details' subcollection
  await caseRef.collection('full_details').add({
    'text': fullText,
    'timestamp': FieldValue.serverTimestamp()
  });

  print("Case details uploaded successfully!");
}

}