import 'package:easylygo_app/items/item_user.dart';
import 'package:easylygo_app/models/UserModel.dart';
import 'package:flutter/material.dart';

class ViewJoinedPassengers extends StatefulWidget {
  final List<UserModel> joinedPassengers;
  const ViewJoinedPassengers({super.key, required this.joinedPassengers});

  @override
  State<ViewJoinedPassengers> createState() => _ViewJoinedPassengersState();
}

class _ViewJoinedPassengersState extends State<ViewJoinedPassengers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Easily Go'),
        elevation: 1,
      ),
      body: SizedBox(
        height: 70.0 * widget.joinedPassengers.length,
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return UserItem(userModel: widget.joinedPassengers[index]);
          },
          itemCount: widget.joinedPassengers.length,
        ),
      ),
    );
  }
}
