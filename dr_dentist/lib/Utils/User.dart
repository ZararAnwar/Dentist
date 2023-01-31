class Userr {
  String name, image, userId,email,mainValue,
      doctorClinicAddress,doctorWhatsapp,clinicImage1,
      clinicImage2,clinicName,closeTime,openTime,fcmToken,mobile,qualification,address,responseTime,experience;

  double longitude,latitude;
  Userr({
    this.image,
    this.name,
    this.userId,
    this.email,
    this.mainValue,
    this.clinicImage1,
    this.clinicImage2,
  this.doctorClinicAddress,
    this.clinicName,
    this.doctorWhatsapp,
    this.closeTime,
    this.openTime,
    this.fcmToken,
    this.mobile,
    this.qualification,
    this.latitude,
    this.longitude,
    this.address,
    this.responseTime,
    this.experience,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      "image": image,
      "userId": userId,
      "email": email,
      "mainValue": mainValue,
      "ClinicAddress": doctorClinicAddress,
      "ClinicName": clinicName,
      "mobile": mobile,
      "fcm_token": fcmToken,
      "WhatsAppLink": doctorWhatsapp,
      "CloseTime": closeTime,
      "OpenTime": openTime,
      "Qualification": qualification,
      "ClinicImage1": clinicImage1,
      "ClinicImage2": clinicImage2,
      "Longitude": longitude,
      "Latitude": latitude,
      "address": address,
      "Experience": experience,
      "ResponseTime": responseTime,
    };
  }

  factory Userr.fromJson(Map<String, dynamic> json) {
    return Userr(
      name: json['name'],
      image: json['image'],
      userId: json['userId'],
      email: json['email'],
      mainValue: json['mainValue'],
      doctorClinicAddress: json['ClinicAddress'],
      clinicName: json['ClinicName'],
      mobile: json['mobile'],
      fcmToken: json['fcm_token'],
      doctorWhatsapp: json['WhatsAppLink'],
      closeTime: json['CloseTime'],
      openTime: json['OpenTime'],
      qualification: json['Qualification'],
      clinicImage1: json['ClinicImage1'],
      clinicImage2: json['ClinicImage2'],
      longitude: json['Longitude'],
      latitude: json['Latitude'],
      address: json['address'],
      experience: json['Experience'],
      responseTime: json['ResponseTime'],
    );
  }
}
