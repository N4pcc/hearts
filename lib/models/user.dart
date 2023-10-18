import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'address_model.dart';

class UserModel {
  static const idConst = "id";
  static const nameConst = "name";
  static const emailConst = "email";
  static const phoneConst = "phone";
  static const votesConst = "votes";
  static const tripsConst = "trips";
  static const ratingConst = "rating";
  static const tokenConst = "token";
  static const addressListConst = "addressList";

  final String name;
  final String email;
  final String id;
  final String token;

  final String phone;
  final int votes;
  final int trips;
  final double rating;
  final List<Address> addressList;

  UserModel({
    required this.name,
    required this.email,
    required this.id,
    required this.token,
    required this.phone,
    required this.addressList,
    required this.votes,
    required this.trips,
    required this.rating,
  });

  static Future<UserModel> fromSnapshot(DocumentSnapshot snapshot) async {
    Map data = snapshot.data() as Map;
    List<Address> addressList = [];
    QuerySnapshot addressSnaps = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("address")
        .get();
    for (var e in addressSnaps.docs) {
      addressList.add(Address.fromSnap(e.data() as Map<String, dynamic>));
    }
    return UserModel(
        name: data[nameConst],
        addressList: addressList,
        email: data[emailConst],
        id: data[idConst],
        token: data[tokenConst] ?? "",
        phone: data[phoneConst],
        votes: data[votesConst],
        trips: data[tripsConst],
        rating: data[ratingConst]);
  }
}
