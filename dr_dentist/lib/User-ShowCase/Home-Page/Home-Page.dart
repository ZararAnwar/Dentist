import 'package:dr_dentist/Bottom-Nav/Main-Page.dart';
import 'package:dr_dentist/Doctor-ShowCase/Create-Story/story-util.dart';
import 'package:dr_dentist/Helper/Flutter-Drop-Down.dart';
import 'package:dr_dentist/Helper/show-Dialog-F.dart';
import 'package:dr_dentist/User-ShowCase/Home-Page/Doctor-Detail.dart';
import 'package:dr_dentist/User-ShowCase/Home-Page/review-to-Story.dart';
import 'package:dr_dentist/User-ShowCase/send-Appointment-Request/send-appointment-request.dart';
import 'package:dr_dentist/Utils/User.dart';
import 'package:dr_dentist/Utils/utils.dart';
import 'package:dr_dentist/Widgets/moods.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:core';
import 'package:google_fonts/google_fonts.dart';
import 'package:dr_dentist/favourite_screen.dart';
import 'package:dr_dentist/search_screen.dart';
import 'package:dr_dentist/video_disease.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';



final _firestore = FirebaseFirestore.instance;


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String sportTypeValue = "All";
   DocumentSnapshot doc;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  String nameString = 'name';
  getUser() async {
    doc = await FirebaseFirestore.instance
        .collection("AllUsers")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();

    if (doc != null) {
      nameString = doc['name'];
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Stack(
              alignment: AlignmentDirectional.topCenter,
              // overflow: Overflow.visible,
              children: <Widget>[
                _backBgCover(),
                _greetings(),
                _moodsHolder(),
              ],
            ),
            SizedBox(
              height: 50.0,
            ),
            /// stories
            Padding(
              padding: const EdgeInsets.only(left: 20,right: 20,top: 20),
              child: Row(
                children: [
                  Text("Doctor\'s Stories :",
                    style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 90,
              width: 230,
              // color: Colors.yellow,
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('NewStories')
                      .snapshots(),
                  builder:
                      (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Container(
                        child: Center(
                            child: CircularProgressIndicator(
                              color: darkRedColor,
                            )),
                      );
                    }
                    print(snapshot.data.docs.length.toString() +
                        "dddddddddddddd");
                    if (snapshot.data.docs.length == 0) {
                      return Container(
                          child: Center(
                            child: Text("Pas encore de données à afficher"),
                          ));
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (_, index) {
                            print(snapshot.data.docs[index].data());
                            CreateStory story = CreateStory.fromJson(
                              snapshot.data.docs[index].data() as Map<String, dynamic>,
                              snapshot.data.docs[index].id,
                            );
                            return Padding(
                              padding:
                              const EdgeInsets.only(left: 12),
                              child: InkWell(
                                onTap: (){
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Story(
                                    story.image,
                                    story.doctorName,
                                    story.dateTimeNow,
                                    story.description,
                                    story.doctorId,
                                  ),),);
                                },
                                child: Container(
                                  width: 70,
                                  height: 70,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image.network(
                                    story.image,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          }),
                    );
                  }),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20,right: 20,top: 20),
              child: Row(
                children: [
                  Text("Dental Expert\'s :",
                  style: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 5),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.filter_list,color: B,),
                  SizedBox(width: 5,),
                  Text(
                    'Filter by Category :',
                    style: GoogleFonts.quicksand(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 10,),
                  FlutterFlowDropDown(
                    options: [
                      'All',
                      'Orthodontist',
                      'Prosthodontist',
                      'Maxillofacial',
                      'Surgeon',
                      'Endodontist',
                    ].toList(),
                    onChanged: (val) => setState(() => sportTypeValue = val),
                    width: 120,
                    height: 40,
                    textStyle:  GoogleFonts.quicksand(
                      color: Colors.black,
                    ),
                    fillColor: Colors.white,
                    elevation: 2,
                    borderColor: Colors.transparent,
                    borderWidth: 0,
                    borderRadius: 10,
                    margin: EdgeInsetsDirectional.fromSTEB(8, 4, 8, 4),
                    hidesUnderline : true,
                  ),
                ],
              ),
            ),
            StreamSearchList(sportTypeValue: sportTypeValue),
          ],
        ),
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

  Positioned _moodsHolder() {
    return Positioned(
      bottom: -45,
      child: Container(
        height: 100.0,
        width: MediaQuery.of(context).size.width - 40,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                spreadRadius: 5.5,
                blurRadius: 5.5,
              )
            ]),
        child: MoodsSelector(),
      ),
    );
  }

  Container _backBgCover() {
    return Container(
      height: 260.0,
      decoration: BoxDecoration(
        gradient: purpleGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
    );
  }

  Positioned _greetings() {
    return Positioned(
      left: 20,
      bottom: 90,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Hi",
            style: GoogleFonts.allura(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          nameString != null ?
          Text(
            nameString,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ) :
          Text(
            'Dr_Dentist',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ) ,
          SizedBox(
            height: 10,
          ),
          Text(
            'How are you feeling today ?',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}



class StreamSearchList extends StatelessWidget {
  String sportTypeValue;
  StreamSearchList({this.sportTypeValue});

  String type = 'All';

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 500,
      child: StreamBuilder(
        stream: _firestore
            .collection('AllUsers')
            .where('Qualification', isEqualTo: sportTypeValue)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {

          if (snapshot.hasData) {
            if (snapshot.data.size > 0) {
              final messages = snapshot.data.docs.reversed;

              List<SearchItem> searchWidgets = [];
              for (var message in messages) {
                final name = message.get('name');
                final image = message.get('image');
                final image1 = message.get('ClinicImage1');
                final image2 = message.get('ClinicImage2');
                final qualification = message.get('Qualification');
                final responseTime = message.get('ResponseTime');
                final experience = message.get('Experience');
                final whatsappLink = message.get('WhatsAppLink');
                final address = message.get('ClinicAddress');
                final mainValue = message.get('mainValue');
                final openTime = message.get('OpenTime');
                final closeTime = message.get('CloseTime');
                final userId = message.get('userId');
                final token = message.get('fcm_token');

                final searchItem = SearchItem(
                  name: name,
                  image: image,
                  image1: image1,
                  image2: image2,
                  qualification: qualification,
                  response: responseTime,
                  exp: experience,
                  whatsApp: whatsappLink,
                  address: address,
                  mainValue: mainValue,
                  openTime: openTime,
                  closeTime: closeTime,
                  userId: userId,
                  fcmToken: token,
                );
                searchWidgets.add(searchItem);
              }
              return Container(
                height: 400,
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  children: searchWidgets,
                ),
              );
            } else if(sportTypeValue == type)
              return Container(
                height: 400,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 400,
                      child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('AllUsers')
                              .snapshots(),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return Container(
                                child: Center(
                                    child: CircularProgressIndicator(
                                      color: darkRedColor,
                                    )),
                              );
                            }
                            print(snapshot.data.docs.length.toString() +
                                "dddddddddddddd");
                            if (snapshot.data.docs.length == 0) {
                              return Container(
                                  child: Center(
                                    child: Text("Nothing Here"),
                                  ));
                            }
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 120),
                              child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                  physics: BouncingScrollPhysics(),
                                  itemCount: snapshot.data.docs.length,
                                  itemBuilder: (_, index) {
                                    print(snapshot.data.docs[index]);
                                    Userr event = Userr.fromJson(
                                      snapshot.data.docs[index].data() as Map<String, dynamic>,
                                    );
                                    SendAppointmentRequest review = SendAppointmentRequest.fromJson(
                                      snapshot.data.docs[index].data()
                                      as Map<String, dynamic>,
                                      snapshot.data.docs[index].id,
                                    );

                                    return event.mainValue == "Doctor" ?
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20,right: 20,top: 20),
                                      child: InkWell(
                                        onTap: (){
                                          print("nameeeeeeeeeee ========= ${event.name}");
                                          Navigator.of(context).
                                          push(MaterialPageRoute(builder: (context)=>DoctorDetail(
                                            event.name,
                                            event.image,
                                            event.clinicImage1,
                                            event.clinicImage2,
                                            event.qualification,
                                            event.responseTime,
                                            event.experience,
                                            event.doctorWhatsapp,
                                            event.address,
                                            event.mainValue,
                                            event.openTime,
                                            event.closeTime,
                                            event.userId,
                                            event.fcmToken,
                                            review,
                                          ),),);
                                        },
                                        child: Container(
                                          width: MediaQuery.of(context).size.width * 0.7,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black12,
                                                offset: Offset(2, 2),
                                                spreadRadius: 2,
                                                blurRadius: 2,
                                              )
                                            ],
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10, bottom: 10, left: 10, right: 10),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    /// container with name of doctor or image
                                                    Container(
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            width: 60,
                                                            height: 60,
                                                            clipBehavior: Clip.antiAlias,
                                                            decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                            ),
                                                            child: ClipRRect(
                                                              borderRadius: BorderRadius.circular(30),
                                                              child: Image.network(
                                                                event.image ??
                                                                    "https://image.shutterstock.com/image-vector/a-aa-letters-logo-monogram-260nw-716746858.jpg",
                                                                // story.image,
                                                                fit: BoxFit.cover,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(width: 10),
                                                          Container(
                                                            width: 120,
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Text(
                                                                  event.name ?? "Name",
                                                                  style: GoogleFonts.montserrat(
                                                                    color: Colors.black,
                                                                    fontSize: 16,
                                                                    fontWeight: FontWeight.w600,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  event.qualification ?? "Maxillofacial",
                                                                  style: GoogleFonts.montserrat(
                                                                    color: Colors.black,
                                                                    fontSize: 12,
                                                                    fontWeight: FontWeight.w400,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  event.doctorClinicAddress ?? "Address",
                                                                  style: GoogleFonts.montserrat(
                                                                    color: Colors.black,
                                                                    fontSize: 12,
                                                                    fontWeight: FontWeight.w400,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    /// rating or reviews
                                                    Padding(
                                                      padding: const EdgeInsets.only(bottom: 20),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            "5",
                                                            style: GoogleFonts.quicksand(
                                                              color: Colors.black,
                                                              fontSize: 8,
                                                              fontWeight: FontWeight.w800,
                                                            ),
                                                          ),
                                                          Icon(Icons.star,color: Colors.yellow,size: 14,),
                                                          Text(
                                                            "(22 Reviews)",
                                                            style: GoogleFonts.quicksand(
                                                              color: Colors.black,
                                                              fontSize: 8,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                /// response time or experience
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 15,left: 20,right: 20),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      // response time
                                                      Column(
                                                        children: [
                                                          Text(
                                                            "Response Time",
                                                            style: GoogleFonts.quicksand(
                                                              color:darkRedColor,
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w800,
                                                            ),
                                                          ),
                                                          Text(
                                                            event?.responseTime,
                                                            style: GoogleFonts.quicksand(
                                                              color: Colors.black,
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Container(
                                                        height: 30,
                                                        width: 2,
                                                        color: B.withOpacity(0.5),
                                                      ),
                                                      /// eexp
                                                      Column(
                                                        children: [
                                                          Text(
                                                            "Experience",
                                                            style: GoogleFonts.quicksand(
                                                              color: darkRedColor,
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w800,
                                                            ),
                                                          ),
                                                          Text(
                                                            event.experience,
                                                            style: GoogleFonts.quicksand(
                                                              color: Colors.black,
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ) : Container();
                                  }),
                            );
                          }),
                    ),
                    SizedBox(height: 50),
                  ],
                ),
              );
            else{
              return Column(
                children: [
                  SizedBox(height: 50,),
                  Text("No Doctor related to your category",
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ],
              );
            }
          } else {
            return Center(
                child: CircularProgressIndicator(
                    backgroundColor: Colors.deepPurple));
          }
        },
      ),
    );
  }
}

class SearchItem extends StatelessWidget {

  SearchItem({
    this.name,
    this.image,
    this.image1,
    this.image2,
    this.qualification,
    this.response,
    this.exp,
    this.whatsApp,
    this.address,
    this.mainValue,
    this.openTime,
    this.closeTime,
    this.userId,
    this.fcmToken,
    this.userr,
  });

  String  name,
      image,
      image1,
      image2,
      qualification,
      response,
      exp,
      whatsApp,
      address,
      mainValue,
      openTime,
      closeTime,
      userId,
      fcmToken;
  Userr userr;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('AllUsers').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Container(
                child: Center(
                    child: CircularProgressIndicator(
                      color:darkRedColor,
                    )),
              );
            }
            print(snapshot.data.docs.length.toString() + "dddddddddddddd");
            if (snapshot.data.docs.length == 0) {
              return Container(
                  child: Center(
                    child: Text("Pas encore de données à afficher"),
                  ));
            }
            return Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 50),
              child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: 1,
                  itemBuilder: (_, index) {
                    SendAppointmentRequest event = SendAppointmentRequest.fromJson(
                      snapshot.data.docs[index].data() as Map<String, dynamic>,
                      snapshot.data.docs[index].id,
                    );
                    print("Another try ${snapshot.data.docs[index].id}");
                    return okay(snapshot.data.docs[index], context, event);
                  }),
            );
          }),
    );
  }
  okay(QueryDocumentSnapshot doc, BuildContext context, SendAppointmentRequest request ){
    Userr user = Userr.fromJson(doc.data());
    return mainValue == "Doctor" ?
    Padding(
      padding: const EdgeInsets.only(left: 20,right: 20),
      child: InkWell(
        onTap: (){
          print("Myyyyyyyyyyyyyyyyyyyyyyyyyyy nameeeeeeeeeee ========= $name");
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DoctorDetail(
            name,
            image,
            image1,
            image2,
            qualification,
            response,
            exp,
            whatsApp,
            address,
            mainValue,
            openTime,
            closeTime,
            userId,
            fcmToken,
            request,
          ),),);
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 0.7,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(2, 2),
                spreadRadius: 2,
                blurRadius: 2,
              )
            ],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
                top: 10, bottom: 10, left: 10, right: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /// container with name of doctor or image
                    Container(
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.network(
                                image ??
                                    "https://image.shutterstock.com/image-vector/a-aa-letters-logo-monogram-260nw-716746858.jpg",
                                // story.image,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                            width: 120,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  name ?? "Name",
                                  style: GoogleFonts.montserrat(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  qualification ?? "Maxillofacial",
                                  style: GoogleFonts.montserrat(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  address ?? "Address",
                                  style: GoogleFonts.montserrat(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    /// rating or reviews
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        children: [
                          Text(
                            "5",
                            style: GoogleFonts.quicksand(
                              color: Colors.black,
                              fontSize: 8,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Icon(Icons.star,color: Colors.yellow,size: 14,),
                          Text(
                            "(22 Reviews)",
                            style: GoogleFonts.quicksand(
                              color: Colors.black,
                              fontSize: 8,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                /// response time or experience
                Padding(
                  padding: const EdgeInsets.only(top: 15,left: 20,right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // response time
                      Column(
                        children: [
                          Text(
                            "Response Time",
                            style: GoogleFonts.quicksand(
                              color:darkRedColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            response,
                            style: GoogleFonts.quicksand(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 30,
                        width: 2,
                        color: B.withOpacity(0.5),
                      ),
                      /// eexp
                      Column(
                        children: [
                          Text(
                            "Experience",
                            style: GoogleFonts.quicksand(
                              color: darkRedColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            exp,
                            style: GoogleFonts.quicksand(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ) : Container();
  }
}


class Story extends StatefulWidget {
  String image;
  String doctorName;
  String date;
  String detail;
  String doctorId;
   Story(this.image,this.doctorName,this.date,this.detail,this.doctorId,{Key key}) : super(key: key);

  @override
  _StoryState createState() => _StoryState();
}

class _StoryState extends State<Story> {

  final TextEditingController reviewController = TextEditingController();

  DocumentSnapshot doc;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  String nameString = 'name';
  String idString = 'userId';
  String imageString = 'image';
  getUser() async {
    doc = await FirebaseFirestore.instance
        .collection("AllUsers")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();

    if (doc != null) {
      nameString = doc['name'];
      idString = doc['userId'];
      imageString = doc['image'];
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Stack(
          // overflow: Overflow.visible,
          fit: StackFit.loose,
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Image.network(widget.image,fit: BoxFit.cover,),
            ),
            Positioned(
              top: 40,
              left: 20,right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.cancel,color: Colors.blue[900],)),
                  Text(widget.doctorName,
                  style: GoogleFonts.lexendExa(
                    color: Colors.blue[900],
                    fontSize: 16,fontWeight: FontWeight.w600,
                  ),
                  ),
                  Text(widget.date,
                  style: GoogleFonts.lexendExa(
                    color: Colors.blue[900],
                    fontSize: 8,fontWeight: FontWeight.w600,
                  ),
                  ),

                ],
              ),
            ),
            /// detail
            Positioned(
              top: 530,
              left: 100,
              right: 100,
              child: Center(
                child: InkWell(
                  onTap: ()async{
                    final shouldPop = await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        backgroundColor: Colors.white,
                        title: Column(
                          children: [
                            Icon(
                              Icons.details,
                              color: darkRedColor,
                              size: 30,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              widget.detail,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                color:darkRedColor,
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
                                  onTap: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: Container(
                                    height: 30,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      color: darkRedColor,
                                      borderRadius: BorderRadius.circular(7),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black12,
                                            offset: Offset(2, 2),
                                            spreadRadius: 2,
                                            blurRadius: 2)
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Ok",
                                        style: GoogleFonts.montserrat(
                                          color: Colors.white,
                                          fontSize: 14,
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
                  },
                  child: Container(
                    height: 35,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.blue[900],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text("Detail of Story",
                      style: GoogleFonts.quicksand(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight:FontWeight.w600,
                      ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            /// add comment
            Positioned(
              top: 600,
              left: 20,right: 20,
              child: TextFormField(
                controller: reviewController,
                obscureText: false,
                maxLines: 3,
                cursorColor: darkRedColor,
                decoration: InputDecoration(
                  suffixIcon: IconButton(onPressed: (){
                    giveReview();
                  }, icon: Icon(Icons.send,color: Colors.blue[900],)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: Colors.blue[900], width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: Colors.blue[900], width: 1),
                  ),
                  labelText: "Write comment about this post...",
                  labelStyle: GoogleFonts.quicksand(
                    color: Colors.blue[900],
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  giveReview(){
    var now = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy – kk:mm').format(now);


    showDialogF(context);
    if (reviewController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Fill the requiured fields",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black38,
          textColor: Colors.white,
          fontSize: 15.0);
      Navigator.pop(context);
    } else if(idString == widget.doctorId) {
      Fluttertoast.showToast(
          msg: "You cannot give review to yourself",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black38,
          textColor: Colors.white,
          fontSize: 15.0);
      Navigator.pop(context);
    }else{
      ReviewToDoctorStory data = ReviewToDoctorStory(
        review: reviewController.text,
        userId: idString,
        userName: nameString,
        doctorId: widget.doctorId,
        userImage: imageString,
        dateTimeNow: formattedDate,
        storyImage: widget.image,
      );

      FirebaseFirestore.instance
          .collection("ReviewToDoctorStory")
          .add(data.toMap())
          .then((value) {
        Navigator.of(context).pop();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => NavBarPage(),
          ),
        );

        Fluttertoast.showToast(
            msg: "Comment submitted successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black38,
            textColor: Colors.white,
            fontSize: 15.0);
      });
    }
  }
}
