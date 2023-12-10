import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easylygo_app/models/NotificationModel.dart';
import 'package:easylygo_app/utils/firestore_util.dart';
import 'package:uuid/uuid.dart';

class NotificationService {
  static Future<void> createNotification(String receiverId, dynamic dataObject,
      String title, String body, String notType) async {
    var uuid = const Uuid().v4();
    final notification = NotificationModel(
        title: title,
        body: body,
        notificationType: notType,
        notificationId: uuid,
        notificationData: dataObject);
    await FirebaseUtil.collectionReferene("users")
        .doc(receiverId)
        .collection("notifications")
        .add(notification.toJson());
  }

  static Stream<List<NotificationModel>> getNotificationList(String userDocId) {
    StreamController<List<NotificationModel>> controller =
        StreamController<List<NotificationModel>>();
  
      List<NotificationModel> notificationModels =[]; 
      FirebaseUtil.collectionReferene("users")
        .doc(userDocId)
        .collection("notifications")
        .snapshots()
        .listen((querySnapshot) {
     notificationModels=  querySnapshot.docs
          .map((doc)=>NotificationModel.fromJson(doc.data())).toList();
      controller.add(notificationModels);
    });

    return controller.stream;
  }

  static Stream<NotificationModel> getNotificationDetails(
      String userDocId, String notificationId) {
    print(
        'Params daata=> userId:$userDocId,===== NotificationId: $notificationId');
    StreamController<NotificationModel> controller =
        StreamController<NotificationModel>();

    FirebaseUtil.collectionReferene("users")
        .doc(userDocId)
        .collection("notifications")
        .doc(notificationId)
        .snapshots()
        .listen((querySnapshot) {
      NotificationModel notificationModel =
          NotificationModel.fromJson(querySnapshot.data());
      controller.add(notificationModel);
    });

    return controller.stream;
  }

  static Stream<int> getNotificationCount(String userDocId) {
    StreamController<int> controller = StreamController<int>();

    FirebaseUtil.collectionReferene("users")
        .doc(userDocId)
        .collection("notifications")
        .where('isOpened', isEqualTo: false)
        .snapshots()
        .listen((querySnapshot) {
      int notificationCount = querySnapshot.docs.length;
      controller.add(notificationCount);
    });
    return controller.stream;
  }

  static Future<void> updateOpenedStatus(
      NotificationModel notificationModel, String userDocId) async {
   QuerySnapshot notificationObjects= await FirebaseUtil.collectionReferene("users")
        .doc(userDocId)
        .collection("notifications")
        .where('notificationId',isEqualTo: notificationModel.notificationId)
        .get();

  await FirebaseUtil.collectionReferene("users")
        .doc(userDocId)
        .collection("notifications").doc(notificationObjects.docs[0].id).update({'isOpened':true});
  
  }
}
