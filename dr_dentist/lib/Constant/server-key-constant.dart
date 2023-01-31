
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

const String url = 'https://fcm.googleapis.com/fcm/send';
const String serverKey =
    'key=AAAAFoW2M48:APA91bGbtlp_Za2k-wrG-coqJRFhwQiwwW4rLbKDRuZaCCL2ltD4r-bypQLXQBBG2gwBhKuCkzAIxDkbxF3kMtnFP8iLTSPo3PFlrk756jNst28BXdfBn-c6ZEESm8S-AikShfz91vxE';


int myErrorHandler(int status) {
  showToast("Error $status");
  print("Custom Error $status");
}

showToast(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black38,
      textColor: Colors.white,
      fontSize: 15.0);
}