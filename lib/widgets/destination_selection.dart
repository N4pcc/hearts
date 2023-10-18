import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// ignore: depend_on_referenced_packages
import 'package:google_maps_webservice/places.dart';
import 'package:hearts/helpers/loading.dart';
import 'package:hearts/widgets/myfonts.dart';
import 'package:hearts/widgets/myfonts2.dart';
import 'package:hearts/widgets/showerrorsnackbar.dart';
import 'package:provider/provider.dart';
import 'package:hearts/helpers/constant/constants.dart';
import 'package:hearts/helpers/style.dart';
import 'package:hearts/providers/app_state.dart';
import 'package:hearts/providers/user.dart';

import '../models/address_model.dart';
import 'address_sheet.dart';
import 'hearts_button.dart';

class DestinationSelectionWidget extends StatelessWidget {
  const DestinationSelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;
    UserProvider userProvider = Provider.of<UserProvider>(context);
    AppStateProvider appState = Provider.of<AppStateProvider>(context);
    return DraggableScrollableSheet(
      initialChildSize: 0.33,
      minChildSize: 0.33,
      builder: (BuildContext context, myscrollController) {
        return Container(
          decoration: BoxDecoration(
              color: darkTheme ? Colors.blueGrey : Colors.white,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                    color: grey.withOpacity(.8),
                    offset: const Offset(3, 2),
                    blurRadius: 7)
              ]),
          child: userProvider.userModel == null
              ? const Center(
                  child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                ))
              : ListView(
                  padding: EdgeInsets.zero,
                  controller: myscrollController,
                  children: [
                    const Icon(
                      Icons.remove,
                      size: 40,
                      color: grey,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20, bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                           Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Icon(
                                  HeartsIcons.ambulance_1,
                                  color: darkTheme ? Colors.white : Colors.red,
                                ),
                              ),
                              SizedBox(width: 10,),
                              Text("In need of Ambulance?",
                                  style: TextStyle(
                                      color: darkTheme ? Colors.white : Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: CircleAvatar(
                              backgroundColor: primaryColor,
                              radius: 21,
                              child: IconButton(
                                // color: Colors.transparent,
                                // highlightColor: Colors.transparent,
                                onPressed: () async {
                                  // await Firebase.initializeApp();
                                  //
                                  // DocumentSnapshot countrySnapshot;
                                  // DocumentSnapshot citySnapshot;
                                  // String filterComponentType;
                                  // String filterComponentValue;
                                  //
                                  // try {
                                  //   countrySnapshot = await FirebaseFirestore.instance.collection('settings').doc('country').get();
                                  //   citySnapshot = await FirebaseFirestore.instance.collection('settings').doc('city').get();
                                  //
                                  //   if (countrySnapshot.exists && !citySnapshot.exists) {
                                  //     filterComponentType = Component.country;
                                  //     filterComponentValue = (countrySnapshot.data()as Map)['code'];
                                  //   } else if (!countrySnapshot.exists && citySnapshot.exists) {
                                  //     filterComponentType = Component.locality;
                                  //     filterComponentValue = (citySnapshot.data()as Map)['name'];
                                  //   } else {
                                  //     // Handle the case when both documents are missing or present
                                  //     // Set default values or display an error message to the user
                                  //     filterComponentType = Component.country;
                                  //     filterComponentValue = 'ET'; // Set a default country code
                                  //     showErrorSnackbar(context, 'Error: Invalid filter data');
                                  //     // Alternatively, display an error message to the user
                                  //     // and prevent the autocomplete functionality
                                  //   }
                                  // } catch (error) {
                                  //   // Handle any errors that occur while fetching the documents
                                  //   print('Error fetching documents: $error');
                                  //   // Set default values or display an error message to the user
                                  //   filterComponentType = Component.country;
                                  //   filterComponentValue = 'ET';
                                  //   showErrorSnackbar(context, 'Error: Invalid filter data');// Set a default country code
                                  //   // Alternatively, display an error message to the user
                                  //   // and prevent the autocomplete functionality
                                  // }
                                  // SharedPreferences preferences =
                                  //     await SharedPreferences.getInstance();
                                  Prediction? p = await PlacesAutocomplete.show(
                                      context: context,
                                      apiKey: googleMapsAPIKey,
                                      onError: (v) =>
                                          ScaffoldMessenger.of(context)
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
                                    components: [
                                      Component(Component.country, 'ET'),
                                      // Component(Component.localit
                                      //
                                      // y, 'AddisAbaba'),
                                    ],

                                      //   Component(Component.country, "ET"),
                                      // ]
                                      );
                                  if (p != null) {
                                    PlacesDetailsResponse detail = await places
                                        .getDetailsByPlaceId(p.placeId!);

                                    double lat =
                                        detail.result.geometry!.location.lat;
                                    double lng =
                                        detail.result.geometry!.location.lng;
                                    appState.changeRequestedDestination(
                                        reqDestination: p.description!,
                                        lat: lat,
                                        lng: lng);
                                    // appState.des(
                                    //     address: p.description!);
                                    LatLng coordinates = LatLng(lat, lng);
                                    appState.updateDestination(
                                        destination: p.description!,
                                        destinationLatLng: coordinates);
                                    appState.setDestination(
                                        coordinates: coordinates);
                                    appState.addPickupMarker(appState.center!);
                                    appState.changeWidgetShowed(
                                        showWidget: Show.pickupSelection);
                                  }
                                },
                                icon: const Icon(
                                  HeartsIcon2.search_location,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                    ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: userProvider.userModel!.addressList.length,
                      itemBuilder: (context, index) {
                        Address address =
                            userProvider.userModel!.addressList[index];
                        return ListTile(
                          onTap: () {
                            LoadingUtils.showLoader();
                            List destList = address.line1.split(", ") +
                                address.line2.split(", ") +
                                address.area.split(", ");

                            appState.changeRequestedDestination(
                                reqDestination: destList.join(", "),
                                lat: address.lat,
                                lng: address.long);
                            appState.changePickupLocationAddress(
                                address: destList.join(", "));
                            LatLng coordinates =
                                LatLng(address.lat, address.long);
                            appState.updateDestination(
                                destination: destList.join(", "),
                                destinationLatLng: coordinates);
                            appState.setDestination(coordinates: coordinates);
                            appState.addPickupMarker(appState.center!);
                            appState.changeWidgetShowed(
                                showWidget: Show.pickupSelection);
                            LoadingUtils.hideLoader();
                          },
                          leading: CircleAvatar(
                            backgroundColor: primaryColor,
                            child: Icon(
                              address.name == "Other"
                                  ? Icons.multiple_stop_sharp
                                  : address.name == "Private"
                                      ? Icons.local_hospital
                                      : Icons.local_hospital_outlined,
                              color: white,
                            ),
                          ),
                          title: Text("${address.name} - ${address.line1}", style: TextStyle(
                            color: darkTheme ? Colors.white : Colors.black
                          ),
                              maxLines: 1, overflow: TextOverflow.ellipsis, ),
                          subtitle: Text(address.line2,
                              maxLines: 1, overflow: TextOverflow.ellipsis),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: HeartsButton(
                          text: "+ Add Hospital",
                          textColor: white,
                          func: () {
                            addressSheet(context, null);
                          },
                          isLoading: false),
                    )
                    // ListTile(
                    //   leading: CircleAvatar(
                    //     backgroundColor: primaryColor,
                    //     child: const Icon(
                    //       Icons.home,
                    //       color: white,
                    //     ),
                    //   ),
                    //   title: const Text("Home"),
                    //   subtitle: const Text("25th avenue, 23 street"),
                    // ),
                    // ListTile(
                    //   leading: CircleAvatar(
                    //     backgroundColor: primaryColor,
                    //     child: const Icon(
                    //       Icons.work,
                    //       color: white,
                    //     ),
                    //   ),
                    //   title: const Text("Work"),
                    //   subtitle: const Text("25th avenue, 23 street"),
                    // ),
                    // ListTile(
                    //   leading: CircleAvatar(
                    //     backgroundColor: Colors.grey.withOpacity(0.18),
                    //     child: const Icon(
                    //       Icons.history,
                    //       color: primary,
                    //     ),
                    //   ),
                    //   title: const Text("Recent location"),
                    //   subtitle: const Text("25th avenue, 23 street"),
                    // ),
                    // ListTile(
                    //   leading: CircleAvatar(
                    //     backgroundColor: Colors.grey.withOpacity(.18),
                    //     child: const Icon(
                    //       Icons.history,
                    //       color: primary,
                    //     ),
                    //   ),
                    //   title: const Text("Recent location"),
                    //   subtitle: const Text("25th avenue, 23 street"),
                    // ),
                  ],
                ),
        );
      },
    );
  }
}
