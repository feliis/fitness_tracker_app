import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  /// Variables
  final hidePassword = true.obs;
  final phone = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
}
