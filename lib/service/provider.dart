import 'dart:core' ;
import 'dart:developer';
import 'package:caseflow/core/coretyype.dart';
import 'package:caseflow/model/Usermodel.dart';
import 'package:caseflow/service/firebaseservice.dart';
 
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _userModel;
  ViewState _state = ViewState.Idle;

  UserModel? get user => _userModel;
  ViewState get state => _state;

  /// Fetch user data from Firebase and update the provider state.
  Future<void> fetchUserData() async {
    _state = ViewState.Loading;
    notifyListeners(); // Notify UI that loading has started

    try {
      UserModel userData = await Firebaseservice.instance.getUserinformation();
      _userModel = userData;
      log("User fetched: ${userData.email}");

      _state = ViewState.Loaded;
    } catch (e) {
      log("Error fetching user data: $e");
      _state = ViewState.Error;
    }

    notifyListeners(); // Notify UI that data has been updated
  }

  /// Clear user data (useful for logout)
  void clearUser() {
    _userModel = null;
    _state = ViewState.Idle;
    notifyListeners();
  }
}
