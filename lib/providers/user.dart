import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hearts/helpers/constant/constants.dart';
import 'package:hearts/helpers/screen_navigation.dart';
import 'package:hearts/models/user.dart';
import 'package:hearts/screens/home.dart';
import 'package:hearts/services/user.dart';

import '../helpers/methods.dart';
import '../models/address_model.dart';
import '../screens/dashboard/dashboard1.dart';
import '../screens/login.dart';
import '../services/address_service.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  final UserServices _userServices = UserServices();
  UserModel? _userModel;

//  getter
  UserModel? get userModel => _userModel;

  User? get user => _user;

  // public variables

  // UserProvider.initialize() {
  //   _initialize();
  // }

  Future signIn(String email, String password, BuildContext context) async {
    try {
      FocusScope.of(context).unfocus();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        await prefs.setString(authPref, value.user!.uid);
        await prefs.setBool(loggedInPref, true);
        _userModel = await _userServices
            .getUserById(value.user!.uid)
            .whenComplete(
                () => changeScreenReplacement(context, const dashboard1()));
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showSnack(context: context, message: 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        showSnack(
            context: context,
            message: 'Wrong password provided for that user.');
      } else {
        showSnack(context: context, message: e.message ?? "");
      }
    } catch (e) {
      showSnack(context: context, message: e.toString());
    }
    notifyListeners();
  }

  Future signUp(String email, String password, String name, String phone,
      BuildContext context) async {
    try {
      FocusScope.of(context).unfocus();
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((result) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        _userServices.createUser(
          id: result.user!.uid,
          name: name,
          email: email,
          phone: phone,
        );
        await prefs.setString(authPref, result.user!.uid);
        await prefs.setBool(loggedInPref, true);
        _userModel = await _userServices
            .getUserById(result.user!.uid)
            .whenComplete(
                () => changeScreenReplacement(context, const dashboard1()));
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showSnack(
            context: context, message: 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showSnack(
            context: context,
            message: 'The account already exists for that email.');
      } else {
        showSnack(context: context, message: e.message ?? "");
      }
    } catch (e) {
      showSnack(context: context, message: e.toString());
    }
    notifyListeners();
  }

  Future signOut(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    auth.signOut();
    await prefs.remove(driverIdPref);
    await prefs.remove(requestIdPref);
    await prefs.remove(authPref);
    await prefs.setBool(loggedInPref, false);

    notifyListeners();
    // ignore: use_build_context_synchronously
    changeScreenReplacement(context, const LoginScreen());
  }

  Future<void> reloadUserModel() async {
    _userModel = await _userServices.getUserById(user!.uid);
    notifyListeners();
  }

  updateUserData(Map<String, dynamic> data) async {
    _userServices.updateUserData(data);
  }

  saveDeviceToken() async {
    String? deviceToken = await fcm.getToken();
    if (deviceToken != null) {
      _userServices.addDeviceToken(userId: user!.uid, token: deviceToken);
    }
  }

  initialize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool loggedIn = prefs.getBool(loggedInPref) ?? false;
    if (loggedIn) {
      _user = auth.currentUser!;
      _userModel = await _userServices.getUserById(auth.currentUser!.uid);
    }
    notifyListeners();
  }

  Future addAddress({required Address address}) async {
    _userModel!.addressList.add(address);
    notifyListeners();
  }

  Future removeAddress({required String id}) async {
    _userModel!.addressList.removeWhere((e) => e.id == id);
    AddressService().removeAddressService(id: id);
    notifyListeners();
  }

  Future updateAddress({required Address address}) async {
    int i = _userModel!.addressList.indexWhere((e) => e.id == address.id);
    _userModel!.addressList[i] = address;
    AddressService().updateAddressService(address: address);
    notifyListeners();
  }
}
