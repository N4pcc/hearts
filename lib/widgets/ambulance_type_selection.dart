// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hearts/helpers/loading.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import '../helpers/style.dart';
import '../providers/app_state.dart';
import '../providers/user.dart';
import 'custom_text.dart';
import 'hearts_button.dart';
import 'hearts_text.dart';

class PaymentMethodSelectionWidget extends StatefulWidget {
  const PaymentMethodSelectionWidget({Key? key}) : super(key: key);

  @override
  State<PaymentMethodSelectionWidget> createState() =>
      _PaymentMethodSelectionWidgetState();
}

class _PaymentMethodSelectionWidgetState
    extends State<PaymentMethodSelectionWidget> {
  // bool? isCashSelected;
  // bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    AppStateProvider appState = Provider.of<AppStateProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);

    return DraggableScrollableSheet(
        initialChildSize: 0.55,
        minChildSize: 0.55,
        maxChildSize: .6,
        builder: (BuildContext context, myscrollController) {
          return StatefulBuilder(builder: (context, ss) {
            return Container(
              decoration: BoxDecoration(
                  color: white,
//                        borderRadius: BorderRadius.only(
//                            topLeft: Radius.circular(20),
//                            topRight: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.yellow.withOpacity(.8),
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
                                  showWidget: Show.pickupSelection);
                              appState.clearPoly();
                              appState.mapController
                                  .animateCamera(CameraUpdate.zoomTo(18));
                              // appState.clearPinMarkers();
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            )),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.5,
                          child: const CabText(
                            "Select Ambulance type",
                            size: 16,
                            color: white,
                            align: TextAlign.center,
                            weight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 40)
                      ],
                    ),
                  ),
                  const Divider(),
                  Center(
                    child: Padding(
                        padding: const EdgeInsets.only(bottom: 20, top: 10),
                        child: CabText(
                          "Expected Drop Off ${(appState.rideTotaTime == 0 || appState.selectedRideMode == null) ? "-" : DateFormat("hh:mm a").format(DateTime.now().add(Duration(seconds: appState.rideTotaTime * appState.getRideFares[appState.getRideFares.indexWhere((element) => appState.selectedRideMode == element.name.trim().toLowerCase().replaceAll(" ", "-"))].farePerKm ~/ 10)))}",
                          size: 14,
                        )),
                  ),
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: appState.getRideFares.length,
                      itemBuilder: (ctx, i) => Card(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        elevation: 0,
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                              side: appState.selectedRideMode ==
                                  appState.getRideFares[i].name
                                      .trim()
                                      .toLowerCase()
                                      .replaceAll(" ", "-")
                                  ? const BorderSide()
                                  : BorderSide.none,
                              borderRadius: BorderRadius.circular(20)),
                          tileColor: appState.selectedRideMode ==
                              appState.getRideFares[i].name
                                  .trim()
                                  .toLowerCase()
                                  .replaceAll(" ", "-")
                              ? Colors.grey[200]
                              : Colors.white,
                          onTap: () {
                            appState.updateSelectedRideMode(appState
                                .getRideFares[i].name
                                .trim()
                                .toLowerCase()
                                .replaceAll(" ", "-"));
                          },
                          title: CabText(appState.getRideFares[i].name,
                              weight: FontWeight.w500),
                          subtitle: CabText(
                            appState.getRideFares[i].desc,
                            size: 13,
                          ),
                          trailing: Column(
                            // mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              CabText(
                                "Starting From",
                                size: 12,
                                color: Colors.red,
                              ),
                              CabText(
                                  "ETB-${(appState.getRideFares[i].fixedRate + (appState.ridePrice * appState.getRideFares[i].farePerKm)).toInt()}.0",
                              size: 15,
                              ),
                            ],
                          ),
                          leading: Image.network(
                              appState.getRideFares[i].image,
                              width: 50),
                        ),
                      )),

                  const SizedBox(height: 20),
                  // appState.lookingForDriver
                  //     ? Padding(
                  //   padding: const EdgeInsets.only(top: 14),
                  //   child: Container(
                  //     color: white,
                  //     child: const ListTile(
                  //       title: SpinKitWave(
                  //         color: primaryColor,
                  //         size: 30,
                  //       ),
                  //     ),
                  //   ),
                  // )
                  //     : SizedBox(
                  //   width: double.infinity,
                  //   height: 48,
                  //   child: Padding(
                  //     padding: const EdgeInsets.only(
                  //       left: 15.0,
                  //       right: 15.0,
                  //     ),
                  //     child:
                      HeartsButton(
                        isLoading: false,
                        func: () async {
                          // LoadingUtils.showLoader();
                          if (appState.selectedRideMode == null) {
                            return;
                          }

                          appState.changeWidgetShowed(
                              showWidget: Show.driversListSelection);

                          // int selectedIndex = appState.getRideFares
                          //     .indexWhere((element) =>
                          // appState.selectedRideMode ==
                          //     element.name
                          //         .trim()
                          //         .toLowerCase()
                          //         .replaceAll(" ", "-"));
                          //
                          // appState.requestDriver(
                          //   //  paymentType: "cash",
                          //     price: (appState.getRideFares[selectedIndex]
                          //         .fixedRate +
                          //         (appState.ridePrice *
                          //             appState
                          //                 .getRideFares[selectedIndex]
                          //                 .farePerKm))
                          //         .toInt(),
                          //     type: appState.selectedRideMode!,
                          //     distance:
                          //     appState.routeModel!.distance.toJson(),
                          //     user: userProvider.userModel!,
                          //     pickupAddress:
                          //     appState.pickupLocationString,
                          //     lat: appState.pickupCoordinates!.latitude,
                          //     lng: appState.pickupCoordinates!.longitude,
                          //     context: context);
                          // appState.changeMainContext(context);
                          // LoadingUtils.hideLoader();
                          // //  }
                          // showDialog(
                          //     context: context,
                          //     builder: (BuildContext context) {
                          //       return Dialog(
                          //         shape: RoundedRectangleBorder(
                          //             borderRadius: BorderRadius.circular(
                          //                 20.0)), //this right here
                          //         child: SizedBox(
                          //           height: 200,
                          //           child: Padding(
                          //             padding: const EdgeInsets.all(12.0),
                          //             child: Column(
                          //               mainAxisAlignment:
                          //               MainAxisAlignment.center,
                          //               crossAxisAlignment:
                          //               CrossAxisAlignment.start,
                          //               children: [
                          //                 const SpinKitWave(
                          //                   color: primaryColor,
                          //                   size: 30,
                          //                 ),
                          //                 const SizedBox(
                          //                   height: 10,
                          //                 ),
                          //                 const Row(
                          //                   mainAxisAlignment:
                          //                   MainAxisAlignment.center,
                          //                   children: [
                          //                     CustomText(
                          //                         text:
                          //                         "Looking for an Ambulance"),
                          //                   ],
                          //                 ),
                          //                 const SizedBox(
                          //                   height: 30,
                          //                 ),
                          //                 LinearPercentIndicator(
                          //                   lineHeight: 4,
                          //                   animation: true,
                          //                   animationDuration: 100000,
                          //                   percent: 1,
                          //                   backgroundColor: Colors.grey
                          //                       .withOpacity(0.2),
                          //                   progressColor: primaryColor,
                          //                 ),
                          //                 const SizedBox(
                          //                   height: 20,
                          //                 ),
                          //                 Row(
                          //                   mainAxisAlignment:
                          //                   MainAxisAlignment.center,
                          //                   children: [
                          //                     TextButton(
                          //                         onPressed: () {
                          //                           Navigator.pop(
                          //                               context);
                          //                           appState
                          //                               .cancelRequest();
                          //                           ScaffoldMessenger.of(
                          //                               context)
                          //                               .showSnackBar(
                          //                               const SnackBar(
                          //                                   content: Text(
                          //                                       "Request cancelled!")));
                          //                         },
                          //                         child: const CustomText(
                          //                           text:
                          //                           "Cancel Request",
                          //                           color: primaryColor,
                          //                         )),
                          //                   ],
                          //                 )
                          //               ],
                          //             ),
                          //           ),
                          //         ),
                          //       );
                          //     });
                        },

                        color: appState.selectedRideMode == null
                            ? grey
                            : null,
                        text:
                        "Book ${appState.selectedRideMode?.split("-").join(" ") ?? ""}",
                        textColor: white,
                      ),
                  //   )
                  //
                  // ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            );
          });
        });
  }
}
