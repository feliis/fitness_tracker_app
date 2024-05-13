import 'package:fitness_tracker_app/features/authentication/screens/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'features/authentication/screens/home/home.dart';
import 'features/authentication/screens/home/pedometer_page.dart';
import 'helper_functions.dart';
import 'utils/const/colors.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final dark = PHelperFunctions.isDarkMode(context);

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          backgroundColor: dark ? PColors.dark : PColors.light,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) =>
              controller.selectedIndex.value = index,
          destinations: const [
            NavigationDestination(icon: Icon(Iconsax.home_2), label: 'Главная'),
            NavigationDestination(icon: Icon(Iconsax.add), label: ''),
            NavigationDestination(
                icon: Icon(Iconsax.user), label: 'Мой профиль'),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    MainPage(),
    PedometerPage(),
    const ProfileScreen(),
  ];
}