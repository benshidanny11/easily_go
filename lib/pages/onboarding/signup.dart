import 'package:easylygo_app/common/button_blue.dart';
import 'package:easylygo_app/common/text_styles.dart';
import 'package:easylygo_app/constants/routes.dart';
import 'package:easylygo_app/constants/string_constants.dart';
import 'package:easylygo_app/models/UserModel.dart';
import 'package:easylygo_app/providers/app_provider.dart';
import 'package:easylygo_app/services/user_service.dart';
import 'package:easylygo_app/utils/auth_util.dart';
import 'package:easylygo_app/utils/user_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Signup extends ConsumerStatefulWidget {
  const Signup({super.key});

  @override
  ConsumerState<Signup> createState() => _SignupState();
}

class _SignupState extends ConsumerState<Signup> {
  @override
  Widget build(BuildContext context) {
    final sreenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
          body: Padding(
        padding: const EdgeInsets.all(15),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
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
                'Please signup with your current gmail account or create a new one',
                style: textStyleContentSmall(12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          // Column(
          //   children: [
          //     SizedBox(
          //       width: sreenWidth * .9,
          //       child: TextField(
          //         decoration: InputDecorations.getInputTextDecoration(
          //             "Email addess", Icons.email),
          //       ),
          //     ),
          //     SizedBox(
          //       width: sreenWidth * .9,
          //       child: TextField(
          //         decoration: InputDecorations.getInputTextDecoration(
          //             "Password", Icons.lock),
          //       ),
          //     ),
          //       SizedBox(
          //       width: sreenWidth * .9,
          //       child: TextField(
          //         decoration: InputDecorations.getInputTextDecoration(
          //             "Confirm password", Icons.lock),
          //       ),
          //     ),
          //   ],
          // ),
          ButtonBlue(
            onPress: () async {
              await Authentication.initializeFirebase();
              try {
                User user =
                    await Authentication.signInWithGoogle(context: context)
                        as User;

                bool userExists =
                    await UserService.checkUserExists(user.email.toString());

                if (userExists) {
                  UserModel userModel =
                      await UserService.getCurrentUser(user.email.toString()) as UserModel;
                  final prefs = await SharedPreferences.getInstance();
                  prefs.setString(PREF_EMAIL, userModel.email!);
                  prefs.setString(PREF_USERID, userModel.userId!);
                  prefs.setString(PREF_USR_ROLE, userModel.userRole);
                  UserUtil.getUserProvier(userModel, ref);
                  if (prefs.getString(PREF_EMAIL) != null &&
                      prefs.getString(PREF_USR_ROLE) == CUSTOMER_ROLE) {
                    Navigator.pushReplacementNamed(context, CUSTOMER_ROUTE);
                  } else if (prefs.getString(PREF_EMAIL) != null &&
                      prefs.getString(PREF_USR_ROLE) == DRIVER_ROLE) {
                    Navigator.pushReplacementNamed(context, HOME_ROUTE);
                  } else if (prefs.getString(PREF_EMAIL) != null &&
                      prefs.getString(PREF_USR_ROLE) == MOTOR_RIDER_ROLE) {
                    Navigator.pushReplacementNamed(context, HOME_ROUTE);
                  } else if (prefs.getString(PREF_EMAIL) == null) {
                    Navigator.pushReplacementNamed(context, GET_STARTED);
                  }
                } else {
                  ref.read(userProvider).email = user.email;
                  ref.read(userProvider).userId = user.uid;
                  Navigator.pushReplacementNamed(context, USER_REGISTER);
                }
              } catch (e) {
                print(e);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Unknown error occured, try again"),
                ));
              }
            },
            label: "Sign in with google",
            width: sreenWidth * .8,
            showIcon: true,
            icon: FontAwesomeIcons.google,
          )
        ]),
      )),
    );
  }
}
