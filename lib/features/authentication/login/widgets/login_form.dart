import 'package:fitness_tracker_app/features/authentication/login/login_controller.dart';
import 'package:fitness_tracker_app/features/authentication/signup/signup.dart';
import 'package:fitness_tracker_app/utils/const/sizes.dart';
import 'package:fitness_tracker_app/utils/const/text_strings.dart';
import 'package:fitness_tracker_app/utils/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../model/user_model.dart';
import '../../../../navigation_menu.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class PLoginForm extends StatefulWidget {
  const PLoginForm({super.key});
 
  @override
  State<PLoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<PLoginForm> {
  final controller = Get.put(LoginController());


  @override
  Widget build(BuildContext context) {
    
    return Form(
      key: controller.loginFormKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: PSizes.spaceBtwSections),
        child: Column(children: [
          /// Name
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
              onPressed: () => SignIn(controller.name.text, controller.password.text),
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

void SignIn(String name, String password) {
    print(name);
    print(password);
    _setToken(name, password);
  }


Future<void> _setToken(name, pass) async {
      final prefs = await SharedPreferences.getInstance();

      final token = await _getToken(name, pass);
      if (token != '') {
        prefs.setString('user', jsonEncode(token));
        print('Всё ок');
        Get.to(() => const NavigationMenu());
      } else {
        print('Не верно');
      }
    }
    
    Future<String> _getToken(name , pass) async {
      var url =
          Uri.https('utterly-comic-parakeet.ngrok-free.app', 'login');
        print(url);
      try {
        var response = await http.post(url, body: jsonEncode( {
          'name': name.toString(),
          'password': pass.toString()
        }), 
        headers: {"ngrok-skip-browser-warning":"true", "Content-Type": "application/json", "Accept": "application/json"}); 
        print(response);
        print(jsonDecode(response.body));
        var decodedBody = jsonDecode(response.body) as Map;
        print(decodedBody);
        if (decodedBody['success'] == false) {
          return '';
        }
        return decodedBody['id'].toString();
      } catch (e) {
        print(e);
        return '';
      }
    }