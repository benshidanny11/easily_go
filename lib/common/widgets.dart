import 'package:easylygo_app/common/colors.dart';
import 'package:easylygo_app/common/text_styles.dart';
import 'package:easylygo_app/constants/routes.dart';
import 'package:easylygo_app/models/UserModel.dart';
import 'package:easylygo_app/services/notification_servcice.dart';
import 'package:easylygo_app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CommonWidgets {
  static TextButton buttonBlueRounded({
    onPressed,
    label,
  }) {
    return TextButton(onPressed: onPressed, child: Text(label));
  }

  static AppBar customAppBar(String title, BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(color: AppColors.mainColor),
      ),
      actions: [
        badges.Badge(
          position: badges.BadgePosition.topEnd(top: 5, end: 7),
          badgeStyle: const badges.BadgeStyle(
              badgeColor: AppColors.mainColor, padding: EdgeInsets.all(3)),
          badgeContent: const Text(
            '10',
            style: TextStyle(color: Colors.white, fontSize: 13),
          ),
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
    );
  }

  static Drawer appDrawer(Function(bool value) onChanged, BuildContext context,
      String onLineStatus, bool isOnline, UserModel userModel) {
    return Drawer(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                       (userModel.imageUrl != null && userModel.imageUrl != '')
                              ? CircleAvatar(
                                  radius: 30,
                                  backgroundImage:
                                      NetworkImage(userModel.imageUrl.toString()),
                                )
                              : const CircleAvatar(
                                  radius: 30,
                                  backgroundImage: AssetImage(
                                      'assets/images/user_avatar.png'),
                                ),
                        Text(
                          userModel.fullName.toString(),
                          style: textStyleTitle(13),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text(onLineStatus),
                        Switch(
                          trackColor: MaterialStateProperty.all(
                              const Color.fromARGB(96, 234, 234, 234)),
                          activeColor:
                              const Color.fromARGB(255, 2, 170, 7).withOpacity(0.4),
                          inactiveThumbColor: const Color.fromARGB(255, 201, 111, 42)
                              .withOpacity(0.4),
                          value: userModel.status == 'active' ? true : false,
                          onChanged: onChanged,
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
          ListTile(
            iconColor: AppColors.mainColor,
            textColor: AppColors.mainColor,
            leading: const Icon(
              FontAwesomeIcons.road,
              size: 25,
            ),
            title: const Text('My trips'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            iconColor: AppColors.mainColor,
            textColor: AppColors.mainColor,
            leading: const Icon(
              FontAwesomeIcons.wallet,
              size: 25,
            ),
            title: const Text('Wallet'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            iconColor: AppColors.mainColor,
            textColor: AppColors.mainColor,
            leading: const Icon(
              Icons.account_box,
              size: 25,
            ),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pushNamed(context, USER_PROFILE);
            },
          ),
          ListTile(
            iconColor: AppColors.mainColor,
            textColor: AppColors.mainColor,
            leading: const Icon(
              Icons.logout,
              size: 25,
            ),
            title: const Text('Logout'),
            onTap: () async {
              await UserService.signOut();
              Navigator.pushReplacementNamed(context, GET_STARTED);
            },
          ),
        ],
      ),
    );
  }

  static Divider customDivider() {
    return const Divider(
      height: 0.5,
      color: Color.fromARGB(255, 220, 220, 220),
    );
  }

  static SizedBox customVerticalDivider() {
    return SizedBox(
      height: 20,
      width: 2,
      child: Container(
        color: const Color.fromARGB(255, 229, 229, 229),
      ),
    );
  }

  static Container tag(Color color, String label) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(13)),
        color: color,
      ),
      padding: const EdgeInsets.only(left: 5, right: 5, top: 0, bottom: 3),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 10),
      ),
    );
  }

  static Widget journeySeachingState({required Function onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Filtered journeys",
          style: textStyleContentSmall(14),
          textAlign: TextAlign.start,
        ),
        GestureDetector(
            onTap: () {
              onTap();
            },
            child: const Icon(Icons.cancel, color: AppColors.colorError))
      ],
    );
  }

  static Widget getNotificationCount(String userId){
    return StreamBuilder<int>(stream: NotificationService.getNotificationCount(userId),builder:  (context, snapshot){
      if(snapshot.connectionState==ConnectionState.waiting){
        return const SizedBox(width: 10, height: 10, child:  CircularProgressIndicator());
      }
       if(snapshot.hasError){
        return const Text('');
      }
      int notificationCount=snapshot.data as int;
      return Text(notificationCount>0?notificationCount.toString():'', style: const TextStyle(color: Colors.white, fontSize: 13));
    });
  }
}
