import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveData(Map<String, dynamic> data) async {
  SharedPreferences pref = await SharedPreferences.getInstance();

  print("I'm Here to save data");

  pref.setBool("user", true);
  pref.setString("userId", data['userId']);
  pref.setString("image", data['image']);
  pref.setString("name", data['name']);
  pref.setString("address", data['address']);
  pref.setString("email", data['email']);
  pref.setString("password", data['password']);
  pref.setString("mainValue", data['mainValue']);
  pref.setString("mobile", data['mobile']);
  pref.setString("fcmToken", data['fcm_token']);
  pref.setString("KeyValue", data['KeyValue']);
}
