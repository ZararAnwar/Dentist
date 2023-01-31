import 'package:dr_dentist/Doctor-ShowCase/Create-Story/Create-Story.dart';
import 'package:dr_dentist/Helper/Flutter-Drop-Down.dart';
import 'package:dr_dentist/Utils/User.dart';
import 'package:dr_dentist/Utils/utils.dart';
import 'package:dr_dentist/Widgets/moods.dart';
import 'package:dr_dentist/chat-with-doctors/chatter-screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';


final _firestore = FirebaseFirestore.instance;


class DoctorChatScreen extends StatefulWidget {
  const DoctorChatScreen({Key key}) : super(key: key);

  @override
  _DoctorChatScreenState createState() => _DoctorChatScreenState();
}

class _DoctorChatScreenState extends State<DoctorChatScreen> {


  String sportTypeValue = 'All';

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
            /// create a story
            Padding(
              padding: const EdgeInsets.only(top: 20,bottom: 10),
              child: InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CreateAStory(),),);
                },
                child: Container(
                  height: 45,
                  width: MediaQuery.of(context).size.width * 0.5,
                  decoration: BoxDecoration(
                    color: lightColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add,color: Colors.white,),
                      SizedBox(width: 7,),
                      Text("Create a Story",
                      style: GoogleFonts.quicksand(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            /// end
            /// filter by
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 15),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.filter_list,color: B,),
                  SizedBox(width: 5,),
                  Text(
                    'Filter by :',
                    style: GoogleFonts.quicksand(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 10,),
                  FlutterFlowDropDown(
                    options: [
                      'All',
                      'New',
                      'Most Recent',
                    ].toList(),
                    onChanged: (val) => setState(() => sportTypeValue = val),
                    width: 130,
                    height: 40,
                    textStyle: GoogleFonts.quicksand(
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
            // Padding(
            //   padding: const EdgeInsets.only(left: 20,right: 20,top: 20),
            //   child: Row(
            //     children: [
            //       Text("Your Chat\'s :",
            //         style: GoogleFonts.montserrat(
            //           color: Colors.black,
            //           fontSize: 16,
            //           fontWeight: FontWeight.w600,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // SingleChildScrollView(
            //   scrollDirection: Axis.vertical,
            //   child: Padding(
            //     padding: EdgeInsets.only(left: 20,right: 20,bottom: 20),
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.start,
            //       children: <Widget>[
            //         Container(
            //           height: MediaQuery.of(context).size.height,
            //           child: StreamBuilder(
            //               stream: FirebaseFirestore.instance
            //                   .collection('AllUsers')
            //                   .snapshots(),
            //               builder:
            //                   (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            //                 if (!snapshot.hasData) {
            //                   return Container(
            //                     child: Center(
            //                         child: CircularProgressIndicator(
            //                           color: darkRedColor,
            //                         )),
            //                   );
            //                 }
            //                 print(snapshot.data.docs.length.toString() +
            //                     "dddddddddddddd");
            //                 if (snapshot.data.docs.length == 0) {
            //                   return Container(
            //                       child: Center(
            //                         child: Text("Nothing Here"),
            //                       ));
            //                 }
            //                 return Padding(
            //                   padding:
            //                   const EdgeInsets.only(bottom: 50),
            //                   child: ListView.builder(
            //                       physics: BouncingScrollPhysics(),
            //                       itemCount: snapshot.data.docs.length,
            //                       itemBuilder: (_, index) {
            //                         return users(snapshot.data.docs[index]);
            //                       }),
            //                 );
            //               }),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
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
            'Health Care',
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

  /// doctore
  users(QueryDocumentSnapshot doc) {
    Userr user = Userr.fromJson(doc.data());
    return user.mainValue == "Patient" ?
    Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
      child: InkWell(
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
          ChatterScreen(
            receiverId: doc.id,
            userName: user.name,
            userImage: user.image,
          ),
          ),);
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
            child: Row(
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
                            user.image ??
                                "https://image.shutterstock.com/image-vector/a-aa-letters-logo-monogram-260nw-716746858.jpg",
                            // story.image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            user.name ?? "Name",
                            style: GoogleFonts.montserrat(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            user.address ?? "Address",
                            style: GoogleFonts.montserrat(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
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
                final address = message.get('Address');
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
                height: 500,
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  children: searchWidgets,
                ),
              );
            } else if(sportTypeValue == type)
              return Container(
                height: 450,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 450,
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
                              padding: const EdgeInsets.only(top: 20,bottom: 120),
                              child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  physics: BouncingScrollPhysics(),
                                  itemCount: snapshot.data.docs.length,
                                  itemBuilder: (_, index) {
                                    print(snapshot.data.docs[index]);
                                    Userr event = Userr.fromJson(
                                      snapshot.data.docs[index].data() as Map<String, dynamic>,
                                    );

                                    return event.mainValue == "Patient" ?
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20,right: 20),
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
                                                                event.address ?? "Address",
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
                                                ],
                                              ),
                                            ],
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
                  Text("No Patient related to your category",
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

  @override
  Widget build(BuildContext context) {
    return mainValue == "Patient" ?
    Padding(
      padding: const EdgeInsets.only(left: 20,right: 20),
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
                                address ?? "Address",
                                style: GoogleFonts.montserrat(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ) : Container();
  }
}