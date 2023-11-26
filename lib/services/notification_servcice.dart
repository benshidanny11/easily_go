import 'package:easylygo_app/models/NotificationModel.dart';
import 'package:easylygo_app/models/UserModel.dart';
import 'package:easylygo_app/utils/firestore_util.dart';

class NotificationService {
  static Future<void> createNotification(
      String receiverId, dynamic dataObject, String title, String body) async {
    final notification = NotificationModel(
        title: title,
        body: body,
        notificationData: dataObject);
    await FirebaseUtil.collectionReferene("users")
        .doc(receiverId)
        .collection("notifications")
        .add(notification.toJson());
  }
}
