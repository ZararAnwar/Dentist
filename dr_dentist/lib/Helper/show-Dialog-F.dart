import 'package:dr_dentist/Utils/utils.dart';
import 'package:flutter/material.dart';

showDialogF(context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          content: Container(
            height: 50,
            child: Center(
              child: Row(
                children: [
                  CircularProgressIndicator(
                    color: darkRedColor,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text("Please wait...."),
                ],
              ),
            ),
          ),
        );
      });
}

class Utilities {
  static bool isKeyboardShowing() {
    if (WidgetsBinding.instance != null) {
      return WidgetsBinding.instance.window.viewInsets.bottom > 0;
    } else {
      return false;
    }
  }

  static closeKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }
}

