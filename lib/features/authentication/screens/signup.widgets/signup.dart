// import 'package:fitness_tracker_app/helper_functions.dart';
import 'package:fitness_tracker_app/utils/const/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:fitness_tracker_app/utils/const/text_strings.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../../../../helper_functions.dart';
import '../../../../navigation_menu.dart';
import '../../../../utils/const/colors.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = PHelperFunctions.isDarkMode(context);
    String? selectedValue;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: dark ? Colors.black : Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(PSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title
              Text(
                PTexts.signupTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: PSizes.spaceBtwSections),

              /// Form
              Form(
                child: Column(
                  children: [
                    /// First & Last Name
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            expands: false,
                            decoration: const InputDecoration(
                              labelText: PTexts.firstName,
                              prefixIcon: Icon(Iconsax.user),
                            ),
                          ),
                        ),
                        const SizedBox(width: PSizes.spaceBtwInputFields),
                        Expanded(
                          child: TextFormField(
                            expands: false,
                            decoration: const InputDecoration(
                              labelText: PTexts.lastName,
                              prefixIcon: Icon(Iconsax.user),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: PSizes.spaceBtwInputFields),

                    /// Username
                    TextFormField(
                      expands: false,
                      decoration: const InputDecoration(
                        labelText: PTexts.username,
                        prefixIcon: Icon(Iconsax.user_edit),
                      ),
                    ),
                    const SizedBox(height: PSizes.spaceBtwInputFields),

                    /// Gender
                    DropdownButtonFormField2<String>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: PTexts.gender,
                        prefixIcon: const Icon(Iconsax.profile_2user),
                        contentPadding: const EdgeInsets.all(19),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      items: PTexts.genderItems
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: PSizes.fontSm,
                                  ),
                                ),
                              ))
                          .toList(),
                      // validator: (value) {
                      //   if (value == null) {
                      //     return 'Please select gender.';
                      //   }
                      //   return null;
                      // },
                      onChanged: (value) {
                        //Do something when selected item is changed.
                      },
                      onSaved: (value) {
                        selectedValue = value.toString();
                      },
                      buttonStyleData: const ButtonStyleData(
                        padding: EdgeInsets.only(right: 8),
                      ),
                      iconStyleData: const IconStyleData(
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black45,
                        ),
                        iconSize: 24,
                      ),
                      dropdownStyleData: DropdownStyleData(
                        decoration: BoxDecoration(
                          color: (dark ? PColors.black : PColors.white),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),

                    const SizedBox(height: PSizes.spaceBtwInputFields),

                    /// Date of Birth
                    TextFormField(
                      expands: false,
                      inputFormatters: [maskFormatter],
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: PTexts.dateOfBirth,
                        prefixIcon: Icon(Iconsax.calendar_1),
                        hintText: PTexts.dateOfBirthHint,
                      ),
                    ),

                    const SizedBox(height: PSizes.spaceBtwInputFields),

                    /// Height & weight
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: TextFormField(
                    //         expands: false,
                    //         inputFormatters: [maskFormatter],
                    //         keyboardType: TextInputType.number,
                    //         decoration: const InputDecoration(
                    //           labelText: PTexts.height,
                    //           prefixIcon: Icon(Iconsax.ruler),
                    //         ),
                    //       ),
                    //     ),
                    //     const SizedBox(width: PSizes.spaceBtwInputFields),
                    //     Expanded(
                    //       child: TextFormField(
                    //         expands: false,
                    //         inputFormatters: [maskFormatter],
                    //         keyboardType: TextInputType.number,
                    //         decoration: const InputDecoration(
                    //           labelText: PTexts.weight,
                    //           prefixIcon: Icon(Iconsax.weight),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),

                    // const SizedBox(height: PSizes.spaceBtwInputFields),

                    /// Phone Number
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: PTexts.phoneNo,
                        prefixIcon: Icon(Iconsax.call),
                      ),
                    ),
                    const SizedBox(height: PSizes.spaceBtwInputFields),

                    /// Password
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: PTexts.password,
                        prefixIcon: Icon(Iconsax.password_check),
                        suffixIcon: Icon(Iconsax.eye_slash),
                      ),
                    ),
                    const SizedBox(height: PSizes.spaceBtwInputFields),

                    /// Terms&Conditions Checkbox
                    ///

                    /// Next Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Get.to(() => const NavigationMenu()),
                        child: const Text(PTexts.createAccount),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
