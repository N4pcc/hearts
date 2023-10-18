import 'package:flutter/material.dart';
import 'package:hearts/helpers/style.dart';
import 'package:provider/provider.dart';
import 'package:hearts/helpers/methods.dart';

import '../models/address_model.dart';
import '../providers/user.dart';
import 'address_sheet.dart';
import 'hearts_text.dart';

class AddressTile extends StatelessWidget {
  final Address address;
  final bool? removable;
  final double? leftMargin;
  final double? size;
  const AddressTile(
      {Key? key,
      required this.address,
      this.removable,
      this.size,
      this.leftMargin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Card(
      color: darkTheme ? Colors.white24 : Colors.white,
        elevation: leftMargin != 0 ? 4 : 0,
        margin: EdgeInsets.only(bottom: 10, left: leftMargin ?? 6, right: 6),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      if (address.id != null &&
                          (address.id == "billing" || address.id == "delivery"))
                        CabText(
                          "${address.id.toString().capitalize()} - ",
                          weight: FontWeight.w500,
                        ),
                      CabText(address.name, size: size, color: darkTheme ? Colors.white : Colors.black,),
                    ],
                  ),
                  if (removable == null)
                    GestureDetector(
                      onTap: () {
                        userProvider.removeAddress(id: address.id!);
                      },
                      child: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                      ),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  height: 1,
                  color: Colors.grey,
                ),
              ),
              CabText('${address.line1}, ${address.line2}, ${address.area}',
                  size: size ?? 15, color: darkTheme ? Colors.white : Colors.black),
              if (leftMargin != 0)
                Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: () {
                      addressSheet(context, address);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 6),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 3),
                      decoration: BoxDecoration(border: Border.all(), color: primaryColor),
                      child:  CabText("Edit", size: 14, color: darkTheme ? Colors.white : Colors.white,),
                    ),
                  ),
                )
            ],
          ),
        ));
  }
}
