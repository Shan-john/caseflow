import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
 

void showMessage(String message) {
  Fluttertoast.showToast(
    msg: message,
    timeInSecForIosWeb: 1,
    backgroundColor: const Color.fromARGB(255, 37, 37, 37),
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

//
Text showText({
  required String label,
  required double size,
  required Color color,
}) {
  return Text(label, style: TextStyle(color: color, fontSize: size));
}
