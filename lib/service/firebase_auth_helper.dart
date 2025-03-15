import 'package:caseflow/core/coretyype.dart';
import 'package:caseflow/model/Usermodel.dart';
import 'package:caseflow/presentation/widget/showText.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
 
 
class FirebaseAuth_Helper {
  static FirebaseAuth_Helper instance = FirebaseAuth_Helper();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream<User?> get getAuthChange => _auth.authStateChanges();

  Future<bool> SignUp(String email, String password, String username,
      String heightString, String weightString) async {
    double height = double.parse(heightString);
    double weight = double.parse(weightString);
    try {
      showMessage("SigningUP..");
      UserCredential? userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      UserModel user = UserModel(
          email: email,
          password: password,
          name: username,
          
          id: userCredential.user!.uid.toString(),
          userType: usertype.normalUser.toString());

      _firestore
          .collection("User")
          .doc(userCredential.user!.uid)
          .set(user.toJson());

      return true;
    } on FirebaseAuthException catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> Login(
    String email,
    String password,
  ) async {
    try {
      showMessage("logining..");

      await _auth.signInWithEmailAndPassword(email: email, password: password);

      showMessage("Login successfully completed ..");
      return true;
    } on FirebaseAuthException catch (e) {
      showMessage(e.code.toString());
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      showMessage("logout");
      await _auth.signOut();
      return true;
    } catch (e) {
      showMessage("failed to Sign Out");
      return false;
    }
  }
}