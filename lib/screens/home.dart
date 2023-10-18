import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hearts/widgets/paymentscreen.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:hearts/helpers/constant/constants.dart';
import 'package:hearts/helpers/style.dart';
import 'package:hearts/providers/app_state.dart';
import "package:google_maps_webservice/places.dart";
import 'package:hearts/providers/user.dart';
import 'package:hearts/screens/address.dart';
import 'package:hearts/screens/history_screen.dart';
import 'package:hearts/screens/profile.dart';

import 'package:hearts/widgets/custom_text.dart';
import 'package:hearts/widgets/destination_selection.dart';
import 'package:hearts/widgets/driver_found.dart';
import 'package:hearts/widgets/loading.dart';
import 'package:hearts/widgets/ambulance_type_selection.dart';
import 'package:hearts/widgets/pickup_selection_widget.dart';
import 'package:hearts/widgets/trip_draggable.dart';

import '../widgets/add_review_sheet.dart';
import '../widgets/drivers_list.dart';
import '../widgets/myfonts.dart';
import '../widgets/oval_right_clipper.dart';
import 'login.dart';

final GlobalKey<ScaffoldState> heartsKey = GlobalKey();
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  var scaffoldState = GlobalKey<ScaffoldState>();


  @override
  void initState() {
    super.initState();
    _deviceToken();
  }

  _deviceToken() async {
    UserProvider user = Provider.of<UserProvider>(context, listen: false);
    AppStateProvider app =
        Provider.of<AppStateProvider>(context, listen: false);
    await user.initialize();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // if (user.userModel?.token != prefs.getString('token')) {
    user.saveDeviceToken();
    //}

    // print(prefs.getString(showPref));
    // print(prefs.getString(driverIdPref));
    if (prefs.getString(requestIdPref) != null &&
        prefs.getString(requestIdPref)!.isNotEmpty) {
      await app.listenToRequest(
          id: prefs.getString(requestIdPref)!, context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    AppStateProvider appState = Provider.of<AppStateProvider>(context);
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      key: heartsKey,
      drawer: ClipPath(
        clipper: OvalRightBorderClipper(),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Drawer(
          child: Container(
            padding: const EdgeInsets.only(left: 16.0, right: 40),
            decoration: BoxDecoration(
                color: darkTheme ? Colors.black38 : Colors.grey[300],
                boxShadow: const [BoxShadow(color: Colors.black45)]),
            width: 300,
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        alignment: Alignment.centerRight,
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(50),
                          boxShadow:  [
                            BoxShadow(
                                color: darkTheme ? Colors.black26 : const Color(0xFFBEBEBE),
                                offset: const Offset(10, 10),
                                blurRadius: 20,
                                spreadRadius: 1
                            ),
                            BoxShadow(
                                color: darkTheme ? Colors.white24 : Colors.white,
                                offset: const Offset(-5, -5),
                                blurRadius: 20,
                                spreadRadius: 1
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.power_settings_new,
                            color: primaryColor,
                          ),
                          onPressed: () {
                            FirebaseAuth.instance.signOut();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()));
                          },
                        ),
                      ),
                    ),
                    Container(
                      height: 90,
                      width: 90,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 2, color: Colors.orange),
                      ),
                      child: const CircleAvatar(
                          radius: 40,
                          backgroundImage: AssetImage('assets/HEARTS2.png')),
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      userProvider.userModel?.name ?? "This is null",
                      style: TextStyle(
                          color: darkTheme ? Colors.white : Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      userProvider.userModel?.email ?? "This is null",
                      style: TextStyle(
                          color: darkTheme ? Colors.white : Colors.black,
                          fontSize: 16.0),
                    ),
                    30.height,
                    GestureDetector(
                      child: _buildRow(Icons.person_pin, "My profile"),
                      onTap: () {
                        finish(context);
                        const ProfileScreen().launch(context);
                      },
                    ),
                    _buildDivider(),
                    GestureDetector(
                      child: _buildRow(Icons.history, "Booking History",
                          showBadge: true),
                      onTap: () {
                        finish(context);
                        const HistoryScreen().launch(context);
                      },
                    ),
                    _buildDivider(),
                    GestureDetector(
                      child: _buildRow(
                          Icons.local_hospital, "My Hospitals"),
                      onTap: () {
                        finish(context);
                        const AddressScreen().launch(context);
                      },
                    ),
                    _buildDivider(),
                    GestureDetector(
                      child: _buildRow(
                          Icons.history, "Emergency and \nMedication History"),
                      onTap: () {
                        finish(context);
                        // HEARTSMyRidesScreen().launch(context);
                      },
                    ),
                    _buildDivider(),
                    GestureDetector(
                      child: _buildRow(Icons.info_outline, "Help"),
                      onTap: () {
                        finish(context);
                        // HEARTSMyRidesScreen().launch(context);
                      },
                    ),
                    _buildDivider(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
        backgroundColor: darkTheme ? Colors.white30 : Colors.white,
      // drawer: Drawer(
      //     child: ListView(
      //   children: [
      //     UserAccountsDrawerHeader(
      //         onDetailsPressed: () =>
      //             changeScreen(context, const ProfileScreen()),
      //         accountName: CustomText(
      //           text: userProvider.userModel?.name ?? "This is null",
      //           size: 18,
      //           weight: FontWeight.bold,
      //         ),
      //         accountEmail: CustomText(
      //           text: userProvider.userModel?.email ?? "This is null",
      //         )),
      //     ListTile(
      //       leading: const Icon(Icons.history),
      //       title: const CustomText(text: "Booking History"),
      //       onTap: () {
      //         changeScreen(context, const HistoryScreen());
      //       },
      //     ),
      //     ListTile(
      //       leading: const Icon(Icons.location_pin),
      //       title: const CustomText(text: "My Hospitals"),
      //       onTap: () {
      //         changeScreen(context, const AddressScreen());
      //       },
      //     ),
      //     ListTile(
      //       leading: const Icon(Icons.exit_to_app),
      //       title: const CustomText(text: "Log out"),
      //       onTap: () {
      //         userProvider.signOut(context);
      //       },
      //     )
      //   ],
      // )),
      body: Stack(
        children: [
          MapScreen(scaffoldState),
          Visibility(
            visible: appState.show == Show.driverSelection,
            child: Positioned(
                top: 60,
                left: 25,

                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        child: appState.driverArrived
                            ? Container(
                                color: green,
                                child: const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: CustomText(
                                    text: "Meet driver at the pick up location",
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : Container(
                                color: primary,
                                child: const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: CustomText(
                                    text: "Meet Ambulance driver at the pick up location",
                                    weight: FontWeight.w300,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                )),
          ),
          Visibility(
            visible: appState.show == Show.trip,
            child: Positioned(
                top: 60,
                left: MediaQuery.of(context).size.width / 7,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        color: primary,
                        child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: RichText(
                                text: TextSpan(children: [
                              const TextSpan(
                                  text: "You'll reach your destination in \n",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w300)),
                              TextSpan(
                                  text: appState.show == Show.trip
                                      ? appState.routeModel?.timeNeeded.text ??
                                          ""
                                      : "",
                                  style: const TextStyle(fontSize: 22)),
                            ]))),
                      ),
                    ],
                  ),
                )),
          ),
          // ANCHOR Draggable
          Visibility(
              visible: appState.show == Show.destinationSelection,
              child: const DestinationSelectionWidget()),

          Visibility(
              visible: appState.show == Show.addReview,
              child: const AddReviewSheet()),
          // ANCHOR PICK UP WIDGET
          Visibility(
            visible: appState.show == Show.pickupSelection,
            child: const PickupSelectionWidget(),
          ),
          //  ANCHOR Draggable PAYMENT METHOD
          Visibility(
              visible: appState.show == Show.paymentSelection,
              child: const PaymentMethodSelectionWidget()),
          //  ANCHOR Draggable PAYMENT METHOD
          Visibility(
              visible: appState.show == Show.paymentScreen,
              child:  PaymentScreen()),
          //  ANCHOR Draggable PAYMENT METHOD
          Visibility(
              visible: appState.show == Show.driversListSelection,
              child: const DriversList()),
          //  ANCHOR Draggable DRIVER
          Visibility(
              visible: appState.show == Show.driverSelection,
              child: DriverFoundWidget()),

          //  ANCHOR Draggable DRIVER
          Visibility(
              visible: appState.show == Show.trip, child: const TripWidget()),
        ],
      ),
    );
  }
  Divider _buildDivider() {
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Divider(
      color: darkTheme ? Colors.white : Colors.grey.shade600,
    );
  }

  Widget _buildRow(IconData icon, String title, {bool showBadge = false}) {
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    final TextStyle tStyle = TextStyle(
        color: darkTheme ? Colors.white : Colors.black, fontSize: 16.0);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(children: [
        Icon(
          icon,
          color: darkTheme ? Colors.white70 : Colors.black,
        ),
        const SizedBox(width: 10.0),
        Text(
          title,
          style: tStyle,
        ),
        const Spacer(),
        if (showBadge)
          Material(
            color: Colors.red,
            elevation: 5.0,
            shadowColor: Colors.red,
            borderRadius: BorderRadius.circular(5.0),
            child: Container(
              width: 25,
              height: 25,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.deepPurpleAccent,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: const Text(
                "0+",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          )
      ]),
    );
  }
}

class MapScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldState;

  const MapScreen(this.scaffoldState, {super.key});

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  GoogleMapsPlaces? googlePlaces;
  TextEditingController destinationController = TextEditingController();
  Color darkBlue = Colors.black;
  Color grey = Colors.grey;
  GlobalKey<ScaffoldState> scaffoldSate = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    scaffoldSate = widget.scaffoldState;
  }

  @override
  Widget build(BuildContext context) {
    AppStateProvider appState = Provider.of<AppStateProvider>(context);
    // UserProvider userProvider = Provider.of<UserProvider>(context);
    double w = MediaQuery.of(context).size.width;

    return appState.center == null
        ? const Loading()
        : Stack(
            children: <Widget>[
              GoogleMap(
                initialCameraPosition:
                    CameraPosition(target: appState.center!, zoom: 15),
                onMapCreated: appState.onCreate,
                myLocationEnabled: true,
                mapType: MapType.normal,
                myLocationButtonEnabled: false,
                compassEnabled: true,
                rotateGesturesEnabled: true,
                zoomControlsEnabled: false,
                padding: const EdgeInsets.symmetric(vertical: 30),
                markers: appState.markers,
                onCameraIdle: appState.onCameraIdle,
                onCameraMove: appState.onCameraMove,
                polylines: appState.poly,
                mapToolbarEnabled: true

              ),
              Padding(
                padding: EdgeInsets.fromLTRB(15.5, w / 9.5, w / 15, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        HapticFeedback.lightImpact();
                        heartsKey.currentState!.openDrawer();
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) {
                        //       return const RouteWhereYouGo();
                        //     },
                        //   ),
                        // );
                      },
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(99)),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
                          child: Container(
                            height: w / 8.5,
                            width: w / 8.5,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              shape: BoxShape.circle,
                              boxShadow: const [
                                BoxShadow(
                                    color: Color(0xFFBEBEBE),
                                    offset: Offset(10, 10),
                                    blurRadius: 20,
                                    spreadRadius: 1),
                                BoxShadow(
                                    color: Colors.white,
                                    offset: Offset(-10, -10),
                                    blurRadius: 20,
                                    spreadRadius: 1),
                              ],
                            ),
                            child: Center(
                              child: Icon(
                                HeartsIcons.th_large,
                                size: w / 17,
                                color: primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                  bottom: MediaQuery.of(context).size.height / 3,
                  right: 20,
                  child: SizedBox(
                    width: 46,
                    child: FloatingActionButton(
                      backgroundColor: primaryColor,
                      onPressed: () {
                        Geolocator.getCurrentPosition().then((value) => appState
                            .mapController
                            .animateCamera(CameraUpdate.newLatLng(
                                LatLng(value.latitude, value.longitude))));
                      },
                      child: const Icon(
                        Icons.my_location_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ))
//              Positioned(
//                bottom: 60,
//                right: 0,
//                left: 0,
//                height: 60,
//                child: Visibility(
//                  visible: appState.routeModel != null,
//                  child: Padding(
//                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
//                    child: Container(
//                      color: Colors.white,
//                      child: Row(
//                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                        children: <Widget>[
//                          TextButton.icon(
//                              onPressed: null,
//                              icon: Icon(Icons.timer),
//                              label: Text(
//                                  appState.routeModel?.timeNeeded?.text ?? "")),
//                          TextButton.icon(
//                              onPressed: null,
//                              icon: Icon(Icons.flag),
//                              label: Text(
//                                  appState.routeModel?.distance?.text ?? "")),
//                          TextButton(
//                              onPressed: () {},
//                              child: CustomText(
//                                text:
//                                    "\$${appState.routeModel?.distance?.value == null ? 0 : appState.routeModel?.distance?.value / 500}" ??
//                                        "",
//                                color: primaryColor,
//                              ))
//                        ],
//                      ),
//                    ),
//                  ),
//                ),
//              ),
            ],
          );

  }

}
