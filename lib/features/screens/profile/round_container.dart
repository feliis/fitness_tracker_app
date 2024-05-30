import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../navigation_menu.dart';
import '../../../utils/const/text_strings.dart';

class RoundContainer extends StatelessWidget {
  const RoundContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          Container(
            height: 50,
            color: const Color.fromARGB(0, 0, 0, 0),
            child: ElevatedButton(
              onPressed: () => Get.to(() => const NavigationMenu()),
              child: const Text(PTexts.profileMenuTitle1),
            ),
          ),
          Container(
            height: 50,
            color: const Color.fromARGB(0, 0, 0, 0),
            child: ElevatedButton(
              onPressed: () => Get.to(() => const NavigationMenu()),
              child: const Text(PTexts.profileMenuTitle2),
            ),
          ),
        ],
      ),
    );
  }
}
