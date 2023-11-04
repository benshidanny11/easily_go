import 'package:easylygo_app/common/colors.dart';
import 'package:easylygo_app/constants/routes.dart';
import 'package:easylygo_app/pages/customers/customer_home.dart';
import 'package:easylygo_app/pages/customers/customer_trip_request.dart';
import 'package:easylygo_app/pages/drivers/create_jorney.dart';
import 'package:easylygo_app/pages/drivers/home_layoout.dart';
import 'package:easylygo_app/pages/drivers/view_driver_journey.dart';
import 'package:easylygo_app/pages/drivers/view_driver_trip_request.dart';
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.mainColor),
        useMaterial3: true,
        fontFamily: 'Poppins-Regular.ttf'
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: SPLASH_SCREEN,
      routes: {
        HOME_ROUTE:(context) =>  HomePage(),
        SPLASH_SCREEN:(context) => const SplashScreen(),
        GET_STARTED:(context) =>const GettingStarted(),
        SIGN_UP:(context) => const Signup(),
        USER_REGISTER:(context) =>const UserRegister(),
        TERMS_AND_CONDITION:(context) => const TermsAndConditions(),
        CUSTOMER_ROUTE:(context) =>const CustomerHomePage(),
        CREATE_JORNEY:(context) =>const CreateJourney(),
        CUSTOMER_TRIP_REQUEST:(context) => CustomerTripRequest(),
        VIEW_DRIVER_JOURNEY_DETAILS:(context) => ViewDriverJourney(),
        VIEW_TRIP_REQUEST_DETAILS:(context) => ViewDriverTripRequest()
      },
    );
  }
}

