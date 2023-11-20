import 'package:easylygo_app/items/item_user.dart';
import 'package:easylygo_app/models/UserModel.dart';
import 'package:flutter/material.dart';

class CommonUserProfile extends StatelessWidget {
  final List<UserModel> joinedPassengers;
  const CommonUserProfile({super.key, required this.joinedPassengers});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.0 * joinedPassengers.length,
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return UserItem(userModel: joinedPassengers[index]);
        },
        itemCount: joinedPassengers.length,
      ),
    );
  }
}
