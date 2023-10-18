import 'package:flutter/material.dart';
import 'package:hearts/helpers/loading.dart';
import 'package:provider/provider.dart';
import 'package:hearts/helpers/screen_navigation.dart';
import 'package:hearts/helpers/style.dart';
import 'package:hearts/providers/user.dart';

import '../widgets/hearts_button.dart';
import '../widgets/hearts_text.dart';
import '../widgets/hearts_text_field.dart';
import 'login.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  RegistrationScreenState createState() => RegistrationScreenState();
}

class RegistrationScreenState extends State<RegistrationScreen> {
  GlobalKey<FormState> registerFormKey = GlobalKey();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  FocusNode emailNode = FocusNode();
  FocusNode passwordNode = FocusNode();
  FocusNode nameNode = FocusNode();
  FocusNode phoneNode = FocusNode();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    UserProvider authProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30))),
              padding: const EdgeInsets.only(bottom: 20, top: 30),
              child: Stack(
                children: [
                  Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Hero(
                              tag: "logo-shift",
                              child: Image.asset("assets/HEARTS2.png",
                                  width: double.infinity, height: 220)),
                          const SizedBox(height: 5),
                          const CabText(
                            "CREATE ACCOUNT",
                            color: black,
                            size: 24,
                            weight: FontWeight.w300,
                          )
                        ],
                      )),
                  // const Positioned(
                  //     right: 20,
                  //     top: 20,
                  //     child: CabText(
                  //       "SKIP",
                  //       size: 14,
                  //       color: Colors.white,
                  //     ))
                ],
              ),
            ),
            // ListView(
            //   shrinkWrap: true,
            //   padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            //   children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Form(
                key: registerFormKey,
                child: Column(
                  children: [
                    HeartsTextField(
                        controller: nameController,
                        hintText: "Name".toUpperCase(),
                        isPassword: false,
                        action: TextInputAction.next,
                        node: nameNode,
                        nextNode: phoneNode,
                        icon: const Icon(Icons.person, color: black)),
                    const SizedBox(height: 10),
                    HeartsTextField(
                        controller: phoneController,
                        hintText: "Phone Number".toUpperCase(),
                        isPassword: false,
                        action: TextInputAction.next,
                        node: phoneNode,
                        nextNode: emailNode,
                        icon: const Icon(Icons.call, color: black)),
                    const SizedBox(height: 10),
                    HeartsTextField(
                        controller: emailController,
                        hintText: "Email".toUpperCase(),
                        isPassword: false,
                        action: TextInputAction.next,
                        node: emailNode,
                        nextNode: passwordNode,
                        type: TextInputType.emailAddress,
                        icon: const Icon(Icons.email, color: black)),
                    const SizedBox(height: 10),
                    HeartsTextField(
                        controller: passwordController,
                        hintText: "Password".toUpperCase(),
                        isPassword: true,
                        node: passwordNode,
                        icon: const Icon(Icons.lock, color: black)),
                    const SizedBox(height: 20),
                    HeartsButton(
                        isLoading: isLoading,
                        text: "REGISTER",
                        func: () {
                          LoadingUtils.showLoader();
                          if (registerFormKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            try {
                              authProvider.signUp(
                                  emailController.text,
                                  passwordController.text,
                                  nameController.text,
                                  phoneController.text,
                                  context);
                            } catch (e) {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                          LoadingUtils.hideLoader();
                        }),
                    Padding(
                      padding: const EdgeInsets.only(top: 24, bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(width: 80, color: Colors.grey, height: 1),
                          const CabText(
                            "   OR   ",
                            size: 14,
                          ),
                          Container(width: 80, color: Colors.grey, height: 1)
                        ],
                      ),
                    ),
                    TextButton.icon(
                        onPressed: () =>
                            changeScreen(context, const LoginScreen()),
                        icon: const Icon(
                          Icons.arrow_back_ios_rounded,
                          size: 20,
                          color: Color(0xFF080808),
                        ),
                        label: const CabText("SIGN IN"))
                  ],
                ),
              ),
            )
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
  //  if (!await authProvider.signUp()) {
  //                         ScaffoldMessenger.of(context).showSnackBar(
  //                             const SnackBar(
  //                                 content: Text("Registration failed!")));
  //                         return;
  //                       }
  //                       authProvider.clearController();
  //                       changeScreenReplacement(context, HomeScreen());