class NotificationModel {
  String title;
  String body;
  String notificationType;
  bool isOpened;
  String notificationId;
  dynamic notificationData;
  NotificationModel(
      {required this.title,
      required this.body,
      required this.notificationType,
      required this.notificationData,
      required this.notificationId,
      this.isOpened=false});

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'notificationType': notificationType,
      'isOpened':isOpened,
      'notificationData': notificationData.toJson(),
      'notificationId':notificationId
    };
  }

  factory NotificationModel.fromJson(dynamic json) {
    return NotificationModel(
        title: json['title'],
        body: json['body'],
        notificationType: json['notificationType'],
        isOpened:json['isOpened'],
        notificationData: json['notificationData'],
        notificationId: json['notificationId']);
  }
}
