import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hearts/screens/dashboard/dashboard1.dart';
import 'package:hearts/screens/onboarding.dart';

import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../widgets/big_text.dart';
import '../helpers/constant/constants.dart';
import '../helpers/screen_navigation.dart';
import 'home.dart';
import 'login.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // @override
  // void initState() {
  //   //set time to load the new page
  //   Future.delayed(Duration(seconds: 5), () {
  //     Navigator.pushReplacement(
  //         context, MaterialPageRoute(builder: (context) => const dashboard1()));
  //   });
  //   super.initState();
  // }

  startTimer() {
    Timer(const Duration(seconds: 3), () async {
      var connectivityResult = await (Connectivity().checkConnectivity());

      if (connectivityResult == ConnectivityResult.none) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("No Internet Connection"),
              content: Text("Check your internet and try again."),
              actions: [
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(authPref) && prefs.getString(authPref) != "") {
      Future.delayed(const Duration(seconds: 3)).whenComplete(
          () => changeScreenReplacement(context, const dashboard1()));
    } else {
      Future.delayed(const Duration(seconds: 3)).whenComplete(
          () => changeScreenReplacement(context, const OnBoardingScreen()));
    }

      }
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      backgroundColor: darkTheme ? Colors.white30 : Colors.white,
      body: Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: 500,
                width: 500,
                child: Lottie.asset('assets/lottie/heartbeat_pulse.json')),
            // SizedBox(height: 10),
            Text(
              "HEARTS",
              style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: darkTheme ? Colors.yellowAccent : Colors.blueAccent,),
            ),
            BigText(
              color: darkTheme ? Colors.white : const Color(0xFF332d2b),
              text: ' Coordinated Care,',
              size: 20,
            ),
            BigText(
              color: darkTheme ? Colors.white : const Color(0xFF332d2b),
              text: ' Rapid Response.',
              size: 20,

            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
//
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:hearts/helpers/constants.dart';
// import 'package:hearts/helpers/style.dart';
// import 'package:hearts/screens/home.dart';
//
// import '../helpers/screen_navigation.dart';
//
// import 'login.dart';
//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({Key? key}) : super(key: key);
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     init();
//     super.initState();
//   }
//
//   init() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     if (prefs.containsKey(authPref) && prefs.getString(authPref) != "") {
//       Future.delayed(const Duration(seconds: 3)).whenComplete(
//           () => changeScreenReplacement(context, const HomeScreen()));
//     } else {
//       Future.delayed(const Duration(seconds: 3)).whenComplete(
//           () => changeScreenReplacement(context, const LoginScreen()));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: primaryColor,
//         body: Center(
//           child: Hero(
//               tag: "logo-shift",
//               child: Image.asset(
//                 'assets/logo-tb.png',
//                 //color: Colors.white,
//               )),
//         ));
//   }
// }
