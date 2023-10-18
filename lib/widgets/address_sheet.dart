// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:provider/provider.dart';
import 'package:hearts/helpers/style.dart';
// ignore: depend_on_referenced_packages
import 'package:google_maps_webservice/places.dart';
import '../../models/address_model.dart';

import '../helpers/constant/constants.dart';
import '../helpers/methods.dart';
import '../providers/app_state.dart';
import '../providers/user.dart';
import '../services/address_service.dart';
import 'hearts_button.dart';
import 'hearts_text.dart';
import 'hearts_text_field.dart';

void addressSheet(BuildContext context, Address? address) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (builder) {
        return AddressSheet(address: address);
      });
}

class AddressSheet extends StatefulWidget {
  final Address? address;
  const AddressSheet({Key? key, this.address}) : super(key: key);

  @override
  State<AddressSheet> createState() => _AddressSheetState();
}

class _AddressSheetState extends State<AddressSheet> {
  GlobalKey<FormState> addressFormKey = GlobalKey();

  TextEditingController line1Controller = TextEditingController();
  TextEditingController line2Controller = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController latController = TextEditingController();
  TextEditingController longController = TextEditingController();

  FocusNode line1Node = FocusNode();
  FocusNode line2Node = FocusNode();
  FocusNode areaNode = FocusNode();

  String type = "Home";
  double height = 520;
  bool isLoading = false;

  @override
  void initState() {
    if (widget.address != null) {
      line1Controller.text = widget.address!.line1;
      line2Controller.text = widget.address!.line2;
      areaController.text = widget.address!.area;
      latController.text = widget.address!.lat.toString();
      longController.text = widget.address!.long.toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    AppStateProvider appState = Provider.of<AppStateProvider>(context);
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: AnimatedContainer(
        // color: darkTheme ? Colors.white30 : Colors.white,
          duration: const Duration(milliseconds: 400),
          padding: const EdgeInsets.all(14),
          height: height,
          decoration:  BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0))),
          child: Form(
            key: addressFormKey,
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(

                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CabText(
                            "${widget.address == null ? "Add" : "Update"} Hospital",
                            size: 18,
                            weight: FontWeight.w500,
                          ),
                        ),
                        GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: const Icon(Icons.close))
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                          style: ButtonStyle(
                              padding: const MaterialStatePropertyAll(
                                  EdgeInsets.all(12)),
                              side: const MaterialStatePropertyAll(
                                  BorderSide(color: primaryColor, width: 2)),
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10)))),
                          onPressed: () async {
                            Prediction? p = await PlacesAutocomplete.show(
                                context: context,
                                apiKey: googleMapsAPIKey,
                                onError: (v) => ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      elevation: 0,
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Colors.transparent,
                                      content: Text(
                                        'Message',
                                      ),
                                    )),
                                mode: Mode.overlay,
                                language: 'en',
                                radius: 50000,
                                strictbounds: false,
                                types: [""],
                                location: Location(
                                    lat: appState.position.latitude,
                                    lng: appState.position.longitude),
                                components: []
                                //   Component(Component.country, "in"),
                                // ]
                                );
                            if (p != null) {
                              PlacesDetailsResponse detail =
                                  await places.getDetailsByPlaceId(p.placeId!);
                              double lat = detail.result.geometry!.location.lat;
                              double lng = detail.result.geometry!.location.lng;
                              latController.text = lat.toString();
                              longController.text = lng.toString();
                              List addressData = p.description!.split(", ");
                              areaController.text =
                                  addressData[addressData.length - 3] +
                                      ", " +
                                      addressData[addressData.length - 2] +
                                      ", " +
                                      addressData[addressData.length - 1];
                              line1Controller.text =
                                  addressData[0] + ", " + addressData[1];
                              addressData.removeRange(
                                  addressData.length - 3, addressData.length);
                              addressData.removeRange(0, 2);
                              line2Controller.text = addressData.join(", ");

                              setState(() {});
                            }
                          },
                          child: const CabText("Search Hospital")),
                    ),
                    const SizedBox(height: 8),
                    ListTileTheme(
                        data: const ListTileThemeData(horizontalTitleGap: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                                width: 100,
                                child: RadioListTile(
                                  dense: true,
                                  activeColor: primaryColor,
                                  contentPadding: EdgeInsets.zero,
                                  title: const CabText("Public", size: 14),
                                  value: "Public",
                                  groupValue: type,
                                  onChanged: (value) {
                                    setState(() {
                                      type = value.toString();
                                    });
                                  },
                                )),
                            SizedBox(
                                width: 100,
                                child: RadioListTile(
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                  title: const CabText("Private", size: 14),
                                  value: "Private",
                                  activeColor: primaryColor,
                                  groupValue: type,
                                  onChanged: (value) {
                                    setState(() {
                                      type = value.toString();
                                    });
                                  },
                                )),
                            SizedBox(
                                width: 100,
                                child: RadioListTile(
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                  activeColor: primaryColor,
                                  title: const CabText("Other", size: 14),
                                  value: "Other",
                                  groupValue: type,
                                  onChanged: (value) {
                                    setState(() {
                                      type = value.toString();
                                    });
                                  },
                                )),
                          ],
                        )),
                    const SizedBox(height: 10),
                    HeartsTextField(
                      controller: line1Controller,
                      hintText: "Address Line 1 *".toUpperCase(),
                      isPassword: false,
                      action: TextInputAction.next,
                      node: line1Node,
                      nextNode: line2Node,
                    ),
                    const SizedBox(height: 10),
                    HeartsTextField(
                      controller: line2Controller,
                      hintText: "Address Line 2 *".toUpperCase(),
                      isPassword: false,
                      action: TextInputAction.next,
                      node: line2Node,
                      nextNode: areaNode,
                    ),
                    const SizedBox(height: 10),
                    HeartsTextField(
                        controller: areaController,
                        hintText: "Area *".toUpperCase(),
                        isPassword: false,
                        node: areaNode),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .45,
                          child: HeartsTextField(
                            controller: latController,
                            hintText: "Latitude".toUpperCase(),
                            isPassword: false,
                            isEnabled: false,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .45,
                          child: HeartsTextField(
                            controller: longController,
                            hintText: "Longitude".toUpperCase(),
                            isPassword: false,
                            isEnabled: false,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Card(
                      elevation: 6,
                      child: HeartsButton(
                          height: 44,
                          isLoading: isLoading,
                          text:
                              "${widget.address == null ? "Add" : "Update"} Hospital",
                          textSize: 16,
                          func: () async {
                            if (addressFormKey.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                              });
                              try {
                                if (widget.address == null) {
                                  Address address = Address(
                                      name: type,
                                      line1: line1Controller.text.trim(),
                                      line2: line2Controller.text.trim(),
                                      area: areaController.text.trim(),
                                      lat: double.parse(
                                          latController.text.trim()),
                                      long: double.parse(
                                          longController.text.trim()));
                                  Map<String, dynamic> fireAddress =
                                      await AddressService()
                                          .addAddressService(address: address);
                                  await userProvider.addAddress(
                                      address: Address.fromSnap(fireAddress));
                                } else {
                                  Address updateAddress = Address(
                                      id: widget.address!.id,
                                      name: type,
                                      line1: line1Controller.text.trim(),
                                      line2: line2Controller.text.trim(),
                                      area: areaController.text.trim(),
                                      lat: double.parse(
                                          latController.text.trim()),
                                      long: double.parse(
                                          longController.text.trim()));
                                  await userProvider.updateAddress(
                                      address: updateAddress);
                                }
                                Navigator.of(context).pop();
                                showSnack(
                                    context: context,
                                    message:
                                        'Hospital ${widget.address == null ? "Added" : "Updated"} Successfully.',
                                    color: Colors.green);
                              } catch (e) {
                                Navigator.of(context).pop();
                                showSnack(
                                    context: context,
                                    message:
                                        'An error occurred. Please try again',
                                    color: Colors.red);
                              }
                              setState(() {
                                isLoading = false;
                              });
                            } else {
                              setState(() {
                                height = 600;
                              });
                            }
                          }),
                    ),
                  ]),
            ),
          )),
    );
  }
}
