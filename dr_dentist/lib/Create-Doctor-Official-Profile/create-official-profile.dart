import 'dart:io';
import 'package:dr_dentist/Create-Doctor-Official-Profile/Upload-clinic-pics.dart';
import 'package:dr_dentist/Helper/show-Dialog-F.dart';
import 'package:dr_dentist/User-ShowCase/Home-Page/Home-Page.dart';
import 'package:dr_dentist/Helper/Flutter-Drop-Down.dart';
import 'package:dr_dentist/Utils/create-Doctor-Utils.dart';
import 'package:dr_dentist/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'address-search.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:uuid/uuid.dart';
import 'package:after_layout/after_layout.dart';



class CreateOfficialProfile extends StatefulWidget {
  const CreateOfficialProfile({Key key}) : super(key: key);

  @override
  _CreateOfficialProfileState createState() => _CreateOfficialProfileState();
}

class _CreateOfficialProfileState extends State<CreateOfficialProfile> {


  String _selectedTime = "Select Time";
  String _selectedTime2 = "Select Time";
  Future<void> _show1() async {
    final TimeOfDay result = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
              // data: MediaQuery.of(context).copyWith(
              //   // Using 12-Hour format
              //     alwaysUse24HourFormat: false),
              data: ThemeData.dark().copyWith(
                colorScheme: ColorScheme.dark(
                  primary: darkRedColor,
                  onPrimary: Colors.white,
                  surface: Colors.white,
                  onSurface: darkRedColor,
                ),
                dialogBackgroundColor:Colors.blue[900],
              ),
              // If you want 24-Hour format, just change alwaysUse24HourFormat to true
              child: child);
        });
    if (result != null) {
      setState(() {
        _selectedTime = result.format(context);
      });
    }
  }
  Future<void> _show2() async {
    final TimeOfDay result = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
              data: ThemeData.dark().copyWith(
                colorScheme: ColorScheme.dark(
                  primary: darkRedColor,
                  onPrimary: Colors.white,
                  surface: Colors.white,
                  onSurface: darkRedColor,
                ),
                dialogBackgroundColor:Colors.blue[900],
              ),
              // data: MediaQuery.of(context).copyWith(
              //   // Using 12-Hour format
              //     alwaysUse24HourFormat: false),
              // If you want 24-Hour format, just change alwaysUse24HourFormat to true
              child: child);
        });
    if (result != null) {
      setState(() {
        _selectedTime2 = result.format(context);
      });
    }
  }


  final TextEditingController clinicNameController = TextEditingController();
  final TextEditingController whatsappLinkController = TextEditingController();

  File image;
  String level = 'Orthodontist';
  String exp = '1 Year';
  String responseTime = '15 min';
  String _currentAddress = '';
  Place placeDetails;


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Stack(
                // overflow: Overflow.visible,
                fit: StackFit.loose,
                children: [
                  _backBgCover(),
                  Positioned(
                    top: 60,
                    left: 50,right: 50,
                    child: Center(
                      child: Text(
            "Create your official profile",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
                    ),
                  ),
                ],
              ),
              // name
              SizedBox(height: 50,),
              myTextField(clinicNameController, " Clinic Name"),
              myTextField(whatsappLinkController, " WhatsApp Link"),
              Padding(
                padding: const EdgeInsets.only(top: 15,left: 40,right: 40,bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Icon(Icons.volunteer_activism,color: Colors.black38,),
                          SizedBox(width: 5,),
                          Text("Qualification :"),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          10, 0, 0, 0),
                      child: FlutterFlowDropDown(
                        initialOption: 'Orthodontist',
                        options: [
                          'Orthodontist',
                          'Prosthodontist',
                          'Maxillofacial',
                          'Surgeon',
                          'Endodontist',
                        ].toList(),
                        onChanged: (val) =>
                            setState(() => level = val),
                        width: MediaQuery.of(context).size.width *
                            0.40,
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
              ),
              /// experience
              Padding(
                padding: const EdgeInsets.only(top: 15,left: 40,right: 40,bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Icon(Icons.explicit_outlined,color: Colors.black38,),
                          SizedBox(width: 5,),
                          Text("Experience :"),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          10, 0, 0, 0),
                      child: FlutterFlowDropDown(
                        initialOption: '1 Year',
                        options: [
                          '1 Year',
                          '2 Year',
                          '3 Year',
                          '4 Year',
                          '5 Year',
                          'More then 5 Year',
                        ].toList(),
                        onChanged: (val) =>
                            setState(() => exp = val),
                        width: MediaQuery.of(context).size.width *
                            0.40,
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
              ),
              /// response time
              Padding(
                padding: const EdgeInsets.only(top: 15,left: 40,right: 40,bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Icon(Icons.timer,color: Colors.black38,),
                          SizedBox(width: 5,),
                          Text("Response Time :"),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          10, 0, 0, 0),
                      child: FlutterFlowDropDown(
                        initialOption: '15 min',
                        options: [
                          '15 min',
                          '30 min',
                          '45 min',
                          '60 min',
                          '2 hour',
                          'More then 2 hour',
                        ].toList(),
                        onChanged: (val) =>
                            setState(() => responseTime = val),
                        width: MediaQuery.of(context).size.width *
                            0.35,
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
              ),
              // location
              InkWell(
                onTap: () async {
                  final sessionToken = Uuid().v4();

                  // should show search screen here
                  Suggestion result = await showSearch(
                    context: context,
                    // we haven't created AddressSearch class
                    // this should be extending SearchDelegate
                    delegate: AddressSearch(sessionToken),
                  );
                  print("Here1");

                  if (result != null) {
                    placeDetails = await PlaceApiProvider(sessionToken)
                        .getPlaceDetailFromId(result.placeId);
                    print(placeDetails.log.toString() + "kkkkkkkkkkkkkkk");
                    List<Placemark> placemarks =
                    await placemarkFromCoordinates(
                        placeDetails.lat, placeDetails.log);

                    Placemark place = placemarks[0];

                    _currentAddress = "${place.locality}, ${place.country}";
                    setState(() {});
                    print(_currentAddress);
                  }
                  print("Here");
                },
                child: Container(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_location,
                          color: darkRedColor),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        (_currentAddress.length < 1)
                            ? "Add your clinic location"
                            : _currentAddress,
                        style: GoogleFonts.quicksand(
                          color: Colors.black87,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40,right: 40),
                child: Divider(
                  thickness: 1,
                  indent: 10,
                  color: Color(0xFFC3C2C2),
                ),
              ),
              // close or start timings
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /// start time
                    Column(
                      children: [
                        Text("Open timing",
                          style: GoogleFonts.quicksand(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 5,),
                        InkWell(
                          onTap: () => _show1(),
                          child: Container(
                            height: 35,
                            width: 120,
                            decoration: BoxDecoration(
                              color: darkRedColor.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Text("$_selectedTime",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 30,),
                    /// end time
                    Column(
                      children: [
                        Text("Close timing",
                          style: GoogleFonts.quicksand(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 5,),
                        InkWell(
                          onTap: ()=> _show2(),
                          child: Container(
                            height: 35,
                            width: 120,
                            decoration: BoxDecoration(
                              color: darkRedColor.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Text("$_selectedTime2",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
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
              // create profile
              Padding(
                padding: const EdgeInsets.only(top: 60,bottom: 60),
                child: InkWell(
                  onTap: (){
                    createDoctor(context);
                  },
                  child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width * 0.6,
                    decoration: BoxDecoration(
                      color: darkRedColor.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text("Create Profile",
                        style: GoogleFonts.quicksand(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
                      // XFile? file =     await   ImagePicker.platform.getVideo(source: ImageSource.gallery);
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
  Container _backBgCover() {
    return Container(
      height: 150.0,
      decoration: BoxDecoration(
        gradient: purpleGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
    );
  }
  // text field
Padding myTextField(TextEditingController controller, String text){
    return Padding(padding: EdgeInsets.only(left: 30,right: 30,top: 15),
      child: TextFormField(
        controller: controller,
        obscureText: false,
        cursorColor: darkRedColor,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black,width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black,width: 1),
          ),
          labelText: text,
          labelStyle: GoogleFonts.quicksand(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
}

/// create doctor official profile
  createDoctor(BuildContext context) async {
    showDialogF(context);
    if (
        clinicNameController.text.isEmpty ||
        level.isEmpty ||
        whatsappLinkController.text.isEmpty ) {
      Fluttertoast.showToast(
          msg: "Fild the required fields",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black38,
          textColor: Colors.white,
          fontSize: 15.0);
      Navigator.of(context).pop();
    } else {

      showDialogF(context);
      Map <String, dynamic> dataPut = {
        "ClinicName" : clinicNameController.text,
        "WhatsAppLink" : whatsappLinkController.text,
        "Qualification" : level,
       "OpenTime" : _selectedTime,
       "CloseTime": _selectedTime2,
       "ClinicAddress": _currentAddress,
       "Longitude": placeDetails.log,
       "Latitude": placeDetails.lat,
       "Experience": exp,
       "ResponseTime": responseTime,
      };
      FirebaseFirestore.instance.collection("AllUsers").doc(
          FirebaseAuth.instance.currentUser.uid).
      update(dataPut).then((value) async {
        await saveOtherData(
          clinicNameController.text,
          whatsappLinkController.text,
          level,
          _selectedTime,
          _selectedTime2,
          _currentAddress,
          placeDetails.log,
          placeDetails.lat,
          exp,
          responseTime,
        );
      });
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>UploadClinicPics(),),);

    }
  }
}


