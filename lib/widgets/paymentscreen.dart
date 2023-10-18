import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import '../helpers/loading.dart';
import '../helpers/style.dart';
import '../providers/app_state.dart';
import '../providers/user.dart';
import '../services/drivers.dart';
import 'custom_text.dart';

class PaymentScreen extends StatelessWidget {
  final List<Map<String, dynamic>> paymentOptions = [
    {
      'icon': Icons.account_balance_wallet,
      'title': 'Wallet Pay',
    },
    {
      'icon': Icons.calendar_today,
      'title': 'Pay Later',
    },
    {
      'icon': Icons.payment,
      'title': 'Pay Here',
    },
  ];

  _customAlertDialog(BuildContext context, AlertDialogType type) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          type: type,
          title: "Pre-Payment Screen",
          content: "price is :- ",
        );
      },
    );
  }

  PaymentScreen({Key? key}) : super(key: key);
String? selectedDriversName;
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);
    final DriverService _driverService = DriverService();
    final selectedDriver = appState.selectedDriver;

    if (selectedDriver != null){
      selectedDriversName = '${selectedDriver.name} - ${selectedDriver.plate}';
    }
    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.55,
      maxChildSize: .6,
      builder: (BuildContext context, myscrollController) {
        return StatefulBuilder(builder: (context, ss) {
          appState.mapController.animateCamera(CameraUpdate.zoomTo(14));
          return Container(
            decoration: BoxDecoration(
              color: white,
              boxShadow: [
                BoxShadow(
                  color: Colors.yellow.withOpacity(.8),
                  offset: const Offset(3, 2),
                  blurRadius: 7,
                )
              ],
            ),
            child: ListView(
              padding: EdgeInsets.zero,
              controller: myscrollController,
              children: [
                Container(
                  height: 110,
                  color: Colors.indigo,
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              appState.changeWidgetShowed(
                                showWidget: Show.driversListSelection,
                              );
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 1.5,
                            child: const Text(
                              "Payment Selection",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                      const Divider(
                        thickness: 3,
                        color: Colors.red,
                      ),
                      const Flexible(
                          child: Text(
                        "Please make a 50% prepayment of the total amount to ensure a successful booking and swift response.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                      ))
                    ],
                  ),
                ),
                const Divider(),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const Text(
                        'Payment Choices',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Selected Driver: ",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 5,),
                          Flexible(
                            child: Text(
                              selectedDriversName!,
                              style: const TextStyle(
                                  fontSize: 17,
                                  color: Colors.red,
                                fontWeight: FontWeight.bold,
                                
                              ),
                            ),
                          ),
                        ],
                      ),

                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: paymentOptions.length,
                        itemBuilder: (context, index) {
                          final option = paymentOptions[index];
                          return GestureDetector(
                            onTap: () async{
                              // TODO: Handle payment option selection
                              if (option['title'] == 'Pay Here') {
                                _customAlertDialog(
                                    context, AlertDialogType.success);
                              }else if(option['title'] == 'Pay Later' ){
                                _driverService.updateRequest({
                                  'driverId': selectedDriver!.id,
                                });
                                int selectedIndex = appState.getRideFares
                                    .indexWhere((element) =>
                                appState.selectedRideMode ==
                                    element.name
                                        .trim()
                                        .toLowerCase()
                                        .replaceAll(" ", "-"));

                                appState.requestDriver(
                                  //  paymentType: "cash",
                                    price: (appState.getRideFares[selectedIndex]
                                        .fixedRate +
                                        (appState.ridePrice *
                                            appState
                                                .getRideFares[selectedIndex]
                                                .farePerKm))
                                        .toInt(),
                                    type: appState.selectedRideMode!,
                                    distance:
                                    appState.routeModel!.distance.toJson(),
                                    user: userProvider.userModel!,
                                    pickupAddress:
                                    appState.pickupLocationString,
                                    lat: appState.pickupCoordinates!.latitude,
                                    lng: appState.pickupCoordinates!.longitude,
                                    driverId: selectedDriver.id,
                                    context: context);
                                appState.changeMainContext(context);
                                LoadingUtils.hideLoader();
                                //  }
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                20.0)), //this right here
                                        child: SizedBox(
                                          height: 250,
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                const SpinKitWave(
                                                  color: primaryColor,
                                                  size: 30,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                const Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  children: [
                                                    CustomText(
                                                        text:
                                                        "Looking for an Ambulance"),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 30,
                                                ),
                                                LinearPercentIndicator(
                                                  lineHeight: 4,
                                                  animation: true,
                                                  animationDuration: 100000,
                                                  percent: 1,
                                                  backgroundColor: Colors.grey
                                                      .withOpacity(0.2),
                                                  progressColor: primaryColor,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  children: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                          appState
                                                              .cancelRequest();
                                                          ScaffoldMessenger.of(
                                                              context)
                                                              .showSnackBar(
                                                              const SnackBar(
                                                                  content: Text(
                                                                      "Request cancelled!")));
                                                        },
                                                        child: const CustomText(
                                                          text:
                                                          "Cancel Request",
                                                          color: primaryColor,
                                                        )
                                                    ),
                                                  ],
                                                ),
                                                const Divider(thickness: 2, color: Colors.red,),
                                                const Row(
                                                   children: [
                                                     Icon(
                                                       Icons.info, // Specify the icon you want to display
                                                       color: Colors.red, // Set the color of the icon
                                                       size: 40, // Set the size of the icon
                                                     ),
                                                     Flexible(
                                                       child: Text(
                                                          " No prepayment may result in longer processing time and potential cancellation by the provider.",
                                                         textAlign: TextAlign.center,
                                                         style: TextStyle(
                                                           color: Colors.red
                                                         ),

                                                       ),
                                                     ),
                                                   ],
                                                 ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                              }

                            },
                            child: Card(
                              borderOnForeground: true,
                              shadowColor: Colors.blueAccent,
                              elevation: 3,
                              child: ListTile(
                                leading: Icon(
                                  option['icon'],
                                  size: 30,
                                  color: Colors.red,
                                ),
                                title: Text(
                                  option['title'],
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              appState.changeWidgetShowed(
                                showWidget: Show.paymentSelection,
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.red),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          TextButton(
                            onPressed: () {
                              // TODO: Handle skip button press
                              ScaffoldMessenger.of(
                                  context)
                                  .showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Colors.red,
                                      content: Text(
                                          "No prepayment may result in longer processing time and potential cancellation by the provider.",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white
                                        ),
                                      )));
                              _driverService.updateRequest({
                                'driverId': selectedDriver!.id,
                              });
                              int selectedIndex = appState.getRideFares
                                  .indexWhere((element) =>
                              appState.selectedRideMode ==
                                  element.name
                                      .trim()
                                      .toLowerCase()
                                      .replaceAll(" ", "-"));

                              appState.requestDriver(
                                //  paymentType: "cash",
                                  price: (appState.getRideFares[selectedIndex]
                                      .fixedRate +
                                      (appState.ridePrice *
                                          appState
                                              .getRideFares[selectedIndex]
                                              .farePerKm))
                                      .toInt(),
                                  type: appState.selectedRideMode!,
                                  distance:
                                  appState.routeModel!.distance.toJson(),
                                  user: userProvider.userModel!,
                                  pickupAddress:
                                  appState.pickupLocationString,
                                  lat: appState.pickupCoordinates!.latitude,
                                  lng: appState.pickupCoordinates!.longitude,
                                  driverId: selectedDriver.id,
                                  context: context);
                              appState.changeMainContext(context);
                              LoadingUtils.hideLoader();
                              //  }
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(

                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              20.0)), //this right here
                                      child: SizedBox(
                                        height: 200,
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              const SpinKitWave(
                                                color: primaryColor,
                                                size: 30,
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              const Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: [
                                                  CustomText(
                                                      text:
                                                      "Looking for an Ambulance"),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 30,
                                              ),
                                              LinearPercentIndicator(
                                                lineHeight: 4,
                                                animation: true,
                                                animationDuration: 100000,
                                                percent: 1,
                                                backgroundColor: Colors.grey
                                                    .withOpacity(0.2),
                                                progressColor: primaryColor,
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(
                                                            context);
                                                        appState
                                                            .cancelRequest();
                                                        ScaffoldMessenger.of(
                                                            context)
                                                            .showSnackBar(
                                                            const SnackBar(
                                                                content: Text(
                                                                    "Request cancelled!")));
                                                      },
                                                      child: const CustomText(
                                                        text:
                                                        "Cancel Request",
                                                        color: primaryColor,
                                                      )),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                            },
                            child: const Text(
                              'Skip',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }
}

enum AlertDialogType {
  success,
  error,
  warning,
  info,
}

class CustomAlertDialog extends StatelessWidget {
  final AlertDialogType type;
  final String title;
  final String content;
  final Widget? icon;
  final String buttonLabel;
  final TextStyle titleStyle = const TextStyle(
      fontSize: 20.0, color: Colors.black, fontWeight: FontWeight.bold);

  const CustomAlertDialog(
      {Key? key,
      this.title = "Successful",
      required this.content,
      this.icon,
      this.type = AlertDialogType.info,
      this.buttonLabel = "Ok"})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: Container(
          alignment: Alignment.center,
          child: Container(
            margin: const EdgeInsets.all(8.0),
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 10.0),
                icon ??
                    Icon(
                      _getIconForType(type),
                      color: _getColorForType(type),
                      size: 50,
                    ),
                const SizedBox(height: 10.0),
                Text(
                  title,
                  style: titleStyle,
                  textAlign: TextAlign.center,
                ),
                const Divider(thickness: 4,
                  color: Colors.red,
                ),
                Text(
                  content,
                  textAlign: TextAlign.center,
                ),
                // const SizedBox(height: 10.0),
                // Image.asset(
                //   'assets/transfer.jpg',
                //   height: 80,
                //   width: 80,
                // ),
                const SizedBox(height: 10.0),
                ListView(
                  shrinkWrap: true,
                  children: const [
                    ListTile(
                      leading: Icon(Icons.looks_one),
                      title: Text('Open Your CBE, or TeleBirr app'),
                    ),
                    ListTile(
                      leading: Icon(Icons.looks_two),
                      title: Text('Enter The Following Account Number'),
                    ),
                    ListTile(
                      leading: Icon(Icons.looks_3),
                      title: Text('Enter The Following Amount'),
                    ),
                    ListTile(
                      leading: Icon(Icons.looks_4),
                      title: Text('Provide The Payment Reference number'),
                    ),
                    ListTile(
                      leading: Icon(Icons.looks_5),
                      title: Text('Or Upload The Receipt'),
                    ),
                    // Add more list tiles as needed
                  ],
                ),
                const SizedBox(height: 10.0),
                const Divider(
                  thickness: 4,
                  color: Colors.red,
                ),
                const SizedBox(height: 5,),
                const Text(
                  'N.B: All payments will be refundable if you encounter issues from the provider'
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(5.0),
                      backgroundColor: Colors.red
                    ),
                    child: Text(buttonLabel),
                    onPressed: () => Navigator.pop(context, true),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  IconData _getIconForType(AlertDialogType type) {
    switch (type) {
      case AlertDialogType.warning:
        return Icons.warning;
      case AlertDialogType.success:
        return Icons.phonelink;
      case AlertDialogType.error:
        return Icons.error;
      case AlertDialogType.info:
      default:
        return Icons.info_outline;
    }
  }

  Color _getColorForType(AlertDialogType type) {
    switch (type) {
      case AlertDialogType.warning:
        return Colors.orange;
      case AlertDialogType.success:
        return Colors.green;
      case AlertDialogType.error:
        return Colors.red;
      case AlertDialogType.info:
      default:
        return Colors.blue;
    }
  }
}
