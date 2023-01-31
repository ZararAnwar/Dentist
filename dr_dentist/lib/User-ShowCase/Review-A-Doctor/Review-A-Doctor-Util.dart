
class ReviewAnDoctor {
  String id,userName,userId,doctorId,rating,review,userImage,dateTimeNow;

  ReviewAnDoctor({
    this.userId,
    this.id,
    this.userName,
    this.review,
    this.rating,
    this.doctorId,
    this.userImage,
    this.dateTimeNow,
  });

  Map<String, dynamic> toMap() {
    return {
      "Review": review,
      "Rating": rating,
      "UserName": userName,
      "UserId": userId,
      "DoctorId": doctorId,
      "UserImage": userImage,
      "DateTimeNow": dateTimeNow,
    };
  }

  factory ReviewAnDoctor.fromJson(Map<String, dynamic> json, String id) {
    return ReviewAnDoctor(
      review: json['Review'],
      rating: json['Rating'],
      userName: json['UserName'],
      userId: json['UserId'],
      doctorId: json['DoctorId'],
      userImage: json['UserImage'],
      dateTimeNow: json['DateTimeNow'],
      id: id,

    );
  }
}
