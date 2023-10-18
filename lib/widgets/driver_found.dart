import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hearts/helpers/style.dart';
import 'package:hearts/locators/service_locator.dart';
import 'package:hearts/providers/app_state.dart';
import 'package:hearts/services/call_sms.dart';

import '../helpers/custom_dialog.dart';
import 'hearts_button.dart';
import 'hearts_text.dart';
import 'custom_text.dart';

class DriverFoundWidget extends StatelessWidget {
  final CallsAndMessagesService _service = locator<CallsAndMessagesService>();

  DriverFoundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    AppStateProvider appState = Provider.of<AppStateProvider>(context);

    return DraggableScrollableSheet(
        initialChildSize: 0.2,
        minChildSize: 0.05,
        maxChildSize: 0.8,
        builder: (BuildContext context, myscrollController) {
          return Container(
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
              controller: myscrollController,
              padding: EdgeInsets.zero,
              children: [
                // const SizedBox(
                //   height: 8,
                // ),
                Container(
                  color: green,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          child: appState.driverArrived == false
                              ? CustomText(
                                  text:
                                      'Your Ambulance arrives in ${appState.routeModel?.timeNeeded.text ?? ""}',
                                  size: 16,
                                  color: white,
                                  weight: FontWeight.w300,
                                )
                              : const CustomText(
                                  text: 'Your Ambulance has arrived',
                                  size: 16,
                                  color: white,
                                  weight: FontWeight.w500,
                                )),
                    ],
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: Container(
                    child: appState.driverModel?.phone == null
                        ? const CircleAvatar(
                            radius: 30,
                            child: Icon(
                              Icons.person_outline,
                              size: 25,
                            ),
                          )
                        : CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                NetworkImage(appState.driverModel!.photo),
                          ),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: appState.driverModel?.name ?? "",
                            style: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: "\n${appState.driverModel?.car ?? ""}",
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w300)),
                      ], style: const TextStyle(color: black))),
                    ],
                  ),
                  subtitle: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              Colors.grey.withOpacity(0.5))),
                      onPressed: null,
                      child: CustomText(
                        text: appState.driverModel?.plate ?? "",
                        color: white,
                      )),
                  trailing: Container(
                      decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20)),
                      child: IconButton(
                        onPressed: () {
                          _service.call(appState.driverModel?.phone ?? "");
                        },
                        icon: const Icon(Icons.call),
                      )),
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: CustomText(
                    text: "Booking details",
                    size: 18,
                    weight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      height: 100,
                      width: 10,
                      child: Column(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: grey,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 9),
                            child: Container(
                              height: 45,
                              width: 2,
                              color: primary,
                            ),
                          ),
                          const Icon(Icons.flag),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Flexible(
                      child: RichText(
                          text: TextSpan(children: [
                        const TextSpan(
                            text: "\nPickup location \n",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        TextSpan(
                            text:
                                "${appState.rideRequestModel!.pickupAddress} \n\n\n",
                            style: const TextStyle(
                                fontWeight: FontWeight.w300, fontSize: 16)),
                        const TextSpan(
                            text: "Destination \n",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        TextSpan(
                            text:
                                "${appState.rideRequestModel!.destination["address"]} \n",
                            style: const TextStyle(
                                fontWeight: FontWeight.w300, fontSize: 16)),
                      ], style: const TextStyle(color: black))),
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(12),
                      child: CustomText(
                        text: "Booking price",
                        size: 18,
                        weight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: CustomText(
                        text:
                            "ETB${appState.rideRequestModel!.price.toStringAsFixed(2)}",
                        size: 18,
                        weight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: HeartsButton(
                    text: "Cancel Booking",
                    func: () {
                      showCustomDialog(
                          context,
                          230,
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(Icons.remove_circle_outline,
                                    color: Colors.red, size: 60),
                                const CabText(
                                  "You have cancelled the Booking.",
                                  color: black,
                                  align: TextAlign.center,
                                ),
                                HeartsButton(
                                    height: 40,
                                    width: 180,
                                    text: "Back to Home",
                                    func: () async {
                                      appState.cancelRequest();
                                      Navigator.of(context).pop();
                                    },
                                    isLoading: false)
                              ],
                            ),
                          ));
                    },
                    isLoading: false,
                    textColor: Colors.white,
                    color: Colors.red[700],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
