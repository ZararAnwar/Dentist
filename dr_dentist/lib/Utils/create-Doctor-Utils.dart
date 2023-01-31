import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveImage1OfClinic(String image1, String image2) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString("ClinicImage1", image1 );
  pref.setString("ClinicImage2", image2 );
}


/// save clinic name address qual timing
Future<void> saveOtherData(String clinicName,String clinicAddress,
    String qualification,String openTime,String closeTime,String whatsAppLink,double longitude,double latitude,
    String experience,String responseTime,
    ) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString("ClinicName", clinicName );
  pref.setString("ClinicAddress", clinicAddress );
  pref.setString("Qualification", qualification);
  pref.setString("OpenTime", openTime);
  pref.setString("CloseTime", closeTime);
  pref.setString("WhatsAppLink", whatsAppLink);
  pref.setString("Experience", experience);
  pref.setString("ResponseTime", responseTime);
  pref.setDouble("Longitude", longitude);
  pref.setDouble("Latitude", latitude);
}