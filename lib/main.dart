import 'package:easylygo_app/common/colors.dart';
import 'package:easylygo_app/common/search_places.dart';
import 'package:easylygo_app/constants/routes.dart';
import 'package:easylygo_app/firebase_options.dart';
import 'package:easylygo_app/pages/customers/customer_home.dart';
import 'package:easylygo_app/pages/customers/customer_posted_journeys.dart';
import 'package:easylygo_app/pages/customers/trip_management.dart';
import 'package:easylygo_app/pages/customers/view_customer_posted_journey.dart';
import 'package:easylygo_app/pages/customers/view_customer_trip_request.dart';
import 'package:easylygo_app/pages/drivers/create_journey.dart';
import 'package:easylygo_app/pages/drivers/home_layoout.dart';
import 'package:easylygo_app/pages/drivers/view_driver_journey.dart';
import 'package:easylygo_app/pages/drivers/view_driver_trip_request.dart';
import 'package:easylygo_app/pages/notifications/notification_list.dart';
import 'package:easylygo_app/pages/notifications/notification_page.dart';
import 'package:easylygo_app/pages/onboarding/get_started.dart';
import 'package:easylygo_app/pages/onboarding/signup.dart';
import 'package:easylygo_app/pages/onboarding/splash_screen.dart';
import 'package:easylygo_app/pages/onboarding/terms_and_conditions.dart';
import 'package:easylygo_app/pages/onboarding/user_register.dart';
import 'package:easylygo_app/pages/user/user_profile.dart';
import 'package:easylygo_app/utils/notification_util.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final navigatorKey=GlobalKey<NavigatorState>();

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationUtil.initNotification();
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
      navigatorKey: navigatorKey,
      routes: {
        HOME_ROUTE:(context) =>  const HomePage(),
        SPLASH_SCREEN:(context) => const SplashScreen(),
        GET_STARTED:(context) =>const GettingStarted(),
        SIGN_UP:(context) => const Signup(),
        USER_REGISTER:(context) =>const UserRegister(),
        TERMS_AND_CONDITION:(context) => const TermsAndConditions(),
        CUSTOMER_ROUTE:(context) =>const CustomerHomePage(),
        CREATE_JORNEY:(context) =>const CreateJourney(),
        CUSTOMER_TRIP_REQUEST:(context) => const CustomerTripManagement(),
        VIEW_DRIVER_JOURNEY_DETAILS:(context) => const ViewDriverJourney(),
        VIEW_TRIP_REQUEST_DETAILS:(context) => const ViewDriverTripRequest(),
        CUSTOMER_POSTED_JOURNEYS:(context) => const CustomerPostedJourneys(),
        CUSTOMER_POSTED_JOURNEY_DETAILS:(context) => const ViewCustomerPostedJourney(),
        CUSTOMER_TRIP_REQUEST_DETAILS:(context) => const ViewCustomerTripRequest(),
        SEARCH_PLACES:(context) => const SearchPlases(),
        USER_PROFILE:(context) => const UserProfile (),
        NOTIFICATION_PAGE:(context) => const NotificationPage(),
        NOTIFICATIONS_LIST_PAGE:(context) => const NotificationsList()
      },
    );
  }
}

