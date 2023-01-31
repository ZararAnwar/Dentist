import 'dart:io';
import 'package:dr_dentist/Bottom-Nav/Main-Page.dart';

import 'package:dr_dentist/User-ShowCase/Home-Page/Home-Page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_dentist/Helper/show-Dialog-F.dart';
import 'package:dr_dentist/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'Create-Doctor-Official-Profile/create-official-profile.dart';
import 'Helper/Flutter-Drop-Down.dart';
import 'Utils/save-Data.dart';
import 'Utils/utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Widgets/progress_custom.dart';
import 'login_page.dart';
import 'dart:async';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  String mainValue = 'Patient';
  String firebaseToken = '';

  File image;
  bool _obscureText2 = true;

  Future<bool> onWillPoP()async{
    final shouldPop = await showDialog(
      context: context,
      builder: (context)=> AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        backgroundColor: Colors.red[900],
        title: Column(
          children: [
            Icon(
              Icons.warning,
              color: Colors.white,
              size: 30,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'Are you sure to exit the app ?',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(
              height: 15,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: (){
                    Navigator.of(context).pop(false);
                  },
                  child: Container(
                    height: 25,
                    width: 70,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7),
                      boxShadow: [BoxShadow(
                          color: Colors.black12,
                          offset: Offset(2, 2),
                          spreadRadius: 2,
                          blurRadius: 2
                      )],
                    ),
                    child: Center(
                      child: Text("NO",
                        style: GoogleFonts.quicksand(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20,),
                InkWell(
                  onTap: (){
                    Navigator.of(context).pop(true);
                  },
                  child: Container(
                    height: 25,
                    width: 70,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7),
                      boxShadow: [BoxShadow(
                          color: Colors.black12,
                          offset: Offset(2, 2),
                          spreadRadius: 2,
                          blurRadius: 2
                      )],
                    ),
                    child: Center(
                      child: Text("YES",
                        style: GoogleFonts.quicksand(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    return shouldPop ?? false;
  }

  @override
  void initState() {
    getToken();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:WillPopScope(
        onWillPop: onWillPoP,
        child: Form(
          key: _formKey,
          child: ListView(
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
                            "Dr. Driving",
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Welcome to the Health Care place!",
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.white.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 5)),
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
              InkWell(
                onTap: () {
                  imagePickerModalBottomSheet(context);
                },
                child: image != null
                    ? Padding(
                      padding: const EdgeInsets.only(left: 110,right: 110,top: 10),
                      child: Container(
                          height: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: darkRedColor,
                            border: Border.all(
                                color: darkRedColor),
                          ),
                          child: ClipRRect(borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              image,
                              height: 118,
                              width: 118,
                              fit: BoxFit.cover,
                            ),
                          )),
                    )
                    : Padding(
                      padding: const EdgeInsets.only(left: 110,right: 110,top: 10),
                      child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: darkRedColor,
                      border: Border.all(
                          color: darkRedColor),
                  ),
                  child: Center(
                      child: Icon(Icons.add_a_photo_outlined),
                  ),
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
                    border: Border.all(color: Colors.white.withOpacity(0.05))),
                child: TextFormField(
                  //  validator: (v) => validateName(v),
                  controller: nameController,
                  obscureText: false,
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                    hintText: "Enter Name",
                    icon: Icon(Icons.person),
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
                    border: Border.all(color: Colors.white.withOpacity(0.05))),
                child: TextFormField(
                  controller: emailController,
                  // validator: (v) => validateEmail(v),
                  obscureText: false,
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                    hintText: "Email",
                    icon: Icon(Icons.alternate_email),
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
                    border: Border.all(color: Colors.white.withOpacity(0.05))),
                child: TextFormField(
                  controller: passwordController,
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
                    icon: Icon(Icons.phone_android_outlined),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(
                          top: 20, bottom: 14, left: 20, right: 20),
                      margin: EdgeInsets.only(
                          left: 20, right: 20, top: 20, bottom: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.white.withOpacity(0.1),
                                blurRadius: 10,
                                offset: Offset(0, 5)),
                          ],
                          border:
                              Border.all(color: Colors.green.withOpacity(0.05))),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: mobileController,
                        // validator: (v) => validateMobile(v),
                        obscureText: false,
                        textAlign: TextAlign.start,
                        decoration: InputDecoration(
                          hintText: "+92XXXXXXXXXX",
                          icon: Icon(Icons.phone_android_outlined),
                        ),
                      ),
                    ),
                  ),
                  // TextFieldWidget(
                ],
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.account_box,color: Colors.black38,),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                        10, 0, 0, 0),
                    child: FlutterFlowDropDown(
                      initialOption: 'Patient',
                      options: ['Patient', 'Doctor'].toList(),
                      onChanged: (val) =>
                          setState(() => mainValue = val),
                      width: MediaQuery.of(context).size.width *
                          0.74,
                      height: 50,
                      textStyle:
                      TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                      fillColor: Colors.white,
                      elevation: 2,
                      borderColor: Color(0x00FFFFFF),
                      borderWidth: 0,
                      borderRadius: 0,
                      margin: EdgeInsetsDirectional.fromSTEB(
                          8, 4, 8, 4),
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
                    border: Border.all(color: Colors.green.withOpacity(0.05))),
                child: TextFormField(
                  controller: addressController,
                  // validator: (v) => validateaddress(v),
                  obscureText: false,
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                    hintText: "Address",
                    icon: Icon(Icons.location_on),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 18.0, right: 18.0, top: 10.0),
                child: InkWell(
                  onTap: () {
                    signUpWithEmailOrPassword(context);
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
                      "Register",
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
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            direction: Axis.vertical,
            children: [
              SizedBox(height: 10,),
              InkWell(
                onTap: (){
                  Navigator
                      .of(context)
                      .pushReplacement(new MaterialPageRoute(builder: (BuildContext context) {
                    return LoginPage();
                  }));
                },
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: "Already have an account ?  ",
                      style: TextStyle(
                        color: Colors.purple,
                        fontSize: 14,
                      ),
                      children: [
                        TextSpan(
                          text: "LogIn",
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
              SizedBox(height: 10,),
            ],
          ),
        ],
      ),
    );
  }

  signUpWithEmailOrPassword(BuildContext context) async {

    showDialogF(context);

    print("nameController.text ${nameController.text}");
    print("emailController.text ${emailController.text}");
    print("passwordController.text ${passwordController.text}");
    print("mainValue.text $mainValue");
    print("addressController.text ${addressController.text}");
    print("mobileNumberController.text ${mobileController.text}");

    if(mainValue == null){
      Navigator.pop(context);

      Fluttertoast.showToast(
          msg: "Choose your Identity",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black38,
          textColor: Colors.white,
          fontSize: 15.0);
      return;
    }
    else if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        addressController.text.isEmpty ||
        mobileController.text.isEmpty) {
      Navigator.pop(context);

      Fluttertoast.showToast(
          msg: "Fill the required fields",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black38,
          textColor: Colors.white,
          fontSize: 15.0);
      return;
    }
    else{
      String name = DateTime.now().toString();

      // image

      Reference reference =
      FirebaseStorage.instance.ref().child("UsersProfilePics/$name");

      print("reference.name ${reference.name}");
      print("reference.name ${reference.storage}");
      print("reference.name ${reference.fullPath}");
      print("reference.name ${reference.storage.app}");
      print("reference.name ${reference.parent}");

      //Upload the file to firebase
      UploadTask uploadTask = reference.putFile(image);
      print("After UploadTask ${uploadTask}");
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

      print("After taskSnapshot ${taskSnapshot.ref}");
      // Waits till the file is uploaded then stores the download url
      String url = await taskSnapshot.ref.getDownloadURL();
      print("url $url");

      // image end

      FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim())
          .then((value) async {
        print("${value.user.uid}");

        await FirebaseAuth.instance.currentUser
            .updateEmail(emailController.text.trim());

        if (value.user.uid.isNotEmpty) {
          Map<String, dynamic> data = {
            "name": nameController.text.trim(),
            "mobile": mobileController.text.trim(),
            "address": addressController.text.trim(),
            "email": value.user.email,
            "image": url.isEmpty ? 'image' : url,
            "password": passwordController.text.trim(),
            "mainValue": mainValue,
            "userId": value.user.uid,
            "fcm_token": firebaseToken,
            "KeyValue": "New",
          };
          FirebaseFirestore.instance
              .collection("AllUsers")
              .doc(value.user.uid)
              .set(data)
          // .add(data)
              .then((e) async {
            data['userId'] = value.user.uid;
            Navigator.of(context).pop();
            if (value.user.uid.isNotEmpty && mainValue == "Patient") {
              await saveData(data);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => NavBarPage(),
                ),
              );
            }else if(value.user.uid.isNotEmpty && mainValue == "Doctor"){
              await saveData(data);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => CreateOfficialProfile(),
                ),
              );
            }
          }).catchError((onError) {
            print(onError);
            print("onError((onError) { \n $onError");
          });
        } else {
          Navigator.pop(context);
        }
      }).catchError((onError) {
        Navigator.of(context).pop();
        print("catchError((onError) { \n $onError");
        // print(onError.message);
      });
    }
  }

  void getToken() async {
    // FirebaseMessaging.instance.getToken().then((token) => firebaseToken);
    //  setState(() {
    //          print("MyToken $firebaseToken");

    //  });
    FirebaseMessaging.instance.setAutoInitEnabled(false);

    FirebaseMessaging.instance.getToken().then((value) {
      firebaseToken = value;
      print("MyToken $firebaseToken");
      setState(() {});
    });
  }
  // image picker bottom sheet
  imagePickerModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: Icon(Icons.camera_alt),
                    title: Text('Camera'),
                    onTap: () async {
                      PickedFile file = await ImagePicker.platform
                          .pickImage(source: ImageSource.camera);

                      if (file != null) {
                        image = File(file.path);
                        Navigator.of(context).pop();
                        setState(() {});
                      }
                    }),
                ListTile(
                  leading: Icon(Icons.photo_album_rounded),
                  title: Text('Gallery'),
                  onTap: () async {
                    PickedFile file = await ImagePicker.platform
                        .pickImage(source: ImageSource.gallery);
                    if (file != null) {
                      image = File(file.path);

                      Navigator.of(context).pop();
                      setState(() {});
                    }
                  },
                ),
              ],
            ),
          );
        });
  }

}
