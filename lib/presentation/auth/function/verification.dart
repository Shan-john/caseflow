
import 'package:caseflow/presentation/widget/showText.dart';

bool loginAuthvalidation(
  String email,
  String password,
) {
  if (email.isEmpty && password.isEmpty) {
    showMessage("Email is empty");
    return false;
  } else if (email.isEmpty) {
    showMessage("Email is empty");
    return false;
  } else if (password.isEmpty) {
    showMessage("password is empty");
    return false;
  } else {
    return true;
  }
}

 
bool signUpAuthvalidation(String email, String password, String name,  ) {
  if (email.isEmpty && password.isEmpty && name.isEmpty) {
    showMessage("Fields are empty");
    return false;
  } else if (email.isEmpty) {
    showMessage("Email is empty");
    return false;
  } else if (password.isEmpty) {
    showMessage("Password is empty");
    return false;
  } else if (name.isEmpty) {
    showMessage("Name is empty");
    return false;
  }  else {
    return true;
  }
}
