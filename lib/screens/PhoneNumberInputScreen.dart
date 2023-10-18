// import 'dart:io';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart' as auth;
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:hearts/helpers/style.dart';
// import 'package:hearts/providers/app_state.dart';
// import 'package:hearts/screens/home.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl_phone_number_input/intl_phone_number_input.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';
// import 'package:hearts/helpers/constant/helper.dart';
//
// import '../models/user.dart';
//
//
// File? _image;
//
// class PhoneNumberInputScreen extends StatefulWidget {
//   final bool login;
//
//   const PhoneNumberInputScreen({Key? key, required this.login}) : super(key: key);
//
//   @override
//   _PhoneNumberInputScreenState createState() => _PhoneNumberInputScreenState();
// }
//
// class _PhoneNumberInputScreenState extends State<PhoneNumberInputScreen> {
//   final ImagePicker _imagePicker = ImagePicker();
//   final TextEditingController _firstNameController = TextEditingController();
//   final TextEditingController _lastNameController = TextEditingController();
//   final GlobalKey<FormState> _key = GlobalKey();
//   String? firstName, lastName, _phoneNumber, _verificationID, referralCode;
//   bool _isPhoneValid = false, _codeSent = false;
//   AutovalidateMode _validate = AutovalidateMode.disabled;
//   static UserModel? currentUser;
//
//   @override
//   Widget build(BuildContext context) {
//     if (Platform.isAndroid && !widget.login) {
//       retrieveLostData();
//     }
//     bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;
//
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0.0,
//         backgroundColor: Colors.transparent,
//         iconTheme: IconThemeData(color: darkTheme ? Colors.white : Colors.black),
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           margin: const EdgeInsets.only(left: 16.0, right: 16, bottom: 16),
//           child: Form(
//             key: _key,
//             autovalidateMode: _validate,
//             child: Column(
//               children: <Widget>[
//                 Align(
//                     alignment: Directionality.of(context) == TextDirection.ltr ? Alignment.topLeft : Alignment.topRight,
//                     child: Text(
//                       widget.login ? 'Sign In' : 'Create new account',
//                       style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 25.0),
//                     )),
//
//                 /// user profile picture,  this is visible until we verify the
//                 /// code in case of sign up with phone number
//                 // Padding(
//                 //   padding: const EdgeInsets.only(
//                 //       left: 8.0, top: 32, right: 8, bottom: 8),
//                 //   child: Visibility(
//                 //     visible: !_codeSent && !widget.login,
//                 //     child: Stack(
//                 //       alignment: Alignment.bottomCenter,
//                 //       children: <Widget>[
//                 //         CircleAvatar(
//                 //           radius: 65,
//                 //           backgroundColor: Colors.grey.shade400,
//                 //           child: ClipOval(
//                 //             child: SizedBox(
//                 //               width: 170,
//                 //               height: 170,
//                 //               child: _image == null
//                 //                   ? Image.asset(
//                 //                       'assets/images/placeholder.jpg',
//                 //                       fit: BoxFit.cover,
//                 //                     )
//                 //                   : Image.file(
//                 //                       _image!,
//                 //                       fit: BoxFit.cover,
//                 //                     ),
//                 //             ),
//                 //           ),
//                 //         ),
//                 //         Positioned(
//                 //           left: 80,
//                 //           right: 0,
//                 //           child: FloatingActionButton(
//                 //               backgroundColor: Color(COLOR_ACCENT),
//                 //               child: Icon(
//                 //                 CupertinoIcons.camera,
//                 //                 color: darkTheme
//                 //                     ? Colors.black
//                 //                     : Colors.white,
//                 //               ),
//                 //               mini: true,
//                 //               onPressed: () => _onCameraClick),
//                 //         )
//                 //       ],
//                 //     ),
//                 //   ),
//                 // ),
//
//                 /// user first name text field , this is visible until we verify the
//                 /// code in case of sign up with phone number
//                 Visibility(
//                   visible: !_codeSent && !widget.login,
//                   child: ConstrainedBox(
//                     constraints: const BoxConstraints(minWidth: double.infinity),
//                     child: Padding(
//                       padding: const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
//                       child: TextFormField(
//                         cursorColor: primaryColor,
//                         textAlignVertical: TextAlignVertical.center,
//                         validator: validateName,
//                         controller: _firstNameController,
//                         onSaved: (String? val) {
//                           firstName = val;
//                         },
//                         textInputAction: TextInputAction.next,
//                         decoration: InputDecoration(
//                           contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                           fillColor: Colors.white,
//                           hintText: 'firstName',
//                           focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0), borderSide: BorderSide(color: primaryColor, width: 2.0)),
//                           errorBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Theme.of(context).errorColor),
//                             borderRadius: BorderRadius.circular(25.0),
//                           ),
//                           focusedErrorBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Theme.of(context).errorColor),
//                             borderRadius: BorderRadius.circular(25.0),
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.grey.shade200),
//                             borderRadius: BorderRadius.circular(25.0),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 /// last name of the user , this is visible until we verify the
//                 /// code in case of sign up with phone number
//                 Visibility(
//                   visible: !_codeSent && !widget.login,
//                   child: ConstrainedBox(
//                     constraints: const BoxConstraints(minWidth: double.infinity),
//                     child: Padding(
//                       padding: const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
//                       child: TextFormField(
//                         validator: validateName,
//                         textAlignVertical: TextAlignVertical.center,
//                         cursorColor: primaryColor,
//                         onSaved: (String? val) {
//                           lastName = val;
//                         },
//                         controller: _lastNameController,
//                         textInputAction: TextInputAction.next,
//                         decoration: InputDecoration(
//                           contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                           fillColor: Colors.white,
//                           hintText: 'lastName',
//                           focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0), borderSide: const BorderSide(color: primaryColor, width: 2.0)),
//                           errorBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Theme.of(context).errorColor),
//                             borderRadius: BorderRadius.circular(25.0),
//                           ),
//                           focusedErrorBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Theme.of(context).errorColor),
//                             borderRadius: BorderRadius.circular(25.0),
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.grey.shade200),
//                             borderRadius: BorderRadius.circular(25.0),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 /// user phone number,  this is visible until we verify the code
//                 Visibility(
//                   visible: !_codeSent,
//                   child: Padding(
//                     padding: const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), shape: BoxShape.rectangle, border: Border.all(color: Colors.grey.shade200)),
//                       child: InternationalPhoneNumberInput(
//                         onInputChanged: (PhoneNumber number) => _phoneNumber = number.phoneNumber,
//                         onInputValidated: (bool value) => _isPhoneValid = value,
//                         ignoreBlank: true,
//                         autoValidateMode: AutovalidateMode.onUserInteraction,
//                         inputDecoration: const InputDecoration(
//                           hintText: 'phoneNumber',
//                           border: OutlineInputBorder(
//                             borderSide: BorderSide.none,
//                           ),
//                           isDense: true,
//                           errorBorder: OutlineInputBorder(
//                             borderSide: BorderSide.none,
//                           ),
//                         ),
//                         inputBorder: const OutlineInputBorder(
//                           borderSide: BorderSide.none,
//                         ),
//                         initialValue: PhoneNumber(isoCode: 'ET'),
//                         selectorConfig: const SelectorConfig(selectorType: PhoneInputSelectorType.DIALOG),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Visibility(
//                   visible: !_codeSent && !widget.login,
//                   child: ConstrainedBox(
//                     constraints: const BoxConstraints(minWidth: double.infinity),
//                     child: Padding(
//                       padding: const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
//                       child: TextFormField(
//                         textAlignVertical: TextAlignVertical.center,
//                         textInputAction: TextInputAction.next,
//                         onSaved: (String? val) {
//                           referralCode = val;
//                         },
//                         style: const TextStyle(fontSize: 18.0),
//                         cursorColor: primaryColor,
//                         decoration: InputDecoration(
//                           contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                           fillColor: Colors.white,
//                           hintText: 'Referral Code (Optional)',
//                           focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0), borderSide: BorderSide(color: primaryColor, width: 2.0)),
//                           errorBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Theme.of(context).errorColor),
//                             borderRadius: BorderRadius.circular(25.0),
//                           ),
//                           focusedErrorBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Theme.of(context).errorColor),
//                             borderRadius: BorderRadius.circular(25.0),
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.grey.shade200),
//                             borderRadius: BorderRadius.circular(25.0),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 /// code validation field, this is visible in case of sign up with
//                 /// phone number and the code is sent
//                 Visibility(
//                   visible: _codeSent,
//                   child: Padding(
//                     padding: const EdgeInsets.only(top: 32.0, right: 24.0, left: 24.0),
//                     child: PinCodeTextField(
//                       length: 6,
//                       appContext: context,
//                       keyboardType: TextInputType.phone,
//                       backgroundColor: Colors.transparent,
//                       pinTheme: PinTheme(
//                           shape: PinCodeFieldShape.box,
//                           borderRadius: BorderRadius.circular(5),
//                           fieldHeight: 40,
//                           fieldWidth: 40,
//                           activeColor: primaryColor,
//                           activeFillColor: darkTheme ? Colors.grey.shade700 : Colors.grey.shade100,
//                           selectedFillColor: Colors.transparent,
//                           selectedColor: primaryColor,
//                           inactiveColor: Colors.grey.shade600,
//                           inactiveFillColor: Colors.transparent),
//                       enableActiveFill: true,
//                       onCompleted: (v) {
//                         _submitCode(v);
//                       },
//                       onChanged: (value) {
//                         print(value);
//                       },
//                     ),
//                   ),
//                 ),
//
//                 /// the main action button of the screen, this is hidden if we
//                 /// received the code from firebase
//                 /// the action and the title is base on the state,
//                 /// * Sign up with email and password: send email and password to
//                 /// firebase
//                 /// * Sign up with phone number: submits the phone number to
//                 /// firebase and await for code verification
//                 Visibility(
//                   visible: !_codeSent,
//                   child: Padding(
//                     padding: const EdgeInsets.only(right: 40.0, left: 40.0, top: 40.0),
//                     child: ConstrainedBox(
//                       constraints: const BoxConstraints(minWidth: double.infinity),
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: primaryColor,
//                           padding: const EdgeInsets.only(top: 12, bottom: 12),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(25.0),
//                             side: BorderSide(
//                               color: primaryColor,
//                             ),
//                           ),
//                         ),
//                         onPressed: () => _signUp(),
//                         child: Text(
//                           'sendCode',
//                           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: darkTheme ? Colors.black : Colors.white),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(32.0),
//                   child: Center(
//                     child: Text(
//                       'OR',
//                       style: TextStyle(color: darkTheme ? Colors.white : Colors.black),
//                     ),
//                   ),
//                 ),
//
//                 /// switch between sign up with phone number and email sign up states
//                 InkWell(
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                   child: Text(
//                     widget.login ? 'Login with E-mail' : 'Sign up with E-mail',
//                     style: const TextStyle(color: Colors.lightBlue, fontWeight: FontWeight.bold, fontSize: 15, letterSpacing: 1),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   /// submits the code to firebase to be validated, then get get the user
//   /// object from firebase database
//   /// @param code the code from input from code field
//   /// creates a new user from phone login
//   void _submitCode(String code) async {
//     await showProgress(context, widget.login ? 'Logging in...' : 'Signing up...', false);
//     try {
//       if (_verificationID != null) {
//         dynamic result = await AppStateProvider.firebaseSubmitPhoneNumberCode(_verificationID!, code, _phoneNumber!,
//             firstName: _firstNameController.text, lastName: _lastNameController.text, referralCode: referralCode ?? '');
//         await hideProgress();
//         if (result != null && result is UserModel) {
//           currentUser = result;
//             push(context, const HomeScreen(),);
//           // pushAndRemoveUntil(context, ContainerScreen(user: result), false);
//         } else if (result != null && result is String) {
//           showAlertDialog(context, 'Failed', result, true);
//         } else {
//           showAlertDialog(context, 'Failed', 'Couldn\'t create new user with phone number.', true);
//         }
//       } else {
//         await hideProgress();
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text('Couldn\'t get verification ID'),
//           duration: const Duration(seconds: 6),
//         ));
//       }
//     } on auth.FirebaseAuthException catch (exception) {
//       hideProgress();
//       String message = "error-occurred";
//       switch (exception.code) {
//         case 'invalid-verification-code':
//           message = "code-expired";
//           break;
//         case 'user-disabled':
//           message = 'This user has been disabled.';
//           break;
//         default:
//           message = "error-occurred";
//           break;
//       }
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             message,
//           ),
//         ),
//       );
//     } catch (e, s) {
//       print('_PhoneNumberInputScreenState._submitCode $e $s');
//       hideProgress();
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             "error-occurred",
//           ),
//         ),
//       );
//     }
//   }
//
//   /// used on android by the image picker lib, sometimes on android the image
//   /// is lost
//   Future<void> retrieveLostData() async {
//     final LostDataResponse? response = await _imagePicker.retrieveLostData();
//     if (response == null) {
//       return;
//     }
//     if (response.file != null) {
//       setState(() {
//         _image = File(response.file!.path);
//       });
//     }
//   }
//
//   _signUp() async {
//     if (_key.currentState?.validate() ?? false) {
//       _key.currentState!.save();
//       if(widget.login){
//         await _submitPhoneNumber(_phoneNumber!);
//       }else {
//         if (_isPhoneValid) {
//           if (referralCode
//               .toString()
//               .isNotEmpty) {
//             AppStateProvider.checkReferralCodeValidOrNot(referralCode.toString()).then((value) async {
//               if (value == true) {
//                 await _submitPhoneNumber(_phoneNumber!);
//               } else {
//                 final snack = SnackBar(
//                   content: Text(
//                     'Referral Code is Invalid',
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                   duration: const Duration(seconds: 2),
//                   backgroundColor: Colors.black,
//                 );
//                 ScaffoldMessenger.of(context).showSnackBar(snack);
//               }
//             });
//           }else{
//             await _submitPhoneNumber(_phoneNumber!);
//           }
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//             content: Text("Invalid-phone-number"),
//           ));
//         }
//       }
//     } else {
//       setState(() {
//         _validate = AutovalidateMode.onUserInteraction;
//       });
//     }
//   }
//
//   /// sends a request to firebase to create a new user using phone number and
//   /// navigate to [ContainerScreen] after wards
//   _submitPhoneNumber(String phoneNumber) async {
//     //send code
//     await showProgress(context, 'Sending code...', true);
//     await AppStateProvider.firebaseSubmitPhoneNumber(
//       phoneNumber,
//       (String verificationId) {
//         if (mounted) {
//           hideProgress();
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(
//                 "verification-timeout",
//               ),
//             ),
//           );
//           setState(() {
//             _codeSent = false;
//           });
//         }
//       },
//       (String? verificationId, int? forceResendingToken) {
//         if (mounted) {
//           hideProgress();
//           _verificationID = verificationId;
//           setState(() {
//             _codeSent = true;
//           });
//         }
//       },
//       (auth.FirebaseAuthException error) {
//         if (mounted) {
//           hideProgress();
//           print('${error.message} ${error.stackTrace}');
//           String message = "error-occurred";
//           switch (error.code) {
//             case 'invalid-verification-code':
//               message = "code-expired";
//               break;
//             case 'user-disabled':
//               message = 'This user has been disabled.';
//               break;
//             default:
//               message = "error-occurred";
//               break;
//           }
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(
//                 message,
//               ),
//             ),
//           );
//         }
//       },
//       (auth.PhoneAuthCredential credential) async {
//         if (mounted) {
//           auth.UserCredential userCredential = await auth.FirebaseAuth.instance.signInWithCredential(credential);
//           UserModel? user = await AppStateProvider.getCurrentUser(userCredential.user?.uid ?? '');
//           if (user != null) {
//             hideProgress();
//             currentUser = user;
//             push(context, const HomeScreen());
//           } else {
//             /// create a new user from phone login
//             String profileImageUrl = '';
//             if (_image != null) {
//               profileImageUrl = await AppStateProvider.uploadUserImageToFireStorage(_image!, userCredential.user?.uid ?? '');
//             }
//             UserModel user = UserModel(
//                 name: _firstNameController.text,
//                 lname: _lastNameController.text,
//                 token: await AppStateProvider.firebaseMessaging.getToken() ?? '',
//                 phone: phoneNumber,
//                 email: '',
//                 profile: profileImageUrl,
//                 id: userCredential.user?.uid ?? '',
//                 addressList: []);
//             String? errorMessage = await AppStateProvider.firebaseCreateNewUser(user);
//             hideProgress();
//             if (errorMessage == null) {
//               currentUser = user;
//               push(context, const HomeScreen(), );
//             } else {
//               showAlertDialog(context, 'Failed', 'Couldn\'t create new user with phone number.', true);
//             }
//           }
//         }
//       },
//     );
//   }
// }
