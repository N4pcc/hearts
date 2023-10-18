import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hearts/helpers/constant/constants.dart';
import 'package:hearts/models/user.dart';

import '../helpers/methods.dart';

class UserServices {
  String collection = "users";

  void createUser(
      {required String id,
      required String name,
      required String email,
      required String phone,
      int votes = 0,
      int trips = 0,
      double rating = 0,
      Map? position}) {
    firebaseFiretore.collection(collection).doc(id).set({
      "name": name,
      "id": id,
      "phone": phone,
      "email": email,
      "votes": votes,
      "trips": trips,
      "rating": rating,
      "position": position ?? {},
      "isActive": true
    });
  }

  void updateUserData(Map<String, dynamic> values) {
    firebaseFiretore.collection(collection).doc(values['id']).update(values);
  }

  Future<UserModel> getUserById(String id) =>
      firebaseFiretore.collection(collection).doc(id).get().then((doc) {
        return UserModel.fromSnapshot(doc);
      });

  void addDeviceToken({required String token, required String userId}) {
    firebaseFiretore
        .collection(collection)
        .doc(userId)
        .update({"token": token});
  }

  Future<String?> changePassword(
      {required String currentPassword,
      required String newPassword,
      required BuildContext context}) async {
    final user = FirebaseAuth.instance.currentUser;
    final cred = EmailAuthProvider.credential(
        email: user!.email!, password: currentPassword);
    FocusScope.of(context).unfocus();
    try {
      await user.reauthenticateWithCredential(cred);
      try {
        await user
            .updatePassword(newPassword)
            .then((value) => Navigator.of(context).pop());

        showSnack(
            context: context,
            message: 'Password Changed Successfully.',
            color: Colors.green);
      } on FirebaseAuthException catch (e) {
        return e.toString();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "wrong-password") {
        return 'Invalid Password';
      } else {
        return e.toString();
      }
    }
    return null;
  }
}
