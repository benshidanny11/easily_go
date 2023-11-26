import 'dart:io';

import 'package:easylygo_app/common/colors.dart';
import 'package:easylygo_app/common/input_decorations.dart';
import 'package:easylygo_app/common/text_styles.dart';
import 'package:easylygo_app/constants/routes.dart';
import 'package:easylygo_app/constants/string_constants.dart';
import 'package:easylygo_app/models/LocationModel.dart';
import 'package:easylygo_app/providers/app_provider.dart';
import 'package:easylygo_app/strings/extracted.dart';
import 'package:easylygo_app/utils/alert_util.dart';
import 'package:easylygo_app/utils/image_util.dart';
import 'package:easylygo_app/utils/location_util.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class UserRegister extends ConsumerStatefulWidget {
  const UserRegister({super.key});

  @override
  ConsumerState<UserRegister> createState() => _UserRegisterState();
}

class _UserRegisterState extends ConsumerState<UserRegister> {
  final fullNameControll = TextEditingController();
  final phoneNumberControll = TextEditingController();
  final homeAddressControll = TextEditingController();
  bool validateNames = false;
  bool validatePhoneNumber = false;
  bool validateHomeAddress = false;
  String userRole = "Driver";
  XFile? image;
  @override
  Widget build(BuildContext context) {
    final sreenWidth = MediaQuery.of(context).size.width;
    final sreenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
          body: Padding(
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: SizedBox(
            height: sreenHeight * .9,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Image.asset('assets/images/app_logo_blue.png'),
                      Text(
                        'Create your account',
                        style: textStyleTitle(17),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        'We never share your inforation, we keep it protected.',
                        style: textStyleContentSmall(12),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () async {
                            image = await ImageUtil.pickGalleryImage();
                            setState(() {});
                          },
                          child: Stack(clipBehavior: Clip.none, children: [
                            image != null
                                ? ClipOval(
                                    child: Image.file(
                                    File(image!.path),
                                    width: 150,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  ))
                                : Image.asset('assets/images/user_avatar.png'),
                            const Positioned(
                              bottom: -5,
                              right: -15,
                              child: Icon(
                                Icons.add_a_photo,
                                color: AppColors.mainColor,
                              ),
                            )
                          ]),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: sreenWidth * .9,
                        child: TextField(
                          decoration: InputDecorations.getInputTextDecoration(
                              "Full name", Icons.account_box, validateNames),
                          controller: fullNameControll,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: sreenWidth * .9,
                        child: TextField(
                          decoration: InputDecorations.getInputTextDecoration(
                              "Phone number", Icons.phone, validatePhoneNumber),
                          controller: phoneNumberControll,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: sreenWidth * .9,
                        child: TextField(
                          decoration: InputDecorations.getInputTextDecoration(
                              "Home address",
                              Icons.location_on,
                              validateHomeAddress),
                          controller: homeAddressControll,
                        ),
                      ),
                      USER_MODE == 'DRIVER_MOTOR_RIDER_MODE'
                          ? Container(
                              width: sreenWidth * .9,
                              margin: const EdgeInsets.only(top: 10),
                              child: DropdownButtonFormField<String>(
                                decoration:
                                    InputDecorations.getInputTextDecoration(
                                        "Profession", Icons.cases, false),
                                value: userRole,
                                items: <String>[
                                  'Driver',
                                  'Motor rider'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: textStyleContentSmall(12),
                                    ),
                                  );
                                }).toList(),
                                // Step 5.
                                onChanged: (String? newValue) {
                                  setState(() {
                                    userRole = newValue!;
                                    ref.read(userProvider).userRole =
                                        newValue == 'Driver'
                                            ? DRIVER_ROLE
                                            : MOTOR_RIDER_ROLE;
                                  });
                                },
                              ),
                            )
                          : Container()
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                        onTap: () async {
                          try {
                            setState(() {
                              validateNames = fullNameControll.text.isEmpty;
                              validatePhoneNumber =
                                  phoneNumberControll.text.isEmpty;
                              validateHomeAddress =
                                  homeAddressControll.text.isEmpty;
                            });

                            if (!validateNames &&
                                !validateHomeAddress &&
                                !validatePhoneNumber) {
                              final fmInstance = FirebaseMessaging.instance;
                              fmInstance.requestPermission(announcement: true);

                              final token = await fmInstance.getToken();
                              String imageUrl = "";
                              if (image != null) {
                                AlertUtil.showLoadingAlertDialig(
                                    context, 'Getting ready', false);
                                imageUrl = await ImageUtil.uploadImage(
                                    "userimages", image!);
                              }
                              final locationData =
                                  await LocationUtil.getCurrentLocationData();
                              final locationModel = LocationModel(
                                  latitude: locationData!.latitude,
                                  longitude: locationData.longitude);
                              ref.read(userProvider).phoneNumber =
                                  phoneNumberControll.text;
                              ref.read(userProvider).fullName =
                                  fullNameControll.text;
                              ref.read(userProvider).homeAddress =
                                  homeAddressControll.text;
                              ref.read(userProvider).regDate = DateTime.now();
                              ref.read(userProvider).imageUrl = imageUrl;
                              ref.read(userProvider).deviceToken = token;
                              ref.read(userProvider).location=locationModel;

                              Navigator.pushNamed(context, TERMS_AND_CONDITION);
                            }
                          } catch (error) {
                            print(error);
                          }
                        },
                        child: Image.asset('assets/images/icon_next.png')),
                  )
                ]),
          ),
        ),
      )),
    );
  }
}
