import 'package:fitness_tracker_app/utils/const/image_strings.dart';
import 'package:fitness_tracker_app/utils/const/sizes.dart';
import 'package:flutter/material.dart';

import 'appbar.dart';
import 'circular_image.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: PAppBar(
        showBackArrow: false,
        title: Text('Мой профиль'),
      ),

      /// Body
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.all(PSizes.defaultSpace),
        child: Column(children: [
          /// Profile Photo
          SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                PCircularImage(image: PImages.user, width: 80, height: 80),
                // TextButton(
                //   onPressed: (){},
                //   child: Text('Сменить фото'),
                // ),
              ],
            ),
          ),

          /// Details
          SizedBox(height: PSizes.spaceBtwItems / 2),
          Divider(),
          SizedBox(height: PSizes.spaceBtwItems),
        ]),
      )),
    );
  }
}
