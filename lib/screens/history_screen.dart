import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:hearts/services/history_service.dart';

import '../helpers/language_constants.dart';
import '../helpers/style.dart';
import '../providers/user.dart';

import '../widgets/hearts_text.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  HistoryScreenState createState() => HistoryScreenState();
}

class HistoryScreenState extends State<HistoryScreen> {
  List rideHistory = [];
  @override
  void initState() {
    UserProvider userProvider =
    Provider.of<UserProvider>(context, listen: false);
    HistoryService.fetchUserHistory(userProvider.userModel!.id)
        .then((value) => setState(() {
      rideHistory = value;
    }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      backgroundColor: darkTheme ? Colors.white30 : Colors.white,
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: SingleChildScrollView(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 30, bottom: 10),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 24,
                        //color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                     CabText(
                      "Booking History",
                      size: 20,
                      color: darkTheme ? Colors.white : Colors.black,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height - 90,
                child: ListView.builder(
                  itemCount: rideHistory.length,
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(10),
                  itemBuilder: (context, i) {
                    return Card(
                      elevation: 2,
                      color: darkTheme ? Colors.blueGrey : Colors.white,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 6),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CabText("Id: ${rideHistory[i]["id"]}",
                                    size: 14,
                                    color: darkTheme ? Colors.yellowAccent : Colors.blueAccent,
                                    weight: FontWeight.bold),
                                Row(
                                  children: [
                                    GestureDetector(
                                      // onTap: () => downloadPdf(),
                                        child: const Icon(Icons.done_all,
                                            color: green, size: 28)),
                                    const SizedBox(width: 4),
                                    // Text(
                                    //     "${durationToString(rideHistor[i].bookingDuration)} Hr."),
                                  ],
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: CabText(
                                  "Date: ${DateFormat("MMM dd,yy hh:mm a").format(DateTime.parse(rideHistory[i]["time"]))}",
                                  size: 12,
                                  color: darkTheme? Colors.white70 : Colors.blueGrey),
                            ),
                            Center(
                              child: Padding(
                                padding:
                                const EdgeInsets.symmetric(vertical: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          1.4,
                                      child: Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.location_on_outlined,
                                              size: 20),
                                          const SizedBox(width: 5),
                                          Flexible(
                                            child: CabText(
                                                rideHistory[i]["address"]
                                                    .toString()
                                                    .split(" - ")[0],
                                                align: TextAlign.center,
                                                size: 14),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const RotatedBox(
                                        quarterTurns: 1,
                                        child: Icon(Icons.double_arrow_sharp)),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          1.4,
                                      child: Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.location_on_outlined,
                                              size: 20),
                                          const SizedBox(width: 5),
                                          Flexible(
                                            child: CabText(
                                                rideHistory[i]["address"]
                                                    .toString()
                                                    .split(" - ")[1],
                                                align: TextAlign.center,
                                                size: 14),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 4),
                                  child: CabText(
                                    "Total: ETB${rideHistory[i]["amount"]}",
                                    size: 16,
                                    weight: FontWeight.bold,
                                  ),
                                ),
                                rideHistory[i]["rating"] != null
                                    ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 2),
                                  child: RatingBar.builder(
                                    initialRating: rideHistory[i]
                                    ["rating"]
                                        .toDouble(),
                                    minRating: 1,
                                    itemSize: 20,
                                    ignoreGestures: true,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemPadding:
                                    const EdgeInsets.symmetric(
                                        horizontal: 1),
                                    itemBuilder: (context, _) =>
                                    const Icon(
                                      Icons.star,
                                      color: Colors.blue,
                                    ),
                                    onRatingUpdate: (rating) {},
                                  ),
                                )
                                    : const SizedBox(),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

