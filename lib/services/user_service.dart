import 'package:easylygo_app/models/UserModel.dart';
import 'package:easylygo_app/utils/firestore_util.dart';

class UserService {
  static Future<void> registerUser(UserModel userModel) async {
    await FirebaseUtil.collectionReferene("users").add(userModel.toJson());
  }

  static Future<UserModel> getCurrentUser(String email) async {
    await FirebaseUtil.initializeFirebase();
    final userSnapshoot = await FirebaseUtil.collectionReferene("users")
        .where("email", isEqualTo: email)
        .get();
    return UserModel.fromJson(userSnapshoot.docs[0].data());
  }
}
