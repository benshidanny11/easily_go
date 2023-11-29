import 'dart:async';

import 'package:easylygo_app/models/NotificationModel.dart';
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

     static Stream<List<NotificationModel>> getNotificationList(String userDocId) {
   StreamController<List<NotificationModel>> controller =
        StreamController<List<NotificationModel>>();

     FirebaseUtil.collectionReferene("users")
        .doc(userDocId)
        .collection("notifications").snapshots().listen((querySnapshot) {
            List<NotificationModel> notificationModels = querySnapshot.docs
            .map((doc) => NotificationModel.fromJson(doc.data()),).toList();
           controller.add(notificationModels);
        });

     return controller.stream;
  }

  

   static Stream<NotificationModel> getNotificationDetails(String userDocId,String notificationId) {
    print('Params daata=> userId:$userDocId,===== NotificationId: $notificationId');
   StreamController<NotificationModel> controller =
        StreamController<NotificationModel>();

     FirebaseUtil.collectionReferene("users")
        .doc(userDocId)
        .collection("notifications").doc(notificationId).snapshots().listen((querySnapshot) {
            NotificationModel notificationModel = NotificationModel.fromJson(querySnapshot.data());
           controller.add(notificationModel);
        });

     return controller.stream;
  }

  static Stream<int> getNotificationCount(String userDocId) {
   StreamController<int> controller =
        StreamController<int>();

     FirebaseUtil.collectionReferene("users")
        .doc(userDocId)
        .collection("notifications").snapshots().listen((querySnapshot) {
            int notificationCount = querySnapshot.docs.length;
           controller.add(notificationCount);
        });
     return controller.stream;
  }

 
}
