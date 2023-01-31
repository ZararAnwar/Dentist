import 'package:flutter/material.dart';


class CreateStory {
  String id,doctorName,doctorId,image,description,dateTimeNow;

  CreateStory({
    this.id,
    this.doctorName,
  this.image,
  this.doctorId,
  this.description,
    this.dateTimeNow,
  });

  Map<String, dynamic> toMap() {
    return {
      "DoctorName": doctorName,
      "DoctorId": doctorId,
      "StoryImage": image,
      "Description": description,
      "DateTimeNow": dateTimeNow,
    };
  }

  factory CreateStory.fromJson(Map<String, dynamic> json, String id) {
    return CreateStory(
      doctorId: json['DoctorId'],
      doctorName: json['DoctorName'],
      image: json['StoryImage'],
      description: json['Description'],
      dateTimeNow: json['DateTimeNow'],
      id: id,

    );
  }
}
