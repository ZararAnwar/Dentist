class NotificationModel {
  String title, message, userId;

  NotificationModel({
    this.title,
    this.message,
    this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      "message": message,
      "userId": userId,
    };
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json, String id) {
    return NotificationModel(
      title: json['title'],
      message: json['message'],
      userId: json['userId'],
    );
  }
}
