
class SendAppointmentRequest {
  String id,userName,userId,doctorId,userImage,dateTimeNow,
      request,requestStatus,fcmTokenOfDoctor,fcmTokenOfUser,
  doctorName,doctorImage,doctorQualification,doctorClinicAddress;

  SendAppointmentRequest({
    this.userId,
    this.id,
    this.userName,
    this.request,
    this.doctorId,
    this.userImage,
    this.dateTimeNow,
    this.fcmTokenOfDoctor,
    this.requestStatus,
    this.fcmTokenOfUser,
    this.doctorClinicAddress,
    this.doctorImage,
    this.doctorName,
    this.doctorQualification,
  });

  Map<String, dynamic> toMap() {
    return {
      "Request": request,
      "UserName": userName,
      "UserId": userId,
      "DoctorId": doctorId,
      "UserImage": userImage,
      "DateTimeNow": dateTimeNow,
      "FCMTokenOfDoctor": fcmTokenOfDoctor,
      "RequestStatus": requestStatus,
      "FCMTokenOfUser": fcmTokenOfUser,
      "DoctorClinicAddress": doctorClinicAddress,
      "DoctorQualification": doctorQualification,
      "DoctorName": doctorName,
      "DoctorImage": doctorImage,
    };
  }

  factory SendAppointmentRequest.fromJson(Map<String, dynamic> json, String id) {
    return SendAppointmentRequest(
      request: json['Request'],
      userName: json['UserName'],
      userId: json['UserId'],
      doctorId: json['DoctorId'],
      userImage: json['UserImage'],
      dateTimeNow: json['DateTimeNow'],
      fcmTokenOfDoctor: json['FCMTokenOfDoctor'],
      requestStatus: json['RequestStatus'],
      fcmTokenOfUser: json['FCMTokenOfUser'],
      doctorQualification: json['DoctorQualification'],
      doctorImage: json['DoctorImage'],
      doctorName: json['DoctorName'],
      doctorClinicAddress: json['DoctorClinicAddress'],
      id: id,

    );
  }
}
