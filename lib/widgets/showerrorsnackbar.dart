import 'package:flutter/material.dart';

// ...

void showErrorSnackbar(BuildContext context, String errorMessage) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.red,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      animation: CurvedAnimation(
        parent: AnimationController(
          vsync: ScaffoldMessenger.of(context),
          duration: const Duration(milliseconds: 500),
        ),
        curve: Curves.easeOut,
      ),
      content: Text(
        errorMessage,
        style: TextStyle(color: Colors.white),
      ),
    ),
  );
}