import 'package:caseflow/model/cardModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Firebaseservice {
  static Firebaseservice  instance = Firebaseservice();
 

Future<void> uploadCaseDetails(
  String caseName, 
  String caseDate, 
  String caseType, 
  String judgeNumber, 
  String fullText, 
  String id,
  String base64image
) async {
  CollectionReference pdfCollection = FirebaseFirestore.instance.collection('pdf');

  // Use the provided `id` instead of auto-generating one
  DocumentReference caseRef = pdfCollection.doc(id);

  // Create or update the case document
  await caseRef.set({
    'case_name': caseName,
    'case_date': caseDate,
    'case_type': caseType,
    'judge_number': judgeNumber,
    'id': id, // Ensure the ID is stored as well
    'timestamp': FieldValue.serverTimestamp(),
  });

  // Add full case text in the 'full_details' subcollection with the same `id`
  await caseRef.collection('full_details').doc(id).set({
    'text': fullText,
    'image': base64image,
    'timestamp': FieldValue.serverTimestamp(),
  });

  print("Case details uploaded successfully with ID: $id");
}




Future<List<CaseModel>> fetchCaseDetails() async {
  CollectionReference pdfCollection = FirebaseFirestore.instance.collection('pdf');

  QuerySnapshot querySnapshot = await pdfCollection.get();

  List<CaseModel> cases = querySnapshot.docs.map((doc) {
    return CaseModel.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
  }).toList();

  return cases;
}
}