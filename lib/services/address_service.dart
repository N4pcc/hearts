//""
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/address_model.dart';

class AddressService {
  final CollectionReference _ref = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("address");

  Future<Map<String, dynamic>> addAddressService(
      {required Address address}) async {
    var addressJson = address.toJson();
    final docRef = _ref.doc();

    addressJson["id"] = docRef.id;
    await docRef.set(addressJson);

    return addressJson;
  }

  Future removeAddressService({required String id}) async {
    await _ref.doc(id).delete();
  }

  Future updateAddressService({required Address address}) async {
    await _ref.doc(address.id).set(address.toJson());
  }
}
