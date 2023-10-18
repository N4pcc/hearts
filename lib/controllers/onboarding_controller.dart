import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hearts/widgets/onboarding_widget.dart';
import 'package:liquid_swipe/PageHelpers/LiquidController.dart';

import '../helpers/constant/colors.dart';
import '../helpers/constant/images.dart';
import '../helpers/constant/text.dart';
import '../models/onboarding_model.dart';



class OnBoardingController extends GetxController{

  final controller = LiquidController();
  RxInt currentPage = 0.obs;


  final pages = [
    OnBoardingPageWidget(
      model: OnBoardingModel(
        image: onBoardingImage1,
        title: onboardingText1,
        subTitle: onboardingsubtitle1,
        bgColor: onboardingpage1Color,
        counterText: onboardingcounter1
        ,
      ),
    ),
    OnBoardingPageWidget(
      model: OnBoardingModel(
        image: onBoardingImage2,
        title: onboardingText2,
        subTitle: onboardingsubtitle2,
        counterText: onboardingcounter2,
        bgColor: onboardingpage2Color,
      ),
    ),
    OnBoardingPageWidget(
      model: OnBoardingModel(
        image: onBoardingImage3,
        title: onboardingText3,
        subTitle: onboardingsubtitle3,
        counterText: onboardingcounter3,
        bgColor: onboardingpage3Color,
      ),
    ),
    OnBoardingPageWidget(
      model: OnBoardingModel(
        image: onBoardingImage4,
        title: onboardingText4,
        subTitle: onboardingsubtitle4,
        bgColor: onboardingpage4Color,
        counterText: onboardingcounter4
        ,
      ),
    ),

  ];


  skip() => controller.jumpToPage(page: 2);
  animateToNextSlide() {
    int nextPage = controller.currentPage + 1;
    controller.animateToPage(page: nextPage);
  }
  onPageChangedCallback(int activePageIndex) => currentPage.value = activePageIndex;
}