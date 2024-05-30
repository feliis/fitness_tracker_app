import 'package:flutter/material.dart';

import '../../utils/const/colors.dart';

class CircularContainer extends StatelessWidget {
  const CircularContainer({
    super.key,
    this.child,
    this.width,
    this.height,
    this.radius,
    this.padding,
    this.backgroundColor = PColors.white,
  });

  final double? width;
  final double? height;
  final double? radius;
  final double? padding;
  final Widget? child;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 400,
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(400),
        color: PColors.textWhite.withOpacity(0.1),
      ),
      child: child,
    );
  }
}
