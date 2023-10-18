import 'package:get/get.dart';

import '../models/carousel.dart';
import '../services/banner_service.dart';

class SliderController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();
  final banners = <Banner>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchBanners();
  }

  void fetchBanners() async {
    void fetchBanners() {
      _firestoreService.getBanners().listen((bannerList) {
        banners.value = bannerList;
      }, onError: (e) {
       // debugPrint(e.toString());
      });
    }
  }
}