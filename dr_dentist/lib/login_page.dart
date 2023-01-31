import 'package:dr_dentist/Admin/Admin-Verification.dart';
import 'package:dr_dentist/Bottom-Nav/Main-Page.dart';
import 'package:dr_dentist/Doctor-ShowCase/Doctor-Nav-Bar-Page.dart';
import 'package:dr_dentist/Helper/show-Dialog-F.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dr_dentist/User-ShowCase/Home-Page/Home-Page.dart';
import 'Signup_page.dart';
import 'Utils/save-Data.dart';
import 'Utils/utils.dart';
import 'main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  String firebaseToken = '';

  DocumentSnapshot doc;
  String mainValue = 'mainValue';

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

  bool _obscureText2 = true;


  void getToken() async {
    FirebaseMessaging.instance.setAutoInitEnabled(false);

    await FirebaseMessaging.instance.getToken().then((value) {
      firebaseToken = value;
      print("MyToken $firebaseToken");
      setState(() {});
    });
  }

  void saveUserData(User user) async {
    print("inside");
    print("user Idddddddddddddd" + user.uid);
    Map<String, dynamic> data = {
      "name": user.displayName,
      "mobile": user.phoneNumber ?? '',
      "address": '',
      "email": user.email,
      "image": user.photoURL == null ? 'image' : user.photoURL,
      "password": '',
      "mainValue": '',
      "userId": user.uid,
      "fcm_token": firebaseToken,
    };
    await saveData(data);
  }

  @override
  void initState() {
    super.initState();
    getToken();
    getUserValue();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        primary: true,
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomCenter,

            children: [
              Container(
                height: 180.0,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: purpleGradient,
                  borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.white.withOpacity(0.2),
                        blurRadius: 10,
                        offset: Offset(0, 5)),
                  ],

                ),
                margin: EdgeInsets.only(bottom: 50),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        "Health Care",
                        style: TextStyle(
                            color: Colors.white, fontSize: 24),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Welcome to the best Health Care Place!",
                        style:TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),

                      // Text("Fill the following credentials to login your account", style: Get.textTheme.caption.merge(TextStyle(color: Get.theme.primaryColor))),
                    ],
                  ),
                ),
              ),
              Container(

                decoration:BoxDecoration(
                  color:  Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular( 10)),
                  boxShadow: [
                    BoxShadow(color:Colors.white.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                  ],
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                  //  gradient: gradient,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.cover,
                    width: 100,
                    height: 100,
                  ),
                ),
              ),

            ],
          ),
          Container(
            padding:
            EdgeInsets.only(top: 20, bottom: 14, left: 20, right: 20),
            margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.white.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 5)),
                ],
                border: Border.all(
                    color: Colors.white.withOpacity(0.05))),
            child: TextFormField(
             controller: emailController,

              obscureText: false,
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                hintText: "Email",
                icon: Icon(Icons.phone_android_outlined),
              ),
            ),
          ),
          Container(
            padding:
            EdgeInsets.only(top: 20, bottom: 14, left: 20, right: 20),
            margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.white.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 5)),
                ],
                border: Border.all(
                    color: Colors.white.withOpacity(0.05))),
            child: TextFormField(
              controller: passController,

              obscureText: _obscureText2,
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                suffixIcon: InkWell(
                  onTap: () => setState(() {
                    _obscureText2 = !_obscureText2;
                  }),
                  child: Icon(
                    _obscureText2
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: B,
                    size: 22,
                  ),
                ),
                hintText: "Password",
                icon: Icon(Icons.verified_user_outlined),
              ),
            ),
          ),
          Padding(
        padding: const EdgeInsets.only(left:18.0,right: 18.0,top: 10.0),
        child: InkWell(
          onTap: ()async{
            signinWithEmail(context);
          },
          child: Container(

            width: double.infinity,
            height: 50.0,
            decoration: BoxDecoration(
              gradient: purpleGradient,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              "Login",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),

          SizedBox(height: 30,),
          InkWell(
            onTap: (){
              Navigator
                  .of(context)
                  .pushReplacement(new MaterialPageRoute(builder: (BuildContext context) {
                return SignupPage();
              }));
            },
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: "Don\'t have an account ?  ",
                style: TextStyle(
                  color: Colors.purple,
                  fontSize: 14,
                ),
                children: [
                  TextSpan(
                    text: "SignUp",
                    style: TextStyle(
                      color: darkRedColor,
                      decoration: TextDecoration.underline,
                      fontSize: 15,
                    ),
                  ),
                ]
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left:100.0,right: 100.0,top: 35.0),
            child: InkWell(
              onTap: ()async{
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AdminVerification(),),);
              },
              child: Container(
                width: 150,
                height: 50.0,
                decoration: BoxDecoration(
                  gradient: purpleGradient,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Admin",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  signinWithEmail(context) async {
    print('firebaseToken $firebaseToken');
    print('Main value ye hhhhhhhhhhhhhhhhhhhh $mainValue');

    showDialogF(context);
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passController.text.trim())
        .then((value) {
      if (value.user.uid.isNotEmpty) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => SplashScreen()),
                (Route<dynamic> route) => false);

        final usersUpdateData = {
          'fcm_token': firebaseToken,
        };
        var collection = FirebaseFirestore.instance.collection('AllUsers');
        collection
            .doc(value.user.uid)
            .update(usersUpdateData)
            .then((myVal) => saveUserData(value.user));
      }else
        print("Null");
      print("${value.user.uid}");
      print("${value.user.displayName}");
    }).catchError((onError) {});
  }

}
