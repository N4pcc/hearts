import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hearts/helpers/constant/constants.dart';

class HistoryService {
  static String collection = "history";

  static String createRideHistory({
    required String userId,
    required String paymentType,
    required String rideId,
    required String driverId,
    required String time,
    required String address,
    required double? rating,
    required double amount,
  }) {
    DocumentReference ref = firebaseFiretore.collection(collection).doc();
    ref.set({
      "userId": userId,
      "id": ref.id,
      "rideId": rideId,
      "driverId": driverId,
      "time": time,
      "paymentType": paymentType,
      "address": address,
      "rating": rating,
      "amount": amount,
    });
    return ref.id;
  }

  static Future<List> fetchUserHistory(String id) async {
    List rideHistory = [];
    QuerySnapshot historySnap = await firebaseFiretore
        .collection(collection)
        .where("userId", isEqualTo: id)
        .get();
    for (var element in historySnap.docs) {
      rideHistory.add(element);
    }
    return rideHistory;
  }
}
