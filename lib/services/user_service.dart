import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easylygo_app/constants/string_constants.dart';
import 'package:easylygo_app/models/LocationModel.dart';
import 'package:easylygo_app/models/UserModel.dart';
import 'package:easylygo_app/models/wallet.dart';
import 'package:easylygo_app/utils/firestore_util.dart';
import 'package:easylygo_app/utils/image_util.dart';
import 'package:easylygo_app/utils/location_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class UserService {
  static Future<void> registerUser(UserModel userModel) async {
   DocumentReference docRef= await FirebaseUtil.collectionReferene("users").add(userModel.toJson());
   String docId=docRef.id;
  await docRef.update({'docId': docId});
     if(userModel.userRole==DRIVER_ROLE || userModel.userRole == MOTOR_RIDER_ROLE){
     var uuid = const Uuid().v4();
    Wallet wallet=Wallet(id: uuid, balance: 0.0, driverId: userModel.userId.toString(), transactions: []);
    await FirebaseUtil.collectionReferene("wallets").add(wallet.toJson());
   }
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

static Future<String> updateUserProfileImage(UserModel userModel) async{
 
if(userModel.imageUrl!=null && userModel.imageUrl!.isNotEmpty){
 await FirebaseStorage.instance.refFromURL(userModel.imageUrl.toString()).delete();
}
 XFile? image=await ImageUtil.pickGalleryImage();
String imageUrl = await ImageUtil.uploadImage("userimages", image!);
userModel.imageUrl=imageUrl;

    QuerySnapshot snapshot = await FirebaseUtil.collectionReferene('users')
        .where('userId', isEqualTo: userModel.userId)
        .get();
    if (snapshot.docs.isNotEmpty) {
      await FirebaseUtil.collectionReferene('users')
          .doc(snapshot.docs[0].id)
          .update(userModel.toJson());
    }
    return imageUrl;
}

static Future<void> updateUserProfileInfo(UserModel userModel) async{

  print("User home addreess<<<<<>>>>>>>>>: ${userModel.homeAddress}");
    QuerySnapshot snapshot = await FirebaseUtil.collectionReferene('users')
        .where('userId', isEqualTo: userModel.userId)
        .get();
    if (snapshot.docs.isNotEmpty) {
      await FirebaseUtil.collectionReferene('users')
          .doc(snapshot.docs[0].id)
          .update(userModel.toJson());
    }
}

static Future<void> updateUserToken(String userId, String token) async{

    QuerySnapshot snapshot = await FirebaseUtil.collectionReferene('users')
        .where('userId', isEqualTo: userId)
        .get();
    if (snapshot.docs.isNotEmpty) {
      await FirebaseUtil.collectionReferene('users')
          .doc(snapshot.docs[0].id)
          .set({"deviceToken": token}, SetOptions(merge: true));
    }
}
}
