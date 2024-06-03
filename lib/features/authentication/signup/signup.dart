// import 'package:fitness_tracker_app/helper_functions.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fitness_tracker_app/features/authentication/login/login_controller.dart';
import 'package:fitness_tracker_app/utils/const/sizes.dart';
import 'package:fitness_tracker_app/utils/const/text_strings.dart';
import 'package:fitness_tracker_app/utils/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../model/user_model.dart';
import '../../../navigation_menu.dart';
import '../../../utils/const/colors.dart';
import '../../../utils/helper_functions.dart';
import 'signup_controller.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupState();
}

class _SignupState extends State<SignupScreen> {
  TextEditingController _dateController = TextEditingController();
  final controller = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    final dark = PHelperFunctions.isDarkMode(context);
    final controller = Get.put(LoginController());
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
                        // expands: false,
                        // inputFormatters: [maskFormatter],
                        // keyboardType: TextInputType.number,
                        controller: _dateController,
                        decoration: const InputDecoration(
                          labelText: PTexts.dateOfBirth,
                          prefixIcon: Icon(Iconsax.calendar_1),
                          hintText: PTexts.dateOfBirthHint,
                          filled: true,
                        ),
                        readOnly: true,
                        onTap: () {
                          _selectDate();
                        }),

                    const SizedBox(height: PSizes.spaceBtwInputFields),

                    /// Height & weight
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            expands: false,
                            inputFormatters: [maskFormatter],
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: PTexts.height,
                              prefixIcon: Icon(Iconsax.ruler),
                            ),
                          ),
                        ),
                        const SizedBox(width: PSizes.spaceBtwInputFields),
                        Expanded(
                          child: TextFormField(
                            expands: false,
                            inputFormatters: [maskFormatter],
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: PTexts.weight,
                              prefixIcon: Icon(Iconsax.weight),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: PSizes.spaceBtwInputFields),

                    /// Phone Number
                    // TextFormField(
                    //   decoration: const InputDecoration(
                    //     labelText: PTexts.phoneNo,
                    //     prefixIcon: Icon(Iconsax.call),
                    //   ),
                    // ),
                    // const SizedBox(height: PSizes.spaceBtwInputFields),

                    /// Password
                    TextFormField(
                      onSaved: (value) => user.password = value ?? '0',
                      validator: (value) => Validator.validateEmptyText(value),
                      obscureText: controller.hidePassword.value,
                      decoration: InputDecoration(
                        labelText: PTexts.password,
                        prefixIcon: const Icon(Iconsax.password_check),
                        suffixIcon: IconButton(
                          onPressed: () => controller.hidePassword.value =
                              !controller.hidePassword.value,
                          icon: Icon(controller.hidePassword.value
                              ? Iconsax.eye_slash
                              : Iconsax.eye),
                        ),
                      ),
                    ),
                    const SizedBox(height: PSizes.spaceBtwSections),

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

  Future<void> _selectDate() async {
    DateTime? _picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (_picked != null) {
      setState(() {
        _dateController.text = _picked.toString().split(" ")[0];
      });
    }
  }
}
