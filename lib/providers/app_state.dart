import 'dart:async';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:hearts/models/ambulanceProvider.dart';
import 'package:hearts/services/ambulanceproviderservice.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hearts/helpers/constant/constants.dart';
import 'package:hearts/helpers/style.dart';
import 'package:hearts/models/driver.dart';
import 'package:hearts/models/ride_fare.dart';
import 'package:hearts/models/ride_request.dart';
import 'package:hearts/models/route.dart';
import 'package:hearts/models/user.dart';
import 'package:hearts/services/drivers.dart';
import 'package:hearts/services/map_requests.dart';
import 'package:hearts/services/ride_fare_service.dart';
import 'package:hearts/services/ride_requests.dart';
import 'package:hearts/widgets/custom_btn.dart';
import 'package:hearts/widgets/custom_text.dart';
import 'package:uuid/uuid.dart';
import '../helpers/custom_dialog.dart';
import '../services/history_service.dart';
import '../widgets/hearts_button.dart';
import '../widgets/hearts_text.dart';

// * THIS ENUM WILL CONTAIN THE DRAGGABLE WIDGET TO BE DISPLAYED ON THE MAIN SCREEN
enum Show {
  destinationSelection,
  pickupSelection,
  paymentSelection,
  paymentScreen,
  driverSelection,
  driversListSelection,
  trip,
  addReview
}

class AppStateProvider with ChangeNotifier {
  static const accepted = 'accepted';
  static const cancelled = 'cancelled';
  static const pending = 'pending';
  static const expired = 'expired';
  static const arrived = 'arrived';
  static const started = 'started';
  static const completed = 'completed';
  static const pickupMarkerId = 'pickup';
  static const locationMarkerId = 'location';

  SharedPreferences? prefs;
  final Set<Marker> _markers = {};

  //  this polys will be displayed on the map
  final Set<Polyline> _poly = {};

  // this polys temporarily store the polys to destination

  // this polys temporarily store the polys to driver

  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static Reference storage = FirebaseStorage.instance.ref();


  final GoogleMapsServices _googleMapsServices = GoogleMapsServices();
  late GoogleMapController _mapController;

  //Geoflutterfire geo = Geoflutterfire();
  static LatLng? _center;
  LatLng? _lastPosition = _center;
  String pickupLocationString = "";
  String destinationLocationString = "";

  late Position position;
  final DriverService _driverService = DriverService();

  //  draggable to show
  Show show = Show.destinationSelection;
  List<RideFare> rideFares = [];
  List<RideFare> get getRideFares => rideFares;
  //
  List<AP> ambulanceProviderFares = [];
  List<AP> get getAmbulanceProviderFares => ambulanceProviderFares;

  //   taxi pin
  // late BitmapDescriptor carPin;
  // late BitmapDescriptor bikePin;

  //   location pin
  late BitmapDescriptor locationPin;
  late BitmapDescriptor pickup;
  late BitmapDescriptor dropoff;

  LatLng? get center => _center;

  LatLng? get lastPosition => _lastPosition;

  Set<Marker> get markers => _markers;

  Set<Polyline> get poly => _poly;

  GoogleMapController get mapController => _mapController;
  RouteModel? routeModel;

  //  Driver request related variables
  bool lookingForDriver = false;
  bool alertsOnUi = false;
  bool driverFound = false;
  bool driverArrived = false;
  final RideRequestServices _requestServices = RideRequestServices();
  int timeCounter = 0;
  int rideDistance = 0;
  int rideTotaTime = 0;

  double percentage = 0;
  Timer? periodicTimer;
  late String requestedDestination;

  String requestStatus = "";
  late double requestedDestinationLat;

  late double requestedDestinationLng;
  RideRequestModel? rideRequestModel;
  late BuildContext mainContext;

//  this variable will listen to the status of the ride request
  StreamSubscription<QuerySnapshot>? requestStream;

  // this variable will keep track of the drivers position before and during the ride
  StreamSubscription<QuerySnapshot>? driverStream;

//  this stream is for all the driver on the app
  late StreamSubscription<List<DriverModel>> allDriversStream;

  DriverModel? driverModel;
  LatLng? pickupCoordinates;
  LatLng? destinationCoordinates;
  double ridePrice = 0;
  String? selectedRideMode;
  DriverModel? selectedDriver;
  String notificationType = "";
  Map<String, BitmapDescriptor> ridePins = {};

  AppStateProvider() {
    _saveDeviceToken();

    _getUserLocation();
    _listemToDrivers();
    Geolocator.getPositionStream().listen(_updatePosition);
  }

// ANCHOR: MAPS & LOCATION METHODS
  _updatePosition(Position newPosition) {
    position = newPosition;
    notifyListeners();
  }

  Future<Position> _getUserLocation() async {
    prefs = await SharedPreferences.getInstance();
    position = await Geolocator.getCurrentPosition();
    List<Placemark> placemark =
    await placemarkFromCoordinates(position.latitude, position.longitude);

    if (prefs!.getString(countryPref) == null) {
      String countryPref = placemark[0].country!.toLowerCase();
      await prefs!.setString(countryPref, countryPref);
    }

    _center = LatLng(position.latitude, position.longitude);
    notifyListeners();
    return position;
  }

  onCreate(GoogleMapController controller) {
    _mapController = controller;
    notifyListeners();
  }

  setLastPosition(LatLng position) {
    _lastPosition = position;
    notifyListeners();
  }

  updateSelectedRideMode(String mode) {
    selectedRideMode = mode;

    notifyListeners();
  }
 updateSelectedDriver(DriverModel driver) {
    selectedDriver = driver;
    notifyListeners();
  }

  onCameraMove(CameraPosition position) {
    if (show == Show.pickupSelection) {
      _lastPosition = position.target;
      changePickupLocationAddress(address: "Loading...");

      _markers.removeWhere((element) => element.markerId.value == pickupMarkerId);
      pickupCoordinates = position.target;
      addPickupMarker(position.target);

      notifyListeners();
    }
  }
  // onCameraMove(CameraPosition position) {
  //   //  MOVE the pickup marker only when selecting the pickup location
  //   if (show == Show.pickupSelection) {
  //     _lastPosition = position.target;
  //     changePickupLocationAddress(address: "Loading...");
  //     if (_markers.isNotEmpty) {
  //       for (var element in _markers) {
  //         if (element.markerId.value == pickupMarkerId) {
  //           _markers.remove(element);
  //           pickupCoordinates = position.target;
  //           addPickupMarker(position.target);
  //           // List<Placemark> placemark = await placemarkFromCoordinates(
  //           //     position.target.latitude, position.target.longitude);
  //           // print(placemark.join());
  //           // pickupLocationString =
  //           //     "${placemark[0].name}, ${placemark[0].subLocality}, ${placemark[0].subAdministrativeArea}, ${placemark[0].administrativeArea}";
  //           notifyListeners();
  //         }
  //       }
  //     }
  //     notifyListeners();
  //   }
  // }


  onCameraIdle() async {
    if (show == Show.pickupSelection) {
      List<Placemark> placemark = await placemarkFromCoordinates(
          pickupCoordinates!.latitude, pickupCoordinates!.longitude);

      pickupLocationString =
      "${placemark[0].name}, ${placemark[0].subLocality}, ${placemark[0]
          .subAdministrativeArea}, ${placemark[0].administrativeArea}";
    }
    notifyListeners();
  }

  Future sendRequest({LatLng? origin, LatLng? destination}) async {
    LatLng org;
    LatLng dest;

    if (origin == null && destination == null) {
      org = pickupCoordinates!;
      dest = destinationCoordinates!;
    } else {
      org = origin!;
      dest = destination!;
    }

    RouteModel route =
    await _googleMapsServices.getRouteByCoordinates(org, dest);
    routeModel = route;

    if (origin == null) {
      rideDistance = routeModel!.distance.value;
      rideTotaTime = routeModel!.timeNeeded.value;

      ridePrice =
          double.parse((routeModel!.distance.value / 500).toStringAsFixed(2));
    }
    List<Marker> mks = _markers
        .where((element) => element.markerId.value == "location")
        .toList();
    if (mks.isNotEmpty) {
      _markers.remove(mks[0]);
    }
// ! another method will be created just to draw the polys and add markers
    _addLocationMarker(destinationCoordinates!, routeModel!.distance.text);
    _center = destinationCoordinates;

    _createRoute(
      route.points,
    );

    notifyListeners();
  }

  // setRideDetails(double  amt) {
  //   ridePrice = ridePrice * amt;
  //   rideTotaTime = rideTotaTime * amt~/10;
  //   notifyListeners();
  // }

  void updateDestination(
      {required String destination, required LatLng destinationLatLng}) {
    destinationLocationString = destination;
    _mapController.animateCamera(CameraUpdate.zoomTo(18));
    notifyListeners();
  }

  _createRoute(String decodeRoute) {
    clearPoly();
    var uuid = const Uuid();
    String polyId = uuid.v1();
    _poly.add(Polyline(
        polylineId: PolylineId(polyId),
        width: 5,
        color: Colors.red,
        onTap: () {},
        points: _convertToLatLong(_decodePoly(decodeRoute))));
    notifyListeners();
  }

  List<LatLng> _convertToLatLong(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = [];
    int index = 0;
    int len = poly.length;
    int c = 0;
// repeating until all attributes are decoded
    do {
      var shift = 0;
      int result = 0;

      // for decoding value of one attribute
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      /* if value is negetive then bitwise not the value */
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

/*adding to previous value as done in encoding */
    for (var i = 2; i < lList.length; i++) {
      lList[i] += lList[i - 2];
    }

    return lList;
  }

// ANCHOR: MARKERS AND POLYS
  _addLocationMarker(LatLng position, String distance) {
    _markers.add(Marker(
        markerId: const MarkerId(locationMarkerId),
        position: position,
        anchor: const Offset(0.5, 0.7),
        infoWindow:
        InfoWindow(title: destinationLocationString, snippet: distance),
        icon: dropoff));
    notifyListeners();
  }

  addPickupMarker(LatLng position) {
    pickupCoordinates ??= position;
    _markers.add(Marker(
        markerId: const MarkerId(pickupMarkerId),
        position: position,
        anchor: const Offset(0.5, 0.5),
        zIndex: 3,
        infoWindow: const InfoWindow(title: "Pickup", snippet: "location"),
        icon: pickup));
    notifyListeners();
  }

  void _addDriverMarker({required LatLng position,
    required double rotation,
    required String type,
    required String driverId,
  }) {
    var uuid = const Uuid();
    String markerId = uuid.v1();
    _markers.add(Marker(
        markerId: MarkerId(markerId),
        position: position,
        rotation: 360,
        draggable: false,
        zIndex: 3,
        flat: true,
        anchor: const Offset(2, 2),
        icon: ridePins[type]!));
  }

  _updateMarkers(List<DriverModel> drivers) {
//    this code will ensure that when the driver markers are updated the location marker wont be deleted
    List<Marker> locationMarkers = _markers
        .where((element) => element.markerId.value == 'location')
        .toList();
    clearMarkers();
    if (locationMarkers.isNotEmpty) {
      _markers.add(locationMarkers[0]);
    }

//    here we are updating the drivers markers
    for (var driver in drivers) {
      _addDriverMarker(
          type: driver.type,
          driverId: driver.id,
          position: LatLng(driver.position.lat, driver.position.lng),
          rotation: driver.position.heading);
    }
  }

  Future _setCustomMapPin() async {
    rideFares = await RideFareService().fetchRideFare();
    ambulanceProviderFares = await AmbulanceProviderService().fetchRideFare();

    for (var element in rideFares) {
      http.Response response = await http.get(Uri.parse(element.image));

      ui.Codec codec =
      await ui.instantiateImageCodec(response.bodyBytes, targetHeight: 200);
      ui.FrameInfo fi = await codec.getNextFrame();
      ridePins[element.name.trim().toLowerCase().replaceAll(" ", "-")] =
          BitmapDescriptor.fromBytes(
              (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
                  .buffer
                  .asUint8List(),
              size: const Size(60, 50));
    }
    pickup = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(20, 30)), 'assets/pickup.png');
    dropoff = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(20, 30)), 'assets/dropoff.png');
    locationPin = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(20, 30)), 'assets/pin.png');
    notifyListeners();
  }

  clearMarkers() {
    _markers.clear();
    notifyListeners();
  }

  clearPinMarkers() {
    _markers.removeWhere((element) => element.markerId.value == pickupMarkerId);
    notifyListeners();
  }

  // _clearDriverMarkers() {
  //   _markers.forEach((element) {
  //     String markerId = element.markerId.value;
  //     if (markerId != driverModel.id ||
  //         markerId != locationMarkerId ||
  //         markerId != pickupMarkerId) {
  //       _markers.remove(element);
  //       notifyListeners();
  //     }
  //   });
  // }

  clearPoly() {
    _poly.clear();
    notifyListeners();
  }

// ANCHOR UI METHODS
  changeMainContext(BuildContext context) {
    mainContext = context;
    notifyListeners();
  }

  changeWidgetShowed({required Show showWidget}) {
    // prefs!.setString(showPref, showWidget.name);
    show = showWidget;
    notifyListeners();
  }

  showRequestCancelledSnackBar(BuildContext context) {}

  showRequestExpiredAlert(BuildContext context) {
    if (alertsOnUi) Navigator.pop(context);

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: const SizedBox(
              height: 200,
              child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                          text: "AMBULANCE NOT FOUND! \n TRY REQUESTING AGAIN")
                    ],
                  )),
            ),
          );
        });
  }

  showDriverBottomSheet(BuildContext context) {
    if (alertsOnUi) Navigator.pop(context);

    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SizedBox(
              height: 400,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: "7 MIN AWAY",
                        color: green,
                        weight: FontWeight.bold,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Visibility(
                        visible: driverModel?.photo == null,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(40)),
                          child: const CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 45,
                            child: Icon(
                              Icons.person,
                              size: 65,
                              color: white,
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: driverModel?.photo != null,
                        child: Container(
                          decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(40)),
                          child: CircleAvatar(
                            radius: 45,
                            backgroundImage: NetworkImage(driverModel!.photo),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(text: driverModel?.name ?? ""),
                    ],
                  ),
                  // const SizedBox(height: 10),
                  // _stars(
                  //     rating: driverModel?.rating.reduce((a, b) => a + b) /
                  //         driverModel?.rating.length,
                  //     votes: driverModel?.votes),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton.icon(
                          onPressed: null,
                          icon: const Icon(Icons.directions_car),
                          label: Text(driverModel?.car ?? "")),
                      CustomText(
                        text: driverModel?.plate ?? "",
                        color: primaryColor,
                      )
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomBtn(
                        text: "Call",
                        onTap: () {},
                        bgColor: green,
                        shadowColor: Colors.green,
                      ),
                      CustomBtn(
                        text: "Cancel",
                        onTap: () {},
                        bgColor: red,
                        shadowColor: Colors.redAccent,
                      ),
                    ],
                  )
                ],
              ));
        });
  }

  // _stars({required int votes, required double rating}) {
  //   if (votes == 0) {
  //     return const StarsWidget(
  //       numberOfStars: 0,
  //     );
  //   } else {
  //     double finalRate = rating / votes;
  //     return StarsWidget(
  //       numberOfStars: finalRate.floor(),
  //     );
  //   }
  // }

  // ANCHOR RIDE REQUEST METHODS
  _saveDeviceToken() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs!.getString('token') == null) {
      String deviceToken = await fcm.getToken() ?? "";
      await prefs!.setString('token', deviceToken);
    }
  }

  changeRequestedDestination({required String reqDestination,
    required double lat,
    required double lng}) {
    requestedDestination = reqDestination;
    requestedDestinationLat = lat;
    requestedDestinationLng = lng;
    notifyListeners();
  }

  listenToRequest({required String id, required BuildContext context}) async {
    requestStream =
        _requestServices.requestStream().listen((querySnapshot) async {
          for (var doc in querySnapshot.docs) {
            if ((doc.data() as Map)['id'] == id) {
              rideRequestModel = RideRequestModel.fromSnapshot(doc);
              prefs!.setString(requestIdPref, (doc.data() as Map)['id']);

              destinationCoordinates = LatLng(
                  (doc.data() as Map)['destination']["latitude"],
                  (doc.data() as Map)['destination']["longitude"]);
              pickupCoordinates = LatLng(
                  (doc.data() as Map)['position']["latitude"],
                  (doc.data() as Map)['position']["longitude"]);
              notifyListeners();
              switch ((doc.data() as Map)['status']) {
                case cancelled:
                  await cancelRequest().whenComplete(() =>
                      showCustomDialog(
                          navigatorKey.currentContext!,
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
                                  "This booking has been cancelled.",
                                  color: black,
                                  align: TextAlign.center,
                                ),
                                HeartsButton(
                                    height: 40,
                                    width: 180,
                                    text: "Back to Home",
                                    func: () async {
                                      prefs!.remove(driverIdPref);
                                      prefs!.remove(requestIdPref);
                                      requestStream?.cancel();
                                      driverStream?.cancel();
                                      Navigator.of(navigatorKey.currentContext!)
                                          .pop();
                                    },
                                    isLoading: false)
                              ],
                            ),
                          )));
                  break;
                case accepted:
                case arrived:
                  if (lookingForDriver) Navigator.pop(context);
                  lookingForDriver = false;
                  driverModel = await _driverService
                      .getDriverById((doc.data() as Map)['driverId']);
                  prefs!.setString(
                      driverIdPref, (doc.data() as Map)['driverId']);
                  periodicTimer?.cancel();
                  clearPoly();
                  _stopListeningToDriversStream();
                  listenToDriver(id);
                  changeWidgetShowed(showWidget: Show.driverSelection);
                  notifyListeners();
                  break;
                case started:
                  changeWidgetShowed(showWidget: Show.trip);
                  _stopListeningToDriversStream();
                  driverModel = await _driverService
                      .getDriverById((doc.data() as Map)['driverId']);
                  prefs!.setString(
                      driverIdPref, (doc.data() as Map)['driverId']);
                  startRideStream((doc.data() as Map)['driverId']);
                  notifyListeners();
                  break;
                case expired:
                  prefs!.remove(requestIdPref);
                  showRequestExpiredAlert(context);
                  break;
                case completed:
                  clearPoly();
                  clearPinMarkers();
                  changeWidgetShowed(showWidget: Show.addReview);
                  prefs!.remove(driverIdPref);
                  prefs!.remove(requestIdPref);

                  driverStream?.cancel();
                  periodicTimer?.cancel();
                  await requestStream?.cancel();
                  break;
                default:
                  break;
              }
            }
          }
        });
  }

  requestDriver({required UserModel user,
    required double lat,
    required double lng,
    required String type,
    // required String paymentType,
    required num price,
    required String pickupAddress,
    required BuildContext context,
    required Map distance,
    required String? driverId, // Add the driverId parameter here
  }) {
    alertsOnUi = true;
    notifyListeners();

    String id = _requestServices.createRideRequest(
        userId: user.id,
        username: user.name,
        distance: distance,
        type: type,
        price: price,
        //   paymentType: paymentType,
        pickupAddress: pickupAddress,
        destination: {
          "address": requestedDestination,
          "latitude": requestedDestinationLat,
          "longitude": requestedDestinationLng
        },
        position: {
          "latitude": lat,
          "longitude": lng
        },
        driverId:selectedDriver!.id,
        );
    prefs!.setString(requestIdPref, id);
    listenToRequest(id: id, context: context);
    percentageCounter(requestId: id, context: context);
  }

  Future cancelRequest() async {
    lookingForDriver = false;
    clearPoly();

    changeWidgetShowed(showWidget: Show.destinationSelection);
    _requestServices
        .updateRequest({"id": rideRequestModel!.id, "status": "rejected"});

    notifyListeners();
  }

  Future completeRequest(String paymentType, double? rating) async {
    // Map<String, dynamic> updateValues = {
    //   "id": driverModel!.id,
    //   "trips": {
    //     "userId": rideRequestModel!.userId,
    //     "rideId": rideRequestModel!.id,
    //     "driverId": rideRequestModel!.driverId,
    //     "time": DateTime.now(),
    //     "amount": rideRequestModel!.price.toStringAsFixed(2),
    //   },
    // };

    HistoryService.createRideHistory(
      paymentType: paymentType,
      address:
      "${rideRequestModel!.pickupAddress.split(",")[0]}, ${rideRequestModel!
          .pickupAddress.split(",")[1]} - ${rideRequestModel!
          .destination["address"].split(",")[0]}, ${rideRequestModel!
          .destination["address"].split(",")[1]}",
      userId: rideRequestModel!.userId,
      rideId: rideRequestModel!.id,
      driverId: rideRequestModel!.driverId,
      time: DateTime.now().toIso8601String(),
      rating: rating,
      amount: double.parse(rideRequestModel!.price.toStringAsFixed(2)),
    );
    prefs!.remove(driverIdPref);
    prefs!.remove(requestIdPref);
    requestStream?.cancel();
    driverStream?.cancel();
    clearPoly();
    changeWidgetShowed(showWidget: Show.destinationSelection);
    // periodicTimer.cancel();
    // _requestServices.updateRequest({"id": requestId, "status": "completed"});
    notifyListeners();
  }

// ANCHOR LISTEN TO DRIVER
  _listemToDrivers() async {
    await _setCustomMapPin().then((value) =>
    allDriversStream = _driverService.getDrivers().listen(_updateMarkers));
  }

  startRideStream(String id) async {
    periodicTimer?.cancel();
    driverStream?.cancel();
    driverStream = _driverService.driverStream().listen((event) async {
      for (var doc in event.docChanges) {
        if ((doc.doc.data() as Map)['id'] == id) {
          clearMarkers();
          driverModel = DriverModel.fromSnapshot(doc.doc);
          _addDriverMarker(
              type: driverModel!.type,
              position: driverModel!.getPosition(),
              rotation: driverModel!.position.heading,
              driverId: driverModel!.id);
          var org = driverModel!.getPosition();
          _mapController.animateCamera(
              CameraUpdate.newLatLng(driverModel!.getPosition()));

          RouteModel route = await _googleMapsServices.getRouteByCoordinates(
              org, destinationCoordinates!);
          routeModel = route;
          _addLocationMarker(
              destinationCoordinates!, routeModel!.distance.text);
          _center = destinationCoordinates!;

          _createRoute(
            route.points,
          );
          notifyListeners();
        }
      }
    });
    notifyListeners();
  }

  listenToDriver(String? requestId) {
    periodicTimer?.cancel();
    driverStream = _driverService.driverStream().listen((event) async {
      for (var doc in event.docChanges) {
        if ((doc.doc.data() as Map)['id'] == driverModel!.id) {
          driverModel = DriverModel.fromSnapshot(doc.doc);
          // code to update marker
          // List<Marker> _m = _markers
          //     .where((element) => element.markerId.value == driverModel!.id)
          //     .toList();
          // _markers.remove(_m[0]);
          //  clearMarkers();
          await sendRequest(
              origin: LatLng((doc.doc.data() as Map)['position']["latitude"],
                  (doc.doc.data() as Map)['position']["longitude"]),
              destination: pickupCoordinates);

          if (routeModel!.distance.value <= 40 &&
              routeModel!.distance.value > 0) {
            driverArrived = true;

            if (requestId != null) {
              _requestServices
                  .updateRequest({"id": requestId, "status": "arrived"});
              driverStream?.cancel();
            }
          }
          notifyListeners();
          clearMarkers();
          _addDriverMarker(
              type: driverModel!.type,
              position: driverModel!.getPosition(),
              rotation: driverModel!.position.heading,
              driverId: driverModel!.id);

          addPickupMarker(pickupCoordinates!);

          // _updateDriverMarker(_m[0]);
        }
      }
    });

    changeWidgetShowed(showWidget: Show.driverSelection);
    notifyListeners();
  }

  _stopListeningToDriversStream() {
//    _clearDriverMarkers();
    allDriversStream.cancel();
  }

//  Timer counter for driver request
  percentageCounter(
      {required String requestId, required BuildContext context}) {
    lookingForDriver = true;
    notifyListeners();
    periodicTimer = Timer.periodic(const Duration(seconds: 1), (time) {
      timeCounter = timeCounter + 1;
      percentage = timeCounter / 100;

      if (timeCounter == 150) {
        timeCounter = 0;
        percentage = 0;
        lookingForDriver = false;
        _requestServices.updateRequest({"id": requestId, "status": "expired"});
        time.cancel();
        if (alertsOnUi) {
          Navigator.pop(context);
          alertsOnUi = false;
          notifyListeners();
        }
        requestStream?.cancel();
      }
      notifyListeners();
    });
  }

  setPickCoordinates({required LatLng coordinates}) {
    pickupCoordinates = coordinates;
    mapController.animateCamera(CameraUpdate.newLatLngZoom(coordinates, 18));
    notifyListeners();
  }

  setDestination({required LatLng coordinates}) {
    destinationCoordinates = coordinates;
    notifyListeners();
  }

  changePickupLocationAddress({required String address}) {
    pickupLocationString = address;
    if (pickupCoordinates != null) {
      _center = pickupCoordinates;
    }
    notifyListeners();
  }

}
