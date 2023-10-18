import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hearts/models/ambulanceProvider.dart';



class AmbulanceProviderService {
  Future<List<AP>> fetchRideFare() async {
    List<AP> rideFares = [];
    QuerySnapshot snaps = await FirebaseFirestore.instance
        .collection("AP")
        .where("isActive", isEqualTo: true)
        .get();
    for (var element in snaps.docs) {
      rideFares.add(AP.fromJson(element.data() as Map<String, dynamic>));
      print(element.data());
    }
    return rideFares;
  }
}
