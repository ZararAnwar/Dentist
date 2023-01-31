class NotificationRequest {
  NotificationRequest({
    this.to,
    this.notification,
  });

  String to;
  NotificationModelOne notification;

  factory NotificationRequest.fromJson(Map<String, dynamic> json) =>
      NotificationRequest(
        to: json["to"] == null ? null : json["to"],
        notification: json["notification"] == null
            ? null
            : NotificationModelOne.fromJson(json["notification"]),
      );

  Map<String, dynamic> toJson() => {
    "to": to == null ? null : to,
    "notification": notification == null ? null : notification.toJson(),
  };
}

class NotificationModelOne {
  NotificationModelOne({
    this.title,
    this.body,
  });

  String title;
  String body;

  factory NotificationModelOne.fromJson(Map<String, dynamic> json) =>
      NotificationModelOne(
        title: json["title"] == null ? null : json["title"],
        body: json["body"] == null ? null : json["body"],
      );

  Map<String, dynamic> toJson() => {
    "title": title == null ? null : title,
    "body": body == null ? null : body,
  };
}
