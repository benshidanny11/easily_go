import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easylygo_app/models/LocationModel.dart';
import 'package:easylygo_app/models/UserModel.dart';
import 'package:easylygo_app/utils/firestore_util.dart';
import 'package:easylygo_app/utils/location_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static Future<void> registerUser(UserModel userModel) async {
    await FirebaseUtil.collectionReferene("users").add(userModel.toJson());
  }

  static Future<UserModel?> getCurrentUser(String email) async {
    await FirebaseUtil.initializeFirebase();
    final userSnapshoot = await FirebaseUtil.collectionReferene("users")
        .where("email", isEqualTo: email)
        .get();
    return userSnapshoot.docs.isNotEmpty
        ? UserModel.fromJson(userSnapshoot.docs[0].data())
        : null;
  }

  static Future<bool> checkUserExists(String email) async {
    await FirebaseUtil.initializeFirebase();
    final userSnapshoot = await FirebaseUtil.collectionReferene("users")
        .where("email", isEqualTo: email)
        .get();
    return userSnapshoot.docs.isNotEmpty;
  }

  static Future<void> setUserActive(UserModel userModel) async {
    //
    LocationData locationData =
        await LocationUtil.getCurrentLocationData() as LocationData;
    LocationModel locationModel = LocationModel(
        latitude: locationData.latitude, longitude: locationData.longitude);
    userModel.location = locationModel;
    QuerySnapshot snapshot = await FirebaseUtil.collectionReferene('users')
        .where('userId', isEqualTo: userModel.userId)
        .get();
    if (snapshot.docs.isNotEmpty) {
      await FirebaseUtil.collectionReferene('users')
          .doc(snapshot.docs[0].id)
          .update(userModel.toJson());
    }
  }

  static Future<void> signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    await FirebaseAuth.instance.signOut();
  }

  static Stream<List<UserModel>> getActiveUsers() {
    StreamController<List<UserModel>> controller =
        StreamController<List<UserModel>>();
    FirebaseUtil.initializeFirebase().then((value) {
      FirebaseUtil.collectionReferene("users")
          .where("userRole", isNotEqualTo: 'Customer')
          .where("status", isEqualTo: 'active')
          .snapshots()
          .listen((querySnapshot) {
        List<UserModel> activeUsers = querySnapshot.docs
            .map((doc) => UserModel.fromJson(doc.data()))
            .toList();
        controller.add(activeUsers);
      }, onError: (error) {
        controller.addError(error);
      });
    });
    return controller.stream;
  }

  
}
