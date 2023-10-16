import 'package:easylygo_app/common/colors.dart';
import 'package:easylygo_app/constants/routes.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

 @override
  void initState() {
      Future.delayed(const Duration(seconds: 5)).then((value) => Navigator.pushReplacementNamed(context, GET_STARTED));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: AppColors.mainColor ,
      body: Center(
        child: Image.asset('assets/images/app_icon1.png'),
      ),
    );
  }
}