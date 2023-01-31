import 'package:dr_dentist/Admin/Admin-Verification.dart';
import 'package:dr_dentist/Doctor-ShowCase/Create-Story/My-Stories.dart';
import 'package:dr_dentist/Doctor-ShowCase/Create-Story/story-comment.dart';
import 'package:dr_dentist/Doctor-ShowCase/Profile/Doctor-Edit-Profile.dart';
import 'package:dr_dentist/Doctor-ShowCase/Profile/My-Reviews.dart';
import 'package:dr_dentist/Doctor-ShowCase/Profile/Notifications-Screen.dart';
import 'package:dr_dentist/Doctor-ShowCase/Profile/Official-Profile-Of-Doctor.dart';
import 'package:dr_dentist/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../login_page.dart';


class DoctorProfileScreen extends StatefulWidget {
  const DoctorProfileScreen({Key key}) : super(key: key);

  @override
  _DoctorProfileScreenState createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {

  DocumentSnapshot doc;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  String nameString = 'name';
  String imageString = 'image';
  String addressString = 'address';
  getUser() async {
    doc = await FirebaseFirestore.instance
        .collection("AllUsers")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();

    if (doc != null) {
      nameString = doc['name'];
      imageString = doc['image'];
      addressString = doc['address'];
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Stack(
              alignment: AlignmentDirectional.topCenter,
              children: <Widget>[
                _backBgCover(),
                _search(),

              ],
            ),
            /// container of doctor profile
            Padding(
              padding: const EdgeInsets.only(top: 40,left: 20,right: 20),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(2,2),
                      spreadRadius: 2,
                      blurRadius: 2,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: darkRedColor),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Row(
                              children: [
                                imageString != null ?
                                Container(
                                  height: 70,
                                  width: 70,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(40),
                                    child: Image.network(imageString,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ) : Container(),
                                SizedBox(width: 10,),
                                Column(
                                  children: [
                                    Text(nameString,
                                      style: GoogleFonts.quicksand(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(addressString,
                                      style: GoogleFonts.quicksand(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                              onTap: (){
                                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>EditDoctorProfile(),),);
                              },
                              child: Icon(Icons.edit,color: darkRedColor,)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            /// official profile
            Padding(
              padding: const EdgeInsets.only(top: 15,left: 20,right: 20),
              child: InkWell(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DoctorOfficialProfile(),),);
                  },
                  child: myCont("Official Profile", B, Icons.favorite, B)),
            ),
            /// my stories
            Padding(
              padding: const EdgeInsets.only(top: 15,left: 20,right: 20),
              child: InkWell(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyStories(),),);
                  },
                  child: myCont("My Stories", B, Icons.auto_stories, B)),
            ),
            /// my stories comment
            Padding(
              padding: const EdgeInsets.only(top: 15,left: 20,right: 20),
              child: InkWell(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>StoryComment(),),);
                  },
                  child: myCont("My Stories Comment", B, Icons.comment_bank, B)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15,left: 20,right: 20),
              child: InkWell(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DoctorNotificationScreen(),),);
                  },
                  child: Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              offset: Offset(2,2),
                              spreadRadius: 2,
                              blurRadius: 2,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: darkRedColor),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            children: [
                              Icon(Icons.notification_important,color: B,),
                              SizedBox(width: 10,),
                              Text("Notifications",
                                style: GoogleFonts.quicksand(
                                  color: B,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 29,
                        top: 10,
                        child: Container(
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('PushNotifications')
                                  .where("userId",
                                  isEqualTo: FirebaseAuth.instance.currentUser.uid)
                                  .snapshots(),
                              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (!snapshot.hasData) {
                                  return Container(
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: darkRedColor,
                                      ),
                                    ),
                                  );
                                }
                                print(snapshot.data.docs.length.toString() + "ffffffffffffffffff");
                                return Center(
                                  child: snapshot.data.docs.length.toString() != null ?
                                  Text("${snapshot.data.docs.length.toString()}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                  ) :
                                  Text("0",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ),
                    ],
                  ),
              ),
            ),
            /// all reviews
            Padding(
              padding: const EdgeInsets.only(top: 15,left: 20,right: 20,bottom: 30),
              child: InkWell(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyReviews(),),);
                  },
                  child: myCont("My Reviews", B, Icons.rate_review, B)),
            ),
            InkWell(
                onTap: (){
                  logOut();
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 20,right: 20,top: 30),
                  child: myCont("LogOut", Colors.red[900], Icons.logout, Colors.red[900]),
                )),
            SizedBox(height: 50,),
          ],
        ),
      ),
    );
  }

  Container myCont(String title, Color color,IconData iconData,Color color2){
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(2,2),
            spreadRadius: 2,
            blurRadius: 2,
          ),
        ],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: darkRedColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Icon(iconData,color: color2,),
            SizedBox(width: 10,),
            Text(title,
              style: GoogleFonts.quicksand(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _backBgCover() {
    return Container(
      height: 180.0,
      decoration: BoxDecoration(
        gradient: purpleGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
    );
  }
  Positioned _search() {
    return Positioned(
      left: 20,
      top: 55,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Health Care',
            style:  GoogleFonts.quicksand(
              fontSize: 36,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Your Profile !',
            style: GoogleFonts.quicksand(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
  logOut() async {
    var auth = FirebaseAuth.instance;
    auth.signOut();
    await FirebaseMessaging.instance.deleteToken();

    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();

    Navigator.pushAndRemoveUntil<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => LoginPage(),
      ),
          (route) => false,
    );
  }
}
