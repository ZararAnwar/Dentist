import 'dart:io';

import 'package:dr_dentist/Doctor-ShowCase/Create-Story/story-util.dart';
import 'package:dr_dentist/Doctor-ShowCase/Doctor-Nav-Bar-Page.dart';
import 'package:dr_dentist/Helper/show-Dialog-F.dart';
import 'package:dr_dentist/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class CreateAStory extends StatefulWidget {
  const CreateAStory({Key key}) : super(key: key);

  @override
  _CreateAStoryState createState() => _CreateAStoryState();
}

class _CreateAStoryState extends State<CreateAStory> {

  var now = DateTime.now();

  DocumentSnapshot doc;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  String nameString = 'name';
  String idString = 'userId';
  getUser() async {
    doc = await FirebaseFirestore.instance
        .collection("AllUsers")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();

    if (doc != null) {
      nameString = doc['name'];
      idString = doc['userId'];
      setState(() {});
    }
  }

  final TextEditingController descController = TextEditingController();

  File image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.cancel,color: B,))],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            /// image
            SizedBox(height: 30,),
            InkWell(
            onTap: () {
    imagePickerModalBottomSheet(context);
    },
        child: image != null
            ? Padding(
          padding: const EdgeInsets.only(left: 20,right: 20,top: 10),
          child: Container(
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: darkRedColor,
                border: Border.all(
                    color: darkRedColor),
              ),
              child: ClipRRect(borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  image,
                  height: 300,
                  width: MediaQuery.of(context).size.width * 0.9,
                  fit: BoxFit.cover,
                ),
              )),
        )
            : Padding(
          padding: const EdgeInsets.only(left: 20,right: 20,top: 10),
          child: Container(
            height: 300,
            width: MediaQuery.of(context).size.width * 0.9,
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
            /// write descrription
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 50,bottom: 60),
              child: TextFormField(
                controller: descController,
                obscureText: false,
                maxLines: 3,
                cursorColor: darkRedColor,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: B, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: B, width: 1),
                  ),
                  labelText: "Write something about your post...",
                  labelStyle: GoogleFonts.quicksand(
                    color: B,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            /// button post
            Padding(
              padding:
              const EdgeInsets.only(left: 18.0, right: 18.0, top: 10.0),
              child: InkWell(
                onTap: () {
                  post(context);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 50.0,
                  decoration: BoxDecoration(
                    color: darkRedColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Post",
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
  /// submit post
post(BuildContext context) async {

  showDialogF(context);

  String name = DateTime.now().toString();
  Reference reference = FirebaseStorage.instance.ref().child("StoryImages/$name");

  //Upload the file to firebase
  UploadTask uploadTask = reference.putFile(image);

  TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

  // Waits till the file is uploaded then stores the download url
  String url = await taskSnapshot.ref.getDownloadURL();

  String formattedDate = DateFormat('dd/MM/yyyy – kk:mm').format(now);


    CreateStory _story = CreateStory(
      doctorName: nameString,
      doctorId: idString,
      description: descController.text,
      image:  url.isEmpty ? 'StoryImage' : url,
      dateTimeNow: formattedDate,
    );
  FirebaseFirestore.instance
      .collection("NewStories")
      .add(_story.toMap())
      .then((value) {
    Navigator.of(context).pop();

    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => DoctorNabBarPage()));

    Fluttertoast.showToast(
        msg: "Story Published",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black38,
        textColor: Colors.white,
        fontSize: 15.0);
  });
}

}
