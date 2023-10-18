import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hearts/helpers/constant/constants.dart';

class RideRequestServices {
  String collection = "requests";

  String createRideRequest({
    required String userId,
    required String type,
    //   required String paymentType,
    required String username,
    required String pickupAddress,
    required num price,
    required Map<String, dynamic> destination,
    required Map<String, dynamic> position,
    required Map distance, required String driverId,

  }) {
    DocumentReference ref = firebaseFiretore.collection(collection).doc();
    ref.set({
      "username": username,
      "id": ref.id,
      "userId": userId,
      "driverId": driverId,
      "type": type,
      "price": price,
      "pickupAddress": pickupAddress,
      "position": position,
      "status": 'pending',
      "destination": destination,
      "distance": distance,
      "rejectedDrivers": [],
      "createdAt": DateTime.now()
    });
    return ref.id;
  }

  void updateRequest(Map<String, dynamic> values) {
    firebaseFiretore.collection(collection).doc(values['id']).update(values);
  }

  Stream<QuerySnapshot> requestStream() {
    CollectionReference reference =
        FirebaseFirestore.instance.collection(collection);
    return reference.snapshots();
  }
}
