import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hearts/helpers/style.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';


String? validateName(String? value) {
  String pattern = r'(^[a-zA-Z ]*$)';
  RegExp regExp = RegExp(pattern);
  if (value!.isEmpty) {
    return 'Name is required';
  } else if (!regExp.hasMatch(value)) {
    return 'Name must be valid';
  }
  return null;
}

String? validateEmail(String? value) {
  String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(value ?? '')) {
    return 'Enter valid e-mail';
  } else {
    return null;
  }
}

String? validateMobile(String? value) {
  String pattern = r'(^\+?[0-9]*$)';
  RegExp regExp = RegExp(pattern);
  if (value!.isEmpty) {
    return 'Mobile is required';
  } else if (!regExp.hasMatch(value)) {
    return 'Mobile Number must be digits';
  } else if (value.length < 10 || value.length > 10) {
    return 'please enter valid number';
  }
  return null;
}

String? validatePassword(String? value) {
  if ((value?.length ?? 0) < 6) {
    return 'Password must be more than 5 characters';
  } else {
    return null;
  }
}

String? validateConfirmPassword(String? password, String? confirmPassword) {
  if (password != confirmPassword) {
    return 'Password doesn\'t match';
  } else if (confirmPassword!.isEmpty) {
    return 'Confirm password is required';
  } else {
    return null;
  }
}
ProgressDialog? pd;
showAlertDialog(BuildContext context, String title, String content, bool addOkButton) {
  // set up the AlertDialog
  Widget? okButton;
  if (addOkButton) {
    okButton = TextButton(
      child: const Text('ok'),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
  if (Platform.isIOS) {
    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [if (okButton != null) okButton],
    );
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return alert;
        });
  } else {
    AlertDialog alert = AlertDialog(title: Text(title), content: Text(content), actions: [if (okButton != null) okButton]);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

showProgress(BuildContext context, String message, bool isDismissible) async {
  pd = ProgressDialog(context, type: ProgressDialogType.normal, isDismissible: isDismissible);
  pd!.style(
      message: message,
      borderRadius: 10.0,
      backgroundColor: primaryColor,
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      messageTextStyle: const TextStyle(color: Colors.white, fontSize: 19.0, fontWeight: FontWeight.w600));
  await pd!.show();
}

updateProgress(String message) {
  pd!.update(message: message, maxProgress: 100);
  // progressDialog.update(message: message);
}

hideProgress() {
  pd!.hide();
}
String? validateEmptyField(String? text) => text == null || text.isEmpty ? 'This field can\'t be empty.' : null;

push(BuildContext context, Widget destination) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => destination));
}