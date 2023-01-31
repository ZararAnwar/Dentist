import 'dart:io';

import 'package:dr_dentist/Bottom-Nav/Main-Page.dart';
import 'package:dr_dentist/Create-Doctor-Official-Profile/create-official-profile.dart';
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

class DoctorOfficialProfile extends StatefulWidget {
  const DoctorOfficialProfile({Key key}) : super(key: key);

  @override
  _DoctorOfficialProfileState createState() => _DoctorOfficialProfileState();
}

class _DoctorOfficialProfileState extends State<DoctorOfficialProfile> {

  DocumentSnapshot doc;

  String clinicName = 'ClinicName';
  String whatsappLink = 'WhatsAppLink';
  String qualification = 'Qualification';
  String openTime = 'OpenTime';
  String closeTime = 'CloseTime';
  String clinicAddress = 'ClinicAddress';
  String clinicImage1 = 'ClinicImage1';
  String clinicImage2 = 'ClinicImage2';

  getUser() async {
    doc = await FirebaseFirestore.instance
        .collection("AllUsers")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();

    if (doc != null) {
      clinicName = doc['ClinicName'];
      clinicAddress = doc['ClinicAddress'];
      openTime = doc['OpenTime'];
      closeTime = doc['CloseTime'];
      qualification = doc['Qualification'];
      whatsappLink = doc['WhatsAppLink'];
      clinicImage2 = doc['ClinicImage2'];
      clinicImage1 = doc['ClinicImage1'];

      setState(() {});
    }
  }
  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: lightColor,
        title: Text("Official Profile",
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
            SizedBox(height: 40,),
            /// clinic name
            colorText("Clinic Name :"),
            myText(clinicName),
            /// clinic address
            colorText("Clinic Address :"),
            myText(clinicAddress),
            /// qualification
            colorText("Qualification :"),
            myText(qualification),
            /// wjhatsapp
            colorText("WhatsApp Link :"),
            myText(whatsappLink),
            /// timing
            Row(
              children: [
                /// timing
                Column(
                  children: [
                    colorText("Open Time :"),
                    Row(
                      children: [
                        myText(openTime),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    colorText("Close Time :"),
                    Row(
                      children: [
                        myText(closeTime),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            /// images
            SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 150,
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(clinicImage1,fit: BoxFit.cover,)),
                ),
                SizedBox(width: 10,),
                Container(
                  height: 150,
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(clinicImage2,fit: BoxFit.cover,)),
                ),
              ],
            ),
            /// click here to update
            SizedBox(height: 50,),
            InkWell(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CreateOfficialProfile(),),);
              },
              child: Text("Click here to update your official profile",
              style: GoogleFonts.quicksand(
                color: darkRedColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
              ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  /// light red text
Padding colorText(String title){
    return Padding(
      padding: const EdgeInsets.only(top: 15,left: 20,right: 20),
      child: Row(
        children: [
          Text(title,
            style: GoogleFonts.lexendExa(
              color: lightColor,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
}
/// small text
Padding myText(String title){
    return  Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Text(title,
        textAlign: TextAlign.center,
        style: GoogleFonts.lexendExa(
          color: B,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
    );
}
}
