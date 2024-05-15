import 'package:fitness_tracker_app/utils/helper_functions.dart';
import 'package:flutter/material.dart';

import '../../../../utils/const/image_strings.dart';
import '../../../../utils/const/sizes.dart';
import '../../../../utils/const/text_strings.dart';

class PLoginHeader extends StatelessWidget {
  const PLoginHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = PHelperFunctions.isDarkMode(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image(
          height: 150,
          image: AssetImage(dark ? PImages.darkAppLogo : PImages.lightAppLogo),
        ),
        Text(PTexts.loginTitle,
            style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: PSizes.sm),
        Text(PTexts.logininSubTitle,
            style: Theme.of(context).textTheme.bodyMedium)
      ],
    );
  }
}
