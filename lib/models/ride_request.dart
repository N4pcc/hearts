import 'package:cloud_firestore/cloud_firestore.dart';

class RideRequestModel {
  static const idConst = "id";
  static const usernameConst = "username";
  static const userIdConst = "userId";
  static const driverIdConst = "driverId";
  static const statusConst = "status";
  static const positionConst = "position";
  static const destinationConst = "destination";

  // String _id;
  // String _username;
  // String _userId;
  // String _driverId;
  // String _status;
  // Map _position;
  // Map _destination;

  final String id;
  final String username;
  final String userId;
  final String driverId;
  final String status;
  final Map position;
  final Map destination;
  final num price;
  final String pickupAddress;
  RideRequestModel(
      {required this.id,
      required this.username,
      required this.userId,
      required this.driverId,
      required this.price,
      required this.pickupAddress,
      required this.status,
      required this.position,
      required this.destination});
  static RideRequestModel fromSnapshot(DocumentSnapshot snapshot) {
    Map data = snapshot.data() as Map;
    return RideRequestModel(
        id: data[idConst],
        username: data[usernameConst],
        userId: data[userIdConst],
        price: data["price"],
        pickupAddress: data["pickupAddress"],
        driverId: data[driverIdConst],
        status: data[statusConst],
        position: data[positionConst],
        destination: data[destinationConst]);
  }
}
