import 'package:easylygo_app/common/colors.dart';
import 'package:easylygo_app/common/widgets.dart';
import 'package:easylygo_app/constants/routes.dart';
import 'package:easylygo_app/pages/drivers/home.dart';
import 'package:easylygo_app/pages/drivers/wallet.dart';
import 'package:easylygo_app/providers/app_provider.dart';
import 'package:easylygo_app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:badges/badges.dart' as badges;

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final List<Widget> _pages = [const HomeActivities(), const WalletPage()];
  
  int index = 0;
  bool isOnline = false;
  String onLineStatus = 'You are offline';
  
  @override
  Widget build(BuildContext context) {
    final user=ref.read(userProvider);
    onLineStatus = user.status=='active' ? "You are online" : "You are offline";
    return Scaffold(
      appBar: AppBar(
      title:const Text(
        'Easily Go',
        style: TextStyle(color: AppColors.mainColor),
      ),
      actions: [
        badges.Badge(
          position: badges.BadgePosition.topEnd(top: 5, end: 7),
          badgeStyle: const badges.BadgeStyle(
              badgeColor: AppColors.mainColor, padding: EdgeInsets.all(3)),
          badgeContent: CommonWidgets.getNotificationCount(user.docId.toString()),
          child: IconButton(
            icon: const Icon(
              Icons.notifications,
              size: 30,
            ),
            onPressed: () {
              print("Icon clicked");
            Navigator.pushNamed(context,NOTIFICATIONS_LIST_PAGE);
            //   Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(builder: (context) => HomePage()),
            // );
            },
          ),
        ),
      ],
      elevation: 1,
    ),
      drawer: CommonWidgets.appDrawer((value) async{
         user.status=value? 'active':'offline';
         await UserService.setUserActive(user);
          setState(() {
            isOnline = value;
            onLineStatus = user.status=='active' ? "You are online" : "You are offline";
          });
      }, context, onLineStatus, isOnline, user),
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
