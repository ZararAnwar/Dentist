import 'package:dr_dentist/User-ShowCase/Notification/User-Notification.dart';
import 'package:dr_dentist/Utils/utils.dart';
import 'package:dr_dentist/login_page.dart';
import 'package:dr_dentist/main.dart';
import 'package:dr_dentist/search_screen.dart';
import 'package:dr_dentist/video_disease.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:dr_dentist/User-ShowCase/Home-Page/Home-Page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'Admin/Admin-Verification.dart';
import 'User-ShowCase/Profile-Tab/edit-Profile.dart';
import 'User-ShowCase/Profile-Tab/sended-Requests.dart';



class FavouriteScreen extends StatefulWidget {
  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {

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


  int _selectedIndex = 0;

  void onTapped(int value) {
    setState(() {
      _selectedIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBgColor,
      body: ListView(
        children: [
          Stack(
        alignment: AlignmentDirectional.topCenter,
        children: <Widget>[
          _backBgCover(),
          _search(),

        ],
      ),
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  /// profile container
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
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>EditProfile(),),);
                                  },
                                  child: Icon(Icons.edit,color: darkRedColor,)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  /// sended requests
                  SizedBox(height: 15,),
                  InkWell(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SendedRequests(),),);
                      },
                      child: myCont("Sended Requests", B, Icons.assignment_turned_in_outlined, B)),
                  SizedBox(height: 15,),
                  InkWell(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>UserNotification(),),);
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
                  SizedBox(height: 30,),
                  InkWell(
                      onTap: (){
                        logOut();
                      },
                      child: myCont("LogOut", Colors.red[900], Icons.logout, Colors.red[900])),
                  //_specialistsCardInfo(),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        child: Icon(
          LineAwesomeIcons.youtube
        ),
        onPressed: (){
          Navigator
              .of(context)
              .pushReplacement(new MaterialPageRoute(builder: (BuildContext context) {
            return VideoDisease();
          }));
        },
      ),
    );
  }
  Container _backBgCover() {
    return Container(
      height: 200.0,
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
      bottom: 90,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Dr_Dentist',
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
            'All Your Favourite Doctors are Here !',
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

  // container
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
}
