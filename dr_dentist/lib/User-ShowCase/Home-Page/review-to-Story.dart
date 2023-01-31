import 'package:flutter/material.dart';


class ReviewToDoctorStory {
  String id,
      review,
      userName,
      userId,
      userImage,
      doctorId,
  dateTimeNow,
  storyImage;

  ReviewToDoctorStory({
    this.userImage,
    this.userName,
    this.id,
    this.userId,
    this.review,
    this.doctorId,
    this.storyImage,
    this.dateTimeNow,
  });

  Map<String, dynamic> toMap() {
    return {
      "Review": review,
      "UserName": userName,
      "userId": userId,
      "UserImage": userImage,
      "DoctorId": doctorId,
      "StoryImage": storyImage,
      "DateTimeNow": dateTimeNow,
    };
  }

  factory ReviewToDoctorStory.fromJson(Map<String, dynamic> json, String id) {
    return ReviewToDoctorStory(
      review: json['Review'],
      userName: json['UserName'],
      userId: json['userId'],
      userImage: json['UserImage'],
      doctorId: json['DoctorId'],
      storyImage: json['StoryImage'],
      dateTimeNow: json['StoryImage'],
      id: id,

    );
  }
}
