import 'package:easylygo_app/common/colors.dart';
import 'package:easylygo_app/common/widgets.dart';
import 'package:easylygo_app/pages/drivers/home.dart';
import 'package:easylygo_app/pages/drivers/wallet.dart';
import 'package:easylygo_app/providers/app_provider.dart';
import 'package:easylygo_app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends ConsumerStatefulWidget {
  HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final List<Widget> _pages = [HomeActivities(), WalletPage()];
  
  int index = 0;
  bool isOnline = false;
  String onLineStatus = 'You are offline';
  
  @override
  Widget build(BuildContext context) {
    final user=ref.read(userProvider);
    onLineStatus = user.status=='active' ? "You are online" : "You are offline";
    return Scaffold(
      appBar: CommonWidgets.customAppBar("Easily Go"),
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
