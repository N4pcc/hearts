import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hearts/helpers/style.dart';
import 'package:hearts/providers/app_state.dart';

import 'custom_text.dart';

class TripWidget extends StatelessWidget {
  const TripWidget({super.key});

  @override
  Widget build(BuildContext context) {
    AppStateProvider appState = Provider.of<AppStateProvider>(context);

    return DraggableScrollableSheet(
        initialChildSize: 0.2,
        minChildSize: 0.2,
        maxChildSize: 0.6,
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
              padding: const EdgeInsets.all(10),
              controller: myscrollController,
              children: [
                const SizedBox(
                  height: 12,
                ),
                const Center(
                  child: CustomText(
                    text: 'ON The Way',
                    weight: FontWeight.bold,
                    color: green,
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
                            text: appState.driverModel?.name ?? "" "\n",
                            style: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: "\n${appState.driverModel?.car ?? ""}",
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w300)),
                      ], style: const TextStyle(color: black))),
                    ],
                  ),
//                  subtitle: ElevatedButton(
//                      color: Colors.white.withOpacity(.9),
//                      onPressed: (){},
//                      child: CustomText(
//                        text: "End Trip",
//                        color: red,
//                      )),
                  trailing: Container(
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(30)),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.info,
                          color: white,
                        ),
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
                              height: 65,
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
                            //maxLines: 10,
                            text: TextSpan(children: [
                      const TextSpan(
                          text: "\nPick up location \n",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      TextSpan(
                          text:
                              "${appState.rideRequestModel?.pickupAddress} \n\n\n",
                          style: const TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 16)),
                      const TextSpan(
                          text: "Destination \n",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      TextSpan(
                          text:
                              "${appState.rideRequestModel?.destination["Hospital"]} \n",
                          style: const TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 16)),
                    ], style: const TextStyle(color: black)))),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(12),
                      child: CustomText(
                        text: "Booking fare",
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
                // Padding(
                //   padding: const EdgeInsets.all(12),
                //   child: CabButton(
                //     text: "Complete Ride",
                //     func: () {},
                //     isLoading: false,
                //     textColor: Colors.white,
                //     color: Colors.greenAccent[700],
                //   ),
                // )
              ],
            ),
          );
        });
  }
}
