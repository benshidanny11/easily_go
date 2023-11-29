
import 'package:easylygo_app/common/button_blue.dart';
import 'package:easylygo_app/common/input_decorations.dart';
import 'package:easylygo_app/common/text_styles.dart';
import 'package:easylygo_app/constants/string_constants.dart';
import 'package:easylygo_app/models/UserModel.dart';
import 'package:easylygo_app/providers/app_provider.dart';
import 'package:easylygo_app/services/user_service.dart';
import 'package:easylygo_app/strings/extracted.dart';
import 'package:easylygo_app/utils/alert_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditUserProfile extends ConsumerStatefulWidget {
  final UserModel userModel;
  const EditUserProfile({super.key,required this.userModel});

  @override
  ConsumerState<EditUserProfile> createState() => _UserRegisterState();
}

class _UserRegisterState extends ConsumerState<EditUserProfile> {

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    fullNameControll.text = widget.userModel.fullName.toString();
    phoneNumberControll.text =  widget.userModel.phoneNumber.toString();
    homeAddressControll.text =  widget.userModel.homeAddress.toString();
  }

  final fullNameControll = TextEditingController();
  final phoneNumberControll = TextEditingController();
  final homeAddressControll = TextEditingController();
  bool validateNames = false;
  bool validatePhoneNumber = false;
  bool validateHomeAddress = false;
  String userRole = "Driver";
  
  @override
  Widget build(BuildContext context) {
    final sreenWidth = MediaQuery.of(context).size.width;
    final sreenHeight = MediaQuery.of(context).size.height;
    
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title:const Text('Easyly go'), elevation: 1,),
          body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: SizedBox(
            height: sreenHeight * .9,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Image.asset('assets/images/app_logo_blue.png'),
                      Text(
                        'Update your profile',
                        style: textStyleTitle(17),
                      ),
                    
                    
                    ],
                  ),
                  Column(
                    children: [
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
                    child: ButtonBlue(
                        onPress: () async{
                          try {
                            AlertUtil.showLoadingAlertDialig(context, 'Updating user profile', false);
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
                              ref.read(userProvider).phoneNumber =
                                  phoneNumberControll.text;
                              ref.read(userProvider).fullName =
                                  fullNameControll.text;
                              ref.read(userProvider).homeAddress =
                                  homeAddressControll.text;
                             await UserService.updateUserProfileInfo(ref.read(userProvider));
                             Navigator.pop(context);
                              Navigator.pop(context);
                            }
                          } catch (error) {
                            print(error);
                          }
                        },
                        label: 'Update profile', width: 200,),
                  )
                ]),
          ),
        ),
      )),
    );
  }
}
