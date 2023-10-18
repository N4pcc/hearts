import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/carousel.dart';

class FirestoreService {
  final CollectionReference _bannersCollection =
  FirebaseFirestore.instance.collection('banners');

  Stream<List<Banner>> getBanners() {
    return _bannersCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        var bannerData = doc.data();
        return Banner(
          imageUrl: ((bannerData)as Map)['image'],
          description: bannerData['title'],
        );
      }).toList();
    });
  }
}