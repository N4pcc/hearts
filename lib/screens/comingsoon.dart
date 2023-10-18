import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';


class ComingSoon extends StatefulWidget {
  @override
  _ComingSoonState createState() => _ComingSoonState();
}

class _ComingSoonState extends State<ComingSoon> {
  @override
  Widget build(BuildContext context) {
    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      backgroundColor: darkTheme ? Colors.white30 : Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Lottie.asset(
              'assets/lottie/HCP.json',
              repeat: true,
              reverse: true,
              animate: true,
            ),
            Lottie.asset(
              'assets/lottie/coming.json',
              repeat: true,
              reverse: true,
              animate: true,
            ),

          ],
        ),
      ),
    );
  }
}