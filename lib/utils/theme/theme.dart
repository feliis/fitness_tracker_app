import 'package:flutter/material.dart';

import 'package:fitness_tracker_app/utils/theme/custom_themes/appbar_theme.dart';
import 'package:fitness_tracker_app/utils/theme/custom_themes/bottom_sheet_theme.dart';
import 'package:fitness_tracker_app/utils/theme/custom_themes/elevated_button_theme.dart';
import 'package:fitness_tracker_app/utils/theme/custom_themes/text_field_theme.dart';
import 'package:fitness_tracker_app/utils/theme/custom_themes/text_theme.dart';
import 'package:fitness_tracker_app/utils/theme/custom_themes/outlined_button_theme.dart';

class PAppTheme {
  PAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    textTheme: PTextTheme.lightTextTheme,
    appBarTheme: PAppBarTheme.lightAppBarTheme,
    elevatedButtonTheme: PElevatedButtonTheme.lightElevatedButtonTheme,
    bottomSheetTheme: PBottomSheetTheme.lightBottomSheetTheme,
    outlinedButtonTheme: POutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: PTextFormFieldTheme.lightInputDecorationTheme,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.black,
    textTheme: PTextTheme.darkTextTheme,
    appBarTheme: PAppBarTheme.darkAppBarTheme,
    elevatedButtonTheme: PElevatedButtonTheme.darkElevatedButtonTheme,
    bottomSheetTheme: PBottomSheetTheme.darkBottomSheetTheme,
    outlinedButtonTheme: POutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: PTextFormFieldTheme.darkInputDecorationTheme,
  );
}
