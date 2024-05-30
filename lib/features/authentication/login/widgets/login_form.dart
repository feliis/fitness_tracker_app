import 'package:fitness_tracker_app/features/authentication/login/login_controller.dart';
import 'package:fitness_tracker_app/features/authentication/signup/signup.dart';
import 'package:fitness_tracker_app/utils/const/sizes.dart';
import 'package:fitness_tracker_app/utils/const/text_strings.dart';
import 'package:fitness_tracker_app/utils/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../model/auth_model.dart';
import '../../../../navigation_menu.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PLoginForm extends StatelessWidget {
  const PLoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return Form(
      key: controller.loginFormKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: PSizes.spaceBtwSections),
        child: Column(children: [
          /// Phone
          TextFormField(
            controller: controller.name,
            onSaved: (value) => user.name = value ?? '0',
            validator: (value) => Validator.validatePhone(value),
            decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.user_square),
                labelText: PTexts.username),
          ),
          const SizedBox(height: PSizes.spaceBtwInputFields),

          /// Password
          Obx(
            () => TextFormField(
              controller: controller.password,
              onSaved: (value) => user.password = value ?? '0',
              validator: (value) => Validator.validateEmptyText(value),
              obscureText: controller.hidePassword.value,
              decoration: InputDecoration(
                labelText: PTexts.password,
                prefixIcon: Icon(Iconsax.password_check),
                suffixIcon: IconButton(
                  onPressed: () => controller.hidePassword.value =
                      !controller.hidePassword.value,
                  icon: Icon(controller.hidePassword.value
                      ? Iconsax.eye_slash
                      : Iconsax.eye),
                ),
              ),
            ),
          ),
          const SizedBox(height: PSizes.spaceBtwInputFields / 2),

          const SizedBox(height: PSizes.spaceBtwSections),

          /// Sign In Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (){},
              // () => Get.to(() => const NavigationMenu()),
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

Future<void> tryLogin(BuildContext context) async{
 var url =
        Uri.http('gymlink.freemyip.com:8080', 'api/auth/authorize_client');
    try {
      var response = await http.post(url, body: {
        'GymKey': 'eeb42dcb-8e5b-4f21-825a-3fc7ada43445',
        'id': '123'
      }); // Just testing token
      var decodedBody = jsonDecode(response.body) as Map;
}
}