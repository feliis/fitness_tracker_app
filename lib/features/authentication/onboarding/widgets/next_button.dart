import 'package:fitness_tracker_app/utils/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/const/sizes.dart';
import '../../../../utils/device/device_utility.dart';
import '../../../../utils/helper_functions.dart';
import '../controllers.onboarding/onboarding_controller.dart';

class NextButton extends StatelessWidget {
  const NextButton({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = PHelperFunctions.isDarkMode(context);
    return Positioned(
      right: PSizes.defaultSpace,
      bottom: PDeviceUtils.getBottomNavigationBarHeight(),
      child: ElevatedButton(
        onPressed: () => OnBoardingController.instance.nextPage(),
        style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            side: const BorderSide(color: Color.fromARGB(0, 0, 0, 0)),
            backgroundColor: dark ? PColors.primary : Colors.black),
        child: const Icon(Iconsax.arrow_right_3),
      ),
    );
  }
}
