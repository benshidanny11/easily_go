import 'package:easylygo_app/common/colors.dart';
import 'package:easylygo_app/constants/routes.dart';
import 'package:easylygo_app/constants/string_constants.dart';
import 'package:easylygo_app/models/UserModel.dart';
import 'package:easylygo_app/providers/app_provider.dart';
import 'package:easylygo_app/services/user_service.dart';
import 'package:easylygo_app/utils/user_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3)).then((value) {
      SharedPreferences.getInstance().then((prefs) {
        print(
            '${prefs.getString(PREF_EMAIL)} +++++ ${prefs.getString(PREF_USR_ROLE)}');
        if (prefs.getString(PREF_EMAIL) != null &&
            prefs.getString(PREF_USR_ROLE) == CUSTOMER_ROLE) {
          UserService.getCurrentUser(prefs.getString(PREF_EMAIL) as String)
              .then((user) {
            UserUtil.getUserProvier(user, ref);
            Navigator.pushReplacementNamed(context, CUSTOMER_ROUTE);
          });
        } else if (prefs.getString(PREF_EMAIL) != null &&
            prefs.getString(PREF_USR_ROLE) == DRIVER_ROLE) {
          UserService.getCurrentUser(prefs.getString(PREF_EMAIL) as String)
              .then((user) {
            UserUtil.getUserProvier(user, ref);
          });
        } else if (prefs.getString(PREF_EMAIL) != null &&
            prefs.getString(PREF_USR_ROLE) == MOTOR_RIDER_ROLE) {
          UserService.getCurrentUser(prefs.getString(PREF_EMAIL) as String)
              .then((user) {
            UserUtil.getUserProvier(user, ref);

            Navigator.pushReplacementNamed(context, HOME_ROUTE);
          });
        } else if (prefs.getString(PREF_EMAIL) == null) {
          Navigator.pushReplacementNamed(context, GET_STARTED);
        }
      }).catchError((error) {
        print(error);
        Navigator.pushReplacementNamed(context, GET_STARTED);
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: Center(
        child: Image.asset('assets/images/app_icon1.png'),
      ),
    );
  }
}
