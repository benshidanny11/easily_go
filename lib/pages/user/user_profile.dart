import 'package:easylygo_app/common/colors.dart';
import 'package:easylygo_app/common/text_styles.dart';
import 'package:easylygo_app/common/widgets.dart';
import 'package:easylygo_app/constants/routes.dart';
import 'package:easylygo_app/constants/string_constants.dart';
import 'package:easylygo_app/models/Journey.dart';
import 'package:easylygo_app/pages/drivers/view_joined_passengers.dart';
import 'package:easylygo_app/pages/user/edit_user_profile.dart';
import 'package:easylygo_app/providers/app_provider.dart';
import 'package:easylygo_app/services/journey_service.dart';
import 'package:easylygo_app/services/user_service.dart';
import 'package:easylygo_app/utils/alert_util.dart';
import 'package:easylygo_app/utils/date_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserProfile extends ConsumerStatefulWidget {
  const UserProfile({super.key});

  @override
  ConsumerState<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends ConsumerState<UserProfile> {
  @override
  Widget build(BuildContext context) {
    final user = ref.read(userProvider);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Easily go'),
          elevation: 1,
        ),
        body: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    color: AppColors.colorBackGroundLight,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Column(
                  children: [
                    Container(
                      width: 120,
                      child: Stack(children: [
                        Container(),
                        Positioned(
                          child: (user.imageUrl != null && user.imageUrl != '')
                              ? CircleAvatar(
                                  radius: 50,
                                  backgroundImage:
                                      NetworkImage(user.imageUrl.toString()),
                                )
                              : const CircleAvatar(
                                  radius: 50,
                                  backgroundImage: AssetImage(
                                      'assets/images/user_avatar.png'),
                                ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 2,
                          child: GestureDetector(
                            onTap: () async {
                              AlertUtil.showLoadingAlertDialig(
                                  context, "Updating profile image", false);
                              String imageUrl =
                                  await UserService.updateUserProfileImage(
                                      user);
                              ref.read(userProvider).imageUrl = imageUrl;
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.edit,
                              color: AppColors.mainColor,
                            ),
                          ),
                        ),
                      ]),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CommonWidgets.customDivider(),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.account_box,
                          color: AppColors.mainColor,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Name'),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(user.fullName.toString()),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.phone,
                          color: AppColors.mainColor,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Phone number'),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(user.phoneNumber.toString()),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.email,
                          color: AppColors.mainColor,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Email'),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(user.email.toString()),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.account_box,
                          color: AppColors.mainColor,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Role'),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(user.userRole.toString()),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: AppColors.mainColor,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Home address'),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(user.homeAddress.toString()),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CommonWidgets.buttonBlueRounded(
                      onPressed: () {
                           Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditUserProfile(
                                    userModel: user,
                                  )),
                        );
                       // Navigator.pushNamed(context, EDIT_USER_PROFILE);
                      },
                      label: 'Update profile',
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
