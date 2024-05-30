import 'package:fitness_tracker_app/utils/helper_functions.dart';
import 'package:flutter/material.dart';

import '../../utils/const/colors.dart';
import '../../utils/const/sizes.dart';

class PCircularImage extends StatelessWidget {
  const PCircularImage({
    super.key,
    required this.image,
    this.width = 56,
    this.height = 56,
    this.overlayColor,
    this.backgroundColor,
    this.fit = BoxFit.cover,
    this.padding = PSizes.sm,
    this.isNetworkImage = false,
  });

  final BoxFit? fit;
  final String image;
  final bool isNetworkImage;
  final Color? overlayColor;
  final Color? backgroundColor;
  final double width, height, padding;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: height,
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: backgroundColor ??
              (PHelperFunctions.isDarkMode(context)
                  ? PColors.black
                  : PColors.white),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: Image(
            fit: fit,
            image: isNetworkImage
                ? NetworkImage(image)
                : AssetImage(image) as ImageProvider,
            color: overlayColor,
          ),
        ));
  }
}
