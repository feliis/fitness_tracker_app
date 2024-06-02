import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:intl/intl.dart';

class PHelperFunctions {
  static Color? getColor(String value) {
    if (value == 'Green') {
      return Colors.green;
    } else if (value == 'Green') {
      return Colors.green;
    } else if (value == 'Red') {
      return Colors.red;
    } else if (value == 'Blue') {
      return Colors.blue;
    } else if (value == 'Pink') {
      return Colors.pink;
    } else if (value == 'Grey') {
      return Colors.grey;
    } else if (value == 'Purple') {
      return Colors.purple;
    } else if (value == 'Black') {
      return Colors.black;
    } else if (value == 'White') {
      return Colors.white;
    } else {
      return null;
    }
  }

  static String getPace(double p) {
    int paceSeconds =
        ((double.parse(p.toStringAsFixed(2)) - p.floor()) * 60).toInt();
    int paceMinutes = p.toInt();
    String pace = paceMinutes.toString() + "'" + paceSeconds.toString() + '"';
    return pace;
  }

  static void navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  // static void isDarkMode(BuildContext context) {
  //   return Theme.of(context).brightness == Brightness.dark;
  // }

  static Size screenSize() {
    return MediaQuery.of(Get.context!).size;
  }

  static double screenHeight() {
    return MediaQuery.of(Get.context!).size.height;
  }

  static double screenWidth() {
    return MediaQuery.of(Get.context!).size.width;
  }
}
