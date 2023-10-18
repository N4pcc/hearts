import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user.dart';

import '../widgets/address_sheet.dart';
import '../widgets/address_tile.dart';
import '../widgets/hearts_button.dart';
import '../widgets/hearts_text.dart';

class AddressScreen extends StatefulWidget {
  static const routeName = "/address";
  const AddressScreen({Key? key}) : super(key: key);

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
        backgroundColor: darkTheme ? Colors.white30 : Colors.white,
        body: Padding(
            padding: const EdgeInsets.only(top: 60, left: 15, right: 20),
            child: Column(children: [
              Row(
                children: [
                  GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child:  Icon(Icons.arrow_back_ios_new_rounded, color: darkTheme ? Colors.white : Colors.black,)),
                  const SizedBox(width: 12),
                   CabText(
                    "Hospital",
                    size: 18,
                    color:  darkTheme ? Colors.white : Colors.black,
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height - 150,
                child: ListView.builder(
                  itemCount: userProvider.userModel!.addressList.length,
                  itemBuilder: (context, index) {
                    return AddressTile(
                        address: userProvider.userModel!.addressList[index]);
                  },
                ),
              ),
              Container(
                  alignment: Alignment.center,
                  child: HeartsButton(
                      text: "+ Add Hospital",
                      textColor: Colors.white,
                      func: () {
                        addressSheet(context, null);
                      },
                      isLoading: false))
            ])));
  }
}
