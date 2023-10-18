import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../helpers/style.dart';
import '../providers/app_state.dart';

// import '../providers/user.dart';
import '../models/driver.dart';
import '../services/drivers.dart';

// import 'custom_text.dart';
import 'hearts_button.dart';
import 'hearts_text.dart';

class DriversList extends StatefulWidget {
  const DriversList({Key? key}) : super(key: key);

  @override
  State<DriversList> createState() => _DriversListState();
}

class _DriversListState extends State<DriversList> {
  final DriverService _driverService = DriverService();

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateProvider>(context);
    // final userProvider = Provider.of<UserProvider>(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.44,
      minChildSize: 0.44,
      maxChildSize: .6,
      builder: (BuildContext context, myscrollController) {
        return StatefulBuilder(builder: (context, ss) {
          appState.mapController
              .animateCamera(CameraUpdate.zoomTo(14));
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
                  color: Colors.indigo,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          appState.changeWidgetShowed(
                            showWidget: Show.paymentSelection,
                          );
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: const CabText(
                          "Select Online Driver",
                          size: 16,
                          color: white,
                          align: TextAlign.center,
                          weight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 40),
                    ],
                  ),
                ),
                const Divider(),
                StreamBuilder<List<DriverModel>>(
                  stream: _driverService.getDrivers(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<DriverModel> drivers = snapshot.data!;

                      // Create a copy of the drivers list
                      List<DriverModel> filteredDrivers =
                      List<DriverModel>.from(drivers);

                      // Filter drivers based on selected ambulance type
                      filteredDrivers = drivers
                          .where((driver) => driver.type.toLowerCase().trim() == appState.selectedRideMode?.toLowerCase().trim())
                          .toList();
                      int selectedIndex = appState.getRideFares.indexWhere(
                              (element) =>
                          appState.selectedRideMode ==
                              element.name
                                  .trim()
                                  .toLowerCase()
                                  .replaceAll(" ", "-"));

                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: filteredDrivers.length,
                        itemBuilder: (ctx, i) => Card(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          elevation: 0,
                          child: ListTile(
                            tileColor: Colors.white,
                            onTap: () {
                              appState.changeWidgetShowed(
                                showWidget: Show.paymentScreen,
                              );
                              appState.updateSelectedDriver(filteredDrivers[i]);
                            },
                            title: CabText(filteredDrivers[i].name),
                            subtitle: CabText(
                              "${filteredDrivers[i].car}  ${(appState.getRideFares[selectedIndex].fixedRate + (appState.ridePrice * appState.getRideFares[selectedIndex].farePerKm)).toInt().toInt()}.0",
                              size: 13,
                            ),
                            trailing: const CabText(
                              "Online",
                              color: Colors.green,
                            ),
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundImage: NetworkImage(filteredDrivers[i].photo),
                            ),
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: CabText('Error loading drivers'),
                      );
                    } else {
                      return const Center(
                        child: SpinKitFadingCircle(
                          color: Colors.indigo,
                          size: 50,
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: HeartsButton(
                    isLoading: false,
                    text: 'Cancel',
                    color: Colors.red,
                    func: () {
                      appState.changeWidgetShowed(
                          showWidget: Show.paymentSelection);
                    },
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
