import 'package:fitness_tracker_app/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../helper_functions.dart';
import '../../../../utils/const/colors.dart';
import '../../../../utils/const/sizes.dart';

class PAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PAppBar({
    super.key,
    this.title,
    this.actions,
    this.leadingIcon,
    this.leadingOnPressed,
    this.showBackArrow = false,
  });

  final Widget? title;
  final bool showBackArrow;
  final IconData? leadingIcon;
  final List<Widget>? actions;
  final VoidCallback? leadingOnPressed;

  @override
  Widget build(BuildContext context) {
    final dark = PHelperFunctions.isDarkMode(context);

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: PSizes.md),
        child: AppBar(
          backgroundColor: dark ? Colors.black : PColors.white,
          automaticallyImplyLeading: false,
          leading: showBackArrow
              ? IconButton(
                  color: dark ? PColors.white : Colors.black,
                  onPressed: () => Get.back(),
                  icon: const Icon(Iconsax.arrow_left))
              : leadingIcon != null
                  ? IconButton(
                      onPressed: leadingOnPressed, icon: Icon(leadingIcon))
                  : null,
          title: title,
          actions: actions,
        ));
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(PDeviceUtils.getAppBarHeight());
}
