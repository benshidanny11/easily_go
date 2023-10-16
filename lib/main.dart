import 'package:easylygo_app/common/colors.dart';
import 'package:easylygo_app/constants/routes.dart';
import 'package:easylygo_app/pages/home.dart';
import 'package:easylygo_app/pages/onboarding/get_started.dart';
import 'package:easylygo_app/pages/onboarding/signup.dart';
import 'package:easylygo_app/pages/onboarding/splash_screen.dart';
import 'package:easylygo_app/pages/onboarding/terms_and_conditions.dart';
import 'package:easylygo_app/pages/onboarding/user_register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
//background: rgba(27, 117, 188, 1);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.mainColor),
        useMaterial3: true,
        fontFamily: 'Poppins-Regular.ttf'
      ),
      initialRoute: SPLASH_SCREEN,
      routes: {
        HOME_ROUTE:(context) => const HomePage(),
        SPLASH_SCREEN:(context) => const SplashScreen(),
        GET_STARTED:(context) =>const GettingStarted(),
        SIGN_UP:(context) => const Signup(),
        USER_REGISTER:(context) =>const UserRegister(),
        TERMS_AND_CONDITION:(context) => const TermsAndConditions(),
      },
    );
  }
}

