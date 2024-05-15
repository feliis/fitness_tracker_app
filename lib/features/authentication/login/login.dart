import 'package:fitness_tracker_app/common/styles/spacing_styles.dart';
import 'package:flutter/material.dart';
import 'widgets/login_form.dart';
import 'widgets/login_header.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: PSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              /// Logo, Title & Sub-Title
              PLoginHeader(),

              /// Form
              PLoginForm(),
              // const PSocialButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
