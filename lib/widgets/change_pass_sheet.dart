import 'package:flutter/material.dart';
import 'package:hearts/helpers/loading.dart';
import 'package:hearts/widgets/hearts_text.dart';

import '../services/user.dart';
import 'hearts_button.dart';
import 'hearts_text_field.dart';

void changePasswordSheet(BuildContext context) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (builder) {
        return const ChangePasswordSheet();
      });
}

class ChangePasswordSheet extends StatefulWidget {
  const ChangePasswordSheet({Key? key}) : super(key: key);

  @override
  State<ChangePasswordSheet> createState() => _ChangePasswordSheetState();
}

class _ChangePasswordSheetState extends State<ChangePasswordSheet> {
  bool isLoading = false;
  String? resultString;
  GlobalKey<FormState> changePassFormKey = GlobalKey();
  TextEditingController oldPassController = TextEditingController();
  TextEditingController newPassController = TextEditingController();

  FocusNode oldPassNode = FocusNode();
  FocusNode newPassNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          padding: const EdgeInsets.all(15),
          height: 330,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0))),
          child: Form(
            key: changePassFormKey,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CabText(
                      "Change Password",
                      size: 18,
                      weight: FontWeight.w500,
                    ),
                  ),
                  GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(Icons.close))
                ],
              ),
              const SizedBox(height: 20),
              HeartsTextField(
                controller: oldPassController,
                hintText: "Old Password *".toUpperCase(),
                isPassword: true,
                action: TextInputAction.next,
                node: oldPassNode,
                func: (v) {
                  setState(() {
                    resultString = null;
                  });
                },
                nextNode: newPassNode,
              ),
              const SizedBox(height: 20),
              HeartsTextField(
                controller: newPassController,
                hintText: "New Password *".toUpperCase(),
                isPassword: true,
                node: newPassNode,
                func: (v) {
                  setState(() {
                    resultString = null;
                  });
                },
              ),
              const SizedBox(height: 20),
              HeartsButton(
                  height: 44,
                  isLoading: isLoading,
                  text: "Update Password",
                  textSize: 16,
                  func: () async {
                    LoadingUtils.showLoader();
                    if (changePassFormKey.currentState!.validate()) {
                      setState(() {
                        isLoading = true;
                      });
                      resultString = await UserServices().changePassword(
                          currentPassword: oldPassController.text.trim(),
                          newPassword: newPassController.text.trim(),
                          context: context);
                      setState(() {
                        isLoading = false;
                      });
                    }
                    LoadingUtils.hideLoader();
                  }),
              SizedBox(height: resultString == null ? 0 : 12),
              resultString == null
                  ? const SizedBox()
                  : Center(
                      child: CabText(
                        "*$resultString",
                        color: Colors.red,
                        size: 16,
                      ),
                    )
            ]),
          )),
    );
  }
}
