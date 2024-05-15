import 'package:fitness_tracker_app/utils/const/image_strings.dart';
import 'package:fitness_tracker_app/utils/const/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers.onboarding/onboarding_controller.dart';
import 'widgets/next_button.dart';
import 'widgets/onboarding_dot_navigation.dart';
import 'widgets/onboarding_page.dart';
import 'widgets/onboarding_skip.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBoardingController());

    return Scaffold(
        body: Stack(
      children: [
        PageView(
          controller: controller.pageController,
          onPageChanged: controller.updatePageIndicator,
          children: const [
            OnBoardingPage(
                image: PImages.onBoardingImage1,
                title: PTexts.OnBoardingTitle1,
                subTitle: PTexts.OnBoardingSubTitle1),
            OnBoardingPage(
                image: PImages.onBoardingImage2,
                title: PTexts.OnBoardingTitle2,
                subTitle: PTexts.OnBoardingSubTitle2),
            OnBoardingPage(
                image: PImages.onBoardingImage3,
                title: PTexts.OnBoardingTitle3,
                subTitle: PTexts.OnBoardingSubTitle3),
          ],
        ),
        const OnBoardingSkip(),
        const OnBoardingDotNavigation(),
        const NextButton(),
      ],
    ));
  }
}
