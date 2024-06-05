// import 'package:fitness_tracker_app/helper_functions.dart';
import 'dart:async';
import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fitness_tracker_app/features/authentication/login/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/widgets/appbar.dart';
import '../../../common/widgets/circular_image.dart';
import '../../../utils/const/colors.dart';
import '../../authentication/signup/signup.dart';
import '../../../utils/const/image_strings.dart';
import '../../../utils/const/sizes.dart';
import '../../../utils/const/text_strings.dart';
import '../../../utils/helper_functions.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = PHelperFunctions.isDarkMode(context);
    final controller = Get.put(LoginController());
    String? selectedValue;
    DateTime formattedDate;


    return Scaffold(
      appBar: const PAppBar(
        showBackArrow: false,
        title: Text('Мой профиль'),
      ),
      body: Center(
        child: FutureBuilder<Map<String, dynamic>>(
          future: get_user(),
          builder: (BuildContext context,
              AsyncSnapshot<Map<String, dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              String formattedDate = '';
              
              if (snapshot.data!['birthday'] != null) {
                
                DateFormat inputFormat =
                    DateFormat('EEE, dd MMM yyyy HH:mm:ss');
                    
                DateTime parsedDate =
                    inputFormat.parse(snapshot.data!['birthday']);
                formattedDate = DateFormat('dd MMMM yyyy').format(parsedDate);
                print(formattedDate);
              }
              return Padding(
          padding: const EdgeInsets.all(PSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    PCircularImage(image: PImages.user, width: 80, height: 80),
                  ],
                ),
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
                            readOnly: true,
                            initialValue: '${snapshot.data!['name']}',
                            expands: false,
                            decoration: const InputDecoration(
                              labelText: PTexts.firstName,
                              // prefixIcon: Icon(Iconsax.user),
                            ),
                          ),
                        ),
                        const SizedBox(width: PSizes.spaceBtwInputFields),
                        Expanded(
                          child: TextFormField(
                            readOnly: true,
                            initialValue: '${snapshot.data!['lastname']}',
                            expands: false,
                            decoration: const InputDecoration(
                              labelText: PTexts.lastName,
                              // prefixIcon: Icon(Iconsax.user),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: PSizes.spaceBtwInputFields),
                    /// Username
                    TextFormField(
                      readOnly: true,
                      initialValue: '${snapshot.data!['username']}',
                      expands: false,
                      decoration: const InputDecoration(

                        // labelText: PTexts.username,
                        // prefixIcon: Icon(Iconsax.user_edit),
                      ),
                    ),
                    const SizedBox(height: PSizes.spaceBtwInputFields),

                    // /// Gender
                    // DropdownButtonFormField2<Sex>(
                    //   value: selectedSex,
                    //   isExpanded: true,
                    //   decoration: InputDecoration(
                    //     labelText: PTexts.gender,
                    //     prefixIcon: const Icon(Iconsax.profile_2user),
                    //     contentPadding: const EdgeInsets.all(19),
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(15),
                    //     ),
                    //   ),
                    //   items: sex.map((Sex s) {
                    //     return new DropdownMenuItem<Sex>(
                    //         value: s,
                    //         child: Text(
                    //           s.name,
                    //           style: const TextStyle(
                    //             fontSize: PSizes.fontSm,
                    //           ),
                    //         ));
                    //   }).toList(),

                    //   onChanged: (Sex? newValue) {
                    //     setState(() {
                    //       selectedSex = newValue!;
                    //     });
                    //   },

                      // validator: (value) {
                      //   if (value == null) {
                      //     return 'Please select gender.';
                      //   }
                      //   return null;
                      // },

                    //   buttonStyleData: const ButtonStyleData(
                    //     padding: EdgeInsets.only(right: 8),
                    //   ),
                    //   iconStyleData: const IconStyleData(
                    //     icon: Icon(
                    //       Icons.arrow_drop_down,
                    //       color: Colors.black45,
                    //     ),
                    //     iconSize: 24,
                    //   ),
                    //   dropdownStyleData: DropdownStyleData(
                    //     decoration: BoxDecoration(
                    //       color: (dark ? PColors.black : PColors.white),
                    //       borderRadius: BorderRadius.circular(15),
                    //     ),
                    //   ),
                    //   menuItemStyleData: const MenuItemStyleData(
                    //     padding: EdgeInsets.symmetric(horizontal: 16),
                    //   ),
                    // ),

                    const SizedBox(height: PSizes.spaceBtwInputFields),

                    /// Date of Birth
                    TextFormField(
                      readOnly: true,
                      initialValue: '$formattedDate',
                      expands: false,
                      inputFormatters: [maskFormatter],
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: PTexts.dateOfBirth,
                        // prefixIcon: Icon(Iconsax.calendar_1),
                        hintText: PTexts.dateOfBirth,
                      ),
                    ),

                    const SizedBox(height: PSizes.spaceBtwInputFields),

                    /// Height & weight
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            readOnly: true,
                            initialValue: '${snapshot.data!['height']} см',
                            expands: false,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: PTexts.height,
                              // prefixIcon: Icon(Iconsax.ruler),
                            ),
                          ),
                        ),
                        const SizedBox(width: PSizes.spaceBtwInputFields),
                        Expanded(
                          child: TextFormField(
                            readOnly: true,
                            initialValue: '${snapshot.data!['weight']} кг',
                            expands: false,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: PTexts.weight,
                              // prefixIcon: Icon(Iconsax.weight),
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
                    // TextFormField(
                    //   onSaved: (value) => user.password = value ?? '0',
                    //   validator: (value) => Validator.validateEmptyText(value),
                    //   obscureText: controller.hidePassword.value,
                    //   decoration: InputDecoration(
                    //     labelText: PTexts.password,
                    //     prefixIcon: const Icon(Iconsax.password_check),
                    //     suffixIcon: IconButton(
                    //       onPressed: () => controller.hidePassword.value =
                    //           !controller.hidePassword.value,
                    //       icon: Icon(controller.hidePassword.value
                    //           ? Iconsax.eye_slash
                    //           : Iconsax.eye),
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(height: PSizes.spaceBtwInputFields),

                    /// Terms&Conditions Checkbox
                    ///

                    // /// Next Button
                    // SizedBox(
                    //   width: double.infinity,
                    //   child: ElevatedButton(
                    //     onPressed: () => Get.to(() => const NavigationMenu()),
                    //     child: const Text(PTexts.createAccount),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        );
            } else {
              return Text('No data');
            }
          },
        ),
        ),
        );

  }
  
  void setState(Null Function() param0) {}
}


Future<Map<String, dynamic>> get_user() async {
  final prefs = await SharedPreferences.getInstance();
  final String id = prefs.get('user').toString();

  print(id.toString());
  final query = {'id': '${id.replaceAll(RegExp(r'"'), '')}'};
  print(query);
  var url =
      Uri.https('utterly-comic-parakeet.ngrok-free.app', "profile", query);
  print(url);
  try {
    var response = await http.get(url, headers: {
      "ngrok-skip-browser-warning": "true",
      "Content-Type": "application/json",
      "Accept": "application/json"
    });
    print(response);
    print(jsonDecode(response.body)['name']);
    var decodedBody = jsonDecode(response.body);
    if (decodedBody['success'] == false) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  } catch (e) {
    print(e);
    throw Error();
  }
}


// Form(
//                 child: Column(
//                   children: [
//                     Text('Имя пользователя: ${snapshot.data!['name']}'),
//                     Text('Имя пользователя: ${snapshot.data!['lastname']}'),
//                     Text('Имя пользователя: ${snapshot.data!['username']}'),
//                     Text('Дата рождения: $formattedDate'),
//                     Text('Пол: ${snapshot.data!['sex']}'),
//                     Text('Рост: ${snapshot.data!['height']}'),
//                     Text('Вес: ${snapshot.data!['weight']}'),
//                   ],
//                 ),
//               );