class NotificationModel {
  String title;
  String body;
  dynamic notificationData;
  NotificationModel(
      {required this.title,
      required this.body,
      required this.notificationData});

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'notificationData': notificationData.toJson(),
    };
  }

  factory NotificationModel.fromJson(dynamic json) {
    return NotificationModel(
        title: json['title'],
        body: json['body'],
        notificationData: json['notificationData']);
  }
}
