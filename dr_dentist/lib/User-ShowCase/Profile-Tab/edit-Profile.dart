import 'dart:io';

import 'package:dr_dentist/Bottom-Nav/Main-Page.dart';
import 'package:dr_dentist/Helper/show-Dialog-F.dart';
import 'package:dr_dentist/Utils/utils.dart';
import 'package:dr_dentist/favourite_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  TextEditingController updateNameController = TextEditingController();
  TextEditingController updateMobileController = TextEditingController();
  TextEditingController updateAddressController = TextEditingController();

  DocumentSnapshot doc;
  String imageString = 'image';

  getUser() async {
    doc = await FirebaseFirestore.instance
        .collection("AllUsers")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();

    if (doc != null) {
      imageString = doc['image'];
      updateNameController = TextEditingController(text: doc["name"]);
      updateMobileController = TextEditingController(text: doc["mobile"]);
      updateAddressController = TextEditingController(text: doc["address"]);

      setState(() {});
    }
  }
  @override
  void initState() {
    super.initState();
    getUser();
  }

  File image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: lightColor,
        title: Text("Edit Profile",
        style: GoogleFonts.lexendExa(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            /// image
            SizedBox(height: 40,),
            Center(
              child: Container(
                  width: 100,
                  height: 100,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: (
                      doc != null &&
                          imageString != 'image' &&
                          image == image
                  )
                      ? Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Image.network(
                      imageString,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  )
                      : Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Image.network(
                      imageString,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  )
              ),
            ),
            SizedBox(height: 10,),
            InkWell(
              onTap: (){
                imagePickerModalBottomSheet(context);
              },
              child: Container(
                height: 25,
                width: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(2,2),
                      blurRadius: 2,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Text("Change Image",
                  style: GoogleFonts.quicksand(
                    color: B,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  ),
                ),
              ),
            ),
            /// name , mobile , address
            Padding(
              padding: EdgeInsets.only(left: 20,right: 20,top: 40),
              child: TextFormField(
                cursorColor: darkRedColor,
                controller: updateNameController,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle:GoogleFonts.quicksand (
                    color: B,
                    fontWeight: FontWeight.w500,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: B,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: darkRedColor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                style: GoogleFonts.quicksand(
                  color: B,
                  fontWeight: FontWeight.w500,
                ),
                keyboardType: TextInputType.name,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20,right: 20,top: 15),
              child: TextFormField(
                cursorColor: darkRedColor,
                controller: updateMobileController,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: 'Mobile',
                  labelStyle:GoogleFonts.quicksand (
                    color: B,
                    fontWeight: FontWeight.w500,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: B,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: darkRedColor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                style: GoogleFonts.quicksand(
                  color: B,
                  fontWeight: FontWeight.w500,
                ),
                keyboardType: TextInputType.name,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20,right: 20,top: 15,bottom: 60),
              child: TextFormField(
                cursorColor: darkRedColor,
                controller: updateAddressController,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: 'Address',
                  labelStyle:GoogleFonts.quicksand (
                    color: B,
                    fontWeight: FontWeight.w500,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: B,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: darkRedColor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                style: GoogleFonts.quicksand(
                  color: B,
                  fontWeight: FontWeight.w500,
                ),
                keyboardType: TextInputType.name,
              ),
            ),
            /// button to update profile data
            InkWell(
              onTap: (){
                showDialogF(context);
                Map<String, dynamic> data = {
                  "name": updateNameController.text.trim(),
                  "mobile": updateMobileController.text.trim(),
                  "address": updateAddressController.text.trim(),
                };
                FirebaseFirestore.instance
                    .collection("AllUsers")
                    .doc(FirebaseAuth.instance.currentUser.uid)
                    .update(data)
                    .then((value) {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>NavBarPage(),),);
                });
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.5,
                height: 50.0,
                decoration: BoxDecoration(
                  gradient: purpleGradient,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Update",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  /// image picker bottom sheet
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
