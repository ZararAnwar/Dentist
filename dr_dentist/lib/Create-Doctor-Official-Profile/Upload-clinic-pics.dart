import 'dart:io';

import 'package:dr_dentist/Doctor-ShowCase/Doctor-Nav-Bar-Page.dart';
import 'package:dr_dentist/Helper/show-Dialog-F.dart';
import 'package:dr_dentist/User-ShowCase/Home-Page/Home-Page.dart';
import 'package:dr_dentist/Utils/create-Doctor-Utils.dart';
import 'package:dr_dentist/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';


class UploadClinicPics extends StatefulWidget {
   UploadClinicPics({Key key}) : super(key: key);

  @override
  _UploadClinicPicsState createState() => _UploadClinicPicsState();
}

class _UploadClinicPicsState extends State<UploadClinicPics> {

  File image1;
  File image2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 150,),
          Center(
            child: Text("Upload your clinic images",
              style: GoogleFonts.quicksand(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: darkRedColor,
              ),
            ),
          ),
          // image 1
          InkWell(
            onTap: () {
              imagePickerModalBottomSheet(context);
            },
            child: image1 != null
                ? Padding(
              padding: const EdgeInsets.only(left: 40,right: 40,top: 40,bottom: 10),
              child: Container(
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue.withOpacity(0.2),
                    border: Border.all(
                        color: Colors.black12),
                  ),
                  child: ClipRRect(borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      image1,
                      height: 148,
                      fit: BoxFit.cover,
                    ),
                  )),
            )
                : Padding(
              padding: const EdgeInsets.only(left: 40,right: 40,top: 40,bottom: 10),
              child: Container(
                height: 150,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue.withOpacity(0.2),
                  border: Border.all(
                      color: Colors.black12),
                ),
                child: Center(
                  child: Icon(Icons.add_a_photo_outlined),
                ),
              ),
            ),
          ),
          //image 2
          InkWell(
            onTap: () {
              imagePickerModalBottomSheet2(context);
            },
            child: image2 != null
                ? Padding(
              padding: const EdgeInsets.only(left: 40,right: 40,top: 10),
              child: Container(
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue.withOpacity(0.2),
                    border: Border.all(
                        color: Colors.black12),
                  ),
                  child: ClipRRect(borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      image2,
                      height: 148,
                      fit: BoxFit.cover,
                    ),
                  )),
            )
                : Padding(
              padding: const EdgeInsets.only(left: 40,right: 40,top: 10),
              child: Container(
                height: 150,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue.withOpacity(0.2),
                  border: Border.all(
                      color: Colors.black12),
                ),
                child: Center(
                  child: Icon(Icons.add_a_photo_outlined),
                ),
              ),
            ),
          ),
          // upload
          Padding(
            padding:
            const EdgeInsets.only(left: 18.0, right: 18.0, top: 60.0),
            child: InkWell(
              onTap: () {
                saveImage1ToUserProfile();
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.6,
                height: 50.0,
                decoration: BoxDecoration(
                  gradient: purpleGradient,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Upload",
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
                        image1 = File(file.path);
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
                      image1 = File(file.path);

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
  imagePickerModalBottomSheet2(context) {
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
                        image2 = File(file.path);
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
                      image2 = File(file.path);

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
  /// upload image 1
  saveImage1ToUserProfile()async{

    showDialogF(context);

    String name = DateTime.now().toString();
    // image1
    Reference reference =
    FirebaseStorage.instance.ref().child("UsersProfilePics/$name");

    //Upload the file to firebase
    UploadTask uploadTask = reference.putFile(image1);
    print("After UploadTask ${uploadTask}");
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

    print("After taskSnapshot ${taskSnapshot.ref}");
    // Waits till the file is uploaded then stores the download url
    String url = await taskSnapshot.ref.getDownloadURL();
    print("url $url");

    /// image 2
    String name2 = DateTime.now().toString();
    // image1
    Reference reference2 =
    FirebaseStorage.instance.ref().child("UsersProfilePics/$name2");

    //Upload the file to firebase
    UploadTask uploadTask2 = reference2.putFile(image2);
    print("After UploadTask ${uploadTask2}");
    TaskSnapshot taskSnapshot2 = await uploadTask2.whenComplete(() {});

    print("After taskSnapshot ${taskSnapshot2.ref}");
    // Waits till the file is uploaded then stores the download url
    String url2 = await taskSnapshot2.ref.getDownloadURL();
    print("url $url2");

    showDialogF(context);
    if(image1 == null){
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: "Choose an Image",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black38,
          textColor: Colors.white,
          fontSize: 15.0);
    }
    else {
      Map <String, dynamic> dataPut = { "ClinicImage1": url , "ClinicImage2" : url2};
      FirebaseFirestore.instance.collection("AllUsers").doc(
          FirebaseAuth.instance.currentUser.uid).
      update(dataPut).then((value) async {
        await saveImage1OfClinic(url,url2);
      });
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DoctorNabBarPage(),),);
    }
  }
}
