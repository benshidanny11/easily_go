

import 'package:easylygo_app/models/UserModel.dart';
import 'package:easylygo_app/utils/firestore_util.dart';

class UserService{

  static Future<void> registerUser(UserModel userModel) async{
    await FirebaseUtil.collectionReferene("users").add(userModel.toJson());
  }
}