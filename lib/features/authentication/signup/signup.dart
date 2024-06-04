// import 'package:fitness_tracker_app/helper_functions.dart';
import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fitness_tracker_app/utils/const/sizes.dart';
import 'package:fitness_tracker_app/utils/const/text_strings.dart';
import 'package:fitness_tracker_app/utils/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final controller = Get.put(SignupController());
  late Sex selectedSex;
  List<Sex> sex = <Sex>[
    const Sex(true, 'Мужской'),
    const Sex(false, 'Женский')
  ];

  @override
  void initState() {
    super.initState();
    selectedSex = sex[0];
  }

  @override
  Widget build(BuildContext context) {
    final dark = PHelperFunctions.isDarkMode(context);
    final controller = Get.put(SignupController());

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
                            controller: controller.name,
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
                            controller: controller.lastname,
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
                      controller: controller.username,
                      expands: false,
                      decoration: const InputDecoration(
                        labelText: PTexts.username,
                        prefixIcon: Icon(Iconsax.user_edit),
                      ),
                    ),
                    const SizedBox(height: PSizes.spaceBtwInputFields),

                    /// Gender
                    DropdownButtonFormField2<Sex>(
                      value: selectedSex,
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: PTexts.gender,
                        prefixIcon: const Icon(Iconsax.profile_2user),
                        contentPadding: const EdgeInsets.all(19),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      items: sex.map((Sex s) {
                        return new DropdownMenuItem<Sex>(
                            value: s,
                            child: Text(
                              s.name,
                              style: const TextStyle(
                                fontSize: PSizes.fontSm,
                              ),
                            ));
                      }).toList(),

                      onChanged: (Sex? newValue) {
                        setState(() {
                          selectedSex = newValue!;
                        });
                      },

                      // validator: (value) {
                      //   if (value == null) {
                      //     return 'Please select gender.';
                      //   }
                      //   return null;
                      // },

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
                        controller: controller.birthday,
                        decoration: const InputDecoration(
                          labelText: PTexts.dateOfBirth,
                          prefixIcon: Icon(Iconsax.calendar_1),
                          hintText: PTexts.dateOfBirth,
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
                            controller: controller.height,
                            expands: false,
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
                            controller: controller.weight,
                            expands: false,
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
                      controller: controller.password,
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
                        onPressed: () => createUser(
                            controller.name.text,
                            controller.lastname.text,
                            controller.username.text,
                            selectedSex.content,
                            controller.birthday.text,
                            controller.height.text,
                            controller.weight.text,
                            controller.password.text),
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
      locale: const Locale('ru', 'RU'),
      builder: (BuildContext context, Widget? child) {
        // Change Widget to Widget?
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: PColors.primary,
              onPrimary: Colors.white,
              surface: PColors.white,
              onSurface: PColors.black,
            ),
            dialogBackgroundColor: Colors.blue[900],
          ),
          child: child ?? Container(), // Handle the case where child is null
        );
      },
    );

    if (_picked != null) {
      setState(() {
        controller.birthday.text = _picked.toString().split(" ")[0];
      });
    }
  }



  Future<String> createUser(name, lastname, username, sex, birthday, height, weight, password) async {

  
    var url = Uri.https('utterly-comic-parakeet.ngrok-free.app', "signup");
    print(url);
    try {
      var response = await http.post(url,
          body: jsonEncode({
            'name': name.toString(),
            'lastname': lastname.toString(),
            'username': username.toString(),
            'sex': sex.toString(),
            'birthday': birthday.toString(),
            'height': height.toString(),
            'weight': weight.toString(),
            'password': password.toString(),
          }),
          headers: {
            "ngrok-skip-browser-warning": "true",
            "Content-Type": "application/json",
            "Accept": "application/json"
          });
      print(response);

      print(jsonDecode(response.body));
      var decodedBody = jsonDecode(response.body) as Map;
      print(decodedBody);
      if (decodedBody['success'] == false) {
        return '';
      }
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('user', jsonEncode(decodedBody['id']));
      Get.to(() => const NavigationMenu());
      return decodedBody['id'].toString();
    } catch (e) {
      print(e);
      return '';
    }
  }
}

class Sex {
  const Sex(this.content, this.name);

  final bool content;
  final String name;
}
