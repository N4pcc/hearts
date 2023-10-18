import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// ignore: depend_on_referenced_packages
import 'package:google_maps_webservice/places.dart';
import 'package:hearts/helpers/loading.dart';
import 'package:provider/provider.dart';
import 'package:hearts/helpers/constant/constants.dart';
import 'package:hearts/helpers/style.dart';
import 'package:hearts/providers/app_state.dart';

import 'package:hearts/widgets/hearts_button.dart';

import 'hearts_text.dart';

class PickupSelectionWidget extends StatelessWidget {
  const PickupSelectionWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    AppStateProvider appState = Provider.of<AppStateProvider>(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.28,
      maxChildSize: .4,
      minChildSize: 0.28,
      builder: (BuildContext context, myscrollController) {
        return Container(
          padding: const EdgeInsets.all(0),
          decoration: BoxDecoration(color: white,
//                        borderRadius: BorderRadius.only(
//                            topLeft: Radius.circular(20),
//                            topRight: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                    color: grey.withOpacity(.8),
                    offset: const Offset(3, 2),
                    blurRadius: 7)
              ]),
          child: ListView(
            padding: EdgeInsets.zero,
            controller: myscrollController,
            children: [
              Container(
                color: Colors.indigo,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          appState.changeWidgetShowed(
                              showWidget: Show.destinationSelection);
                          appState.mapController
                              .animateCamera(CameraUpdate.zoomTo(15));
                          appState.clearPinMarkers();
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        )),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: const CabText(
                        "Pickup Location",
                        size: 16,
                        color: white,
                        align: TextAlign.center,
                        weight: FontWeight.w500,
                      ),
                    ),
                    IconButton(
                        onPressed: () async {
                          // SharedPreferences preferences =
                          //     await SharedPreferences.getInstance();
                          Prediction? p = await PlacesAutocomplete.show(
                              context: context,
                              apiKey: googleMapsAPIKey,
                              onError: (v) => ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    elevation: 0,
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Colors.transparent,
                                    content: Text('Message'),
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
                          PlacesDetailsResponse detail =
                              await places.getDetailsByPlaceId(p!.placeId!);
                          double lat = detail.result.geometry!.location.lat;
                          double lng = detail.result.geometry!.location.lng;
                          // appState.changeRequestedDestination(
                          //     reqDestination: p.description!,
                          //     lat: lat,
                          //     lng: lng);
                          LatLng coordinates = LatLng(lat, lng);
                          // appState.updateDestination(
                          //     destination: p.description!,
                          //     destinationLatLng: coordinates);
                          // appState.setDestination(coordinates: coordinates);
                          appState.setPickCoordinates(coordinates: coordinates);
                          appState.changePickupLocationAddress(
                              address: p.description!);
                        },
                        icon: const Icon(
                          Icons.search,
                          color: Colors.white,
                        )),
                  ],
                ),
              ),
              const Divider(),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 6),
                child: Row(
                  children: [
                    Container(
                      margin:
                          const EdgeInsets.only(right: 10, left: 10, bottom: 5),
                      child: const Icon(
                        Icons.location_on,
                        color: primaryColor,
                      ),
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width - 80,
                        child: CabText(
                          appState.pickupLocationString,
                          size: 14,
                        ))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: HeartsButton(
                    text: "Confirm Pickup",
                    textColor: white,
                    func: () async {
                      LoadingUtils.showLoader();
                      await appState.sendRequest();
                      appState.changeWidgetShowed(
                          showWidget: Show.paymentSelection);
                      appState.mapController
                          .animateCamera(CameraUpdate.zoomTo(16));
                      LoadingUtils.hideLoader();
                    },
                    isLoading: false),
              )
              // SizedBox(
              //   width: double.infinity,
              //   height: 48,
              //   child: Padding(
              //     padding: const EdgeInsets.only(
              //       left: 15.0,
              //       right: 15.0,
              //     ),
              //     child: ElevatedButton(
              //       onPressed: () async {

              //       },
              //       style: const ButtonStyle(
              //           backgroundColor: MaterialStatePropertyAll(black)),
              //       child: const Text(
              //         "Comfirm Pickup",
              //         style: TextStyle(color: white, fontSize: 16),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }
}
