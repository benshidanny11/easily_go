import 'package:easylygo_app/common/colors.dart';
import 'package:easylygo_app/common/widgets.dart';
import 'package:easylygo_app/pages/drivers/home.dart';
import 'package:easylygo_app/pages/drivers/wallet.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> _pages = [HomeActivities(), WalletPage()];
  int index = 0;
  bool isOnline = false;
  String onLineStatus = 'You are online';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidgets.customAppBar("Easily Go"),
      drawer: CommonWidgets.appDrawer((value) {
        setState(() {
          setState(() {
            isOnline = value;
            onLineStatus = value ? "You are online" : "You are offline";
          });
        });
      }, context, onLineStatus, isOnline),
      body: _pages[index],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.wallet), label: "Wallet")
        ],
        onTap: (value) {
          setState(() {
            index = value;
          });
        },
        currentIndex: index,
        selectedItemColor: AppColors.mainColor,
      ),
    );
  }
}
