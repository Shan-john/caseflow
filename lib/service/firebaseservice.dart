import 'dart:developer';

import 'package:caseflow/model/Usermodel.dart';
import 'package:caseflow/model/cardModel.dart';
import 'package:caseflow/service/http.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Firebaseservice {
  static Firebaseservice instance = Firebaseservice();

  get firebaseFirestore => null;

  Future<void> uploadCaseDetails(
    String caseName,
    String caseDate,
    String caseType,
    String judgeNumber,
    String fullText,
    String id,
    String base64image,
    BuildContext context,
  ) async {
    CollectionReference pdfCollection = FirebaseFirestore.instance.collection(
      'pdf',
    );

    // Use the provided `id` instead of auto-generating one
    DocumentReference caseRef = pdfCollection.doc(id);

    // Create or  update the case document
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
    Navigator.of(context).pop();
    print("Case details uploaded successfully with ID: $id");
  }

  Future<List<CaseModel>> fetchCaseDetails() async {
    CollectionReference pdfCollection = FirebaseFirestore.instance.collection(
      'pdf',
    );

    QuerySnapshot querySnapshot = await pdfCollection.get();

    List<CaseModel> cases =
        querySnapshot.docs.map((doc) {
          return CaseModel.fromFirestore(
            doc.id,
            doc.data() as Map<String, dynamic>,
          );
        }).toList();

    return cases;
  }

  Future<UserModel> getUserinformation() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> QuerySnapshot =
          await firebaseFirestore
              .collection("User")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .get();
      return UserModel.fromJson(QuerySnapshot.data()!);
    } catch (e) {
      return UserModel(email: "", name: "", id: "", password: "", userType: "");
    }
  }
}
