import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  /// Variables
  final hidePassword = true.obs;
  final name = TextEditingController();
  final lastname = TextEditingController();
  final username = TextEditingController();
  final sex = TextEditingController();
  final birthday = TextEditingController();
  final height = TextEditingController();
  final weight = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
}
