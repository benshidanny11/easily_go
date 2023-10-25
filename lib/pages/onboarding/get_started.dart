import 'package:easylygo_app/common/button_blue.dart';
import 'package:easylygo_app/common/colors.dart';
import 'package:easylygo_app/common/text_styles.dart';
import 'package:easylygo_app/constants/routes.dart';
import 'package:easylygo_app/strings/extracted.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GettingStarted extends ConsumerWidget {
  const GettingStarted({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(),
          Column(
            children: [
              Image.asset('assets/images/app_logo_blue.png'),
              Text(
                'Easily Go',
                style: textStyleBlue(17),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                ButtonBlue(
                  onPress: () {
                    Navigator.pushNamed(context, SIGN_UP);
                  },
                  label: "Get started",
                  width: 320,
                ),
                const SizedBox(height:10),
                GestureDetector(
                  onTap: () {
                   USER_MODE="DRIVER_MOTOR_RIDER_MODE";
                   Navigator.pushNamed(context, SIGN_UP);
                  },
                  child: Text(
                    'Ready to earn more? Start as Driver or Motor rider',
                    style: textStyleBlue(16).copyWith(
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.mainColor,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
