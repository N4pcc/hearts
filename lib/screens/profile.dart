import 'package:hearts/helpers/loading.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../helpers/language_constants.dart';
import '../helpers/methods.dart';
import '../helpers/style.dart';
import '../main.dart';
import '../providers/user.dart';
import '../widgets/hearts_button.dart';
import '../widgets/hearts_text.dart';
import '../widgets/hearts_text_field.dart';

import '../widgets/change_pass_sheet.dart';
import 'language.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);

    emailController.text = userProvider.userModel!.email;

    nameController.text = userProvider.userModel!.name;
    phoneController.text = userProvider.userModel!.phone;
    super.initState();
  }

  GlobalKey<FormState> registerFormKey = GlobalKey();

  TextEditingController emailController = TextEditingController();

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  FocusNode emailNode = FocusNode();

  FocusNode nameNode = FocusNode();
  FocusNode phoneNode = FocusNode();

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: darkTheme ? Colors.white30 : Colors.white,
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: SingleChildScrollView(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 30, bottom: 10),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 24,
                        //color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                     CabText(
                      "Edit Profile",
                      // color: Colors.white,
                      size: 20,
                      color: darkTheme ? Colors.white : Colors.black,
                      //   weight: FontWeight.w500,
                    )
                  ],
                ),
              ),

              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
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
                          icon:  Icon(Icons.person, color: darkTheme ? Colors.blue : Colors.black)),
                      const SizedBox(height: 15),
                      HeartsTextField(
                          controller: phoneController,
                          hintText: "Phone Number".toUpperCase(),
                          isPassword: false,
                          action: TextInputAction.next,
                          node: phoneNode,
                          nextNode: emailNode,
                          icon:  Icon(Icons.call, color: darkTheme ? Colors.blue : Colors.black)),
                      const SizedBox(height: 15),
                      HeartsTextField(
                          controller: emailController,
                          hintText: "Email".toUpperCase(),
                          isPassword: false,
                          action: TextInputAction.done,
                          node: emailNode,
                          type: TextInputType.emailAddress,
                          icon:  Icon(Icons.email, color: darkTheme ? Colors.blue : Colors.black)),


                      const SizedBox(height: 18),
                      Align(
                        alignment: Alignment.centerRight,
                        child: OutlinedButton(
                            onPressed: () => changePasswordSheet(context),
                            child:  CabText("Reset Password", color: darkTheme ? Colors.yellow.shade600 : Colors.black,)),
                      ),
                      const SizedBox(height: 20),
                      HeartsButton(
                          isLoading: false,
                          height: 46,
                          text: "Save",
                          textColor: Colors.white ,
                          func: () async {
                            LoadingUtils.showLoader();
                            if (registerFormKey.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                              });
                              //    String url = await uploadImage();
                              userProvider.updateUserData({
                                "name": nameController.text.trim(),
                                "id": userProvider.userModel!.id,
                                "phone": phoneController.text.trim(),
                                "email": emailController.text.trim(),
                              }).whenComplete(() => userProvider
                                  .reloadUserModel()
                                  .whenComplete(() => showSnack(
                                      context: context,
                                      message: "Profile Data updated")));
                            }
                            LoadingUtils.hideLoader();
                          }),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              )
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
