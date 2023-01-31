import 'dart:async';
import 'dart:core';

import 'package:dr_dentist/Bottom-Nav/Main-Page.dart';
import 'package:dr_dentist/Doctor-ShowCase/Doctor-Nav-Bar-Page.dart';
import 'package:dr_dentist/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dr_Dentist',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  DocumentSnapshot doc;
  String mainValue = 'mainValue';

  List<String> sportsList;

  getUserValue() async {
    doc = await FirebaseFirestore.instance
        .collection("AllUsers")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();

    if (doc != null) {
      mainValue = doc['mainValue'] ?? '';
      print("MAIN VALUE IS ================ $mainValue");
      setState(() {});
    }
  }



  getUser() async {
    bool check = false;
    User user= FirebaseAuth.instance.currentUser;
    if (user != null) {
      Future.delayed(Duration(milliseconds: 3000)).then((_) {
        mainValue == "Doctor" ?
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DoctorNabBarPage(),),)  :
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>NavBarPage(),),);
      });
    }else{
      Future.delayed(Duration(milliseconds: 3000)).then((_) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LoginPage(),),);
      });
    }
  }

  void initState(){
    super.initState();
   getUser();
   getUserValue();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 300,
            width: 300,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/logo.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
      );
  }
}


