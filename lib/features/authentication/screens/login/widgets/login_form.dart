import 'package:fitness_tracker_app/features/authentication/screens/signup.widgets/signup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:fitness_tracker_app/utils/const/sizes.dart';
import '../../../../../navigation_menu.dart';
import 'package:fitness_tracker_app/utils/const/text_strings.dart';

class PLoginForm extends StatelessWidget {
  const PLoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: PSizes.spaceBtwSections),
        child: Column(children: [
          ///Email
          TextFormField(
            decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.call), labelText: PTexts.phoneNo),
          ),
          const SizedBox(height: PSizes.spaceBtwInputFields),

          ///Password
          TextFormField(
            decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.password_check),
                labelText: PTexts.password,
                suffixIcon: Icon(Iconsax.eye_slash)),
          ),
          const SizedBox(height: PSizes.spaceBtwInputFields / 2),

          const SizedBox(height: PSizes.spaceBtwSections),

          /// Sign In Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Get.to(() => const NavigationMenu()),
              child: const Text(PTexts.signIn),
            ),
          ),
          const SizedBox(height: PSizes.spaceBtwItems),

          /// Create Account Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Get.to(() => const SignupScreen()),
              child: const Text(PTexts.createAccount),
            ),
          ),
          const SizedBox(height: PSizes.spaceBtwSections),
        ]),
      ),
    );
  }
}
