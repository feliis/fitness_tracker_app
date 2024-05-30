import 'package:fitness_tracker_app/utils/const/sizes.dart';
import 'package:fitness_tracker_app/utils/device/device_utility.dart';
import 'package:flutter/material.dart';

import '../controllers.onboarding/onboarding_controller.dart';

class OnBoardingSkip extends StatelessWidget {
  const OnBoardingSkip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: PDeviceUtils.getAppBarHeight(),
      right: PSizes.defaultSpace,
      child: TextButton(
        onPressed: () => OnBoardingController.instance.skipPage(),
        child: const Text('Пропустить'),
      ),
    );
  }
}
