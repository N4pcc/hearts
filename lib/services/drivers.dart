import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hearts/helpers/constant/constants.dart';
import 'package:hearts/models/driver.dart';

class DriverService {
  String collection = 'drivers';

  Stream<List<DriverModel>> getDrivers() {
    return firebaseFiretore
        .collection(collection)
        .where("online", isEqualTo: true)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => DriverModel.fromSnapshot(e)).toList());
  }

  Future<DriverModel> getDriverById(String id) =>
      firebaseFiretore.collection(collection).doc(id).get().then((doc) {
        return DriverModel.fromSnapshot(doc);
      });

  void updateRequest(Map<String, dynamic> values) {
    firebaseFiretore.collection(collection).doc(values['id']).update(values);
  }

  Stream<QuerySnapshot> driverStream() {
    CollectionReference reference =
        FirebaseFirestore.instance.collection(collection);
    return reference.snapshots();
  }
}
