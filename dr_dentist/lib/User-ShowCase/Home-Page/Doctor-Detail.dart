
import 'package:dr_dentist/Bottom-Nav/Main-Page.dart';
import 'package:dr_dentist/Constant/Notification-Model.dart';
import 'package:dr_dentist/Constant/server-key-constant.dart';
import 'package:dr_dentist/Helper/show-Dialog-F.dart';
import 'package:dr_dentist/User-ShowCase/Home-Page/Home-Page.dart';
import 'package:dr_dentist/User-ShowCase/Review-A-Doctor/Review-A-Doctor-Util.dart';
import 'package:dr_dentist/User-ShowCase/send-Appointment-Request/send-appointment-request.dart';
import 'package:dr_dentist/Utils/User.dart';
import 'package:dr_dentist/Utils/utils.dart';
import 'package:dr_dentist/chat-with-doctors/chatter-screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:flutter_image_slider/carousel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:dr_dentist/Notification/Notification.dart' as notifModel;
import 'package:dr_dentist/Notification/Notification.dart';

class DoctorDetail extends StatefulWidget {
  String name;
  String image;
  String image1;
  String image2;
  String qualification;
  String responseTime;
  String exp;
  String whatsapp;
  String address;
  String mainValue;
  String openTime;
  String closeTime;
  String userId;
  String token;
  SendAppointmentRequest request;
   DoctorDetail(this.name,this.image,this.image1,this.image2,this.qualification,
       this.responseTime,this.exp,this.whatsapp,this.address, this.mainValue,
       this.openTime,this.closeTime,this.userId,this.token,this.request, {Key key}) : super(key: key);

  @override
  _DoctorDetailState createState() => _DoctorDetailState();
}

class _DoctorDetailState extends State<DoctorDetail> {

  BuildContext myContext;
  DocumentSnapshot doc;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  String nameString = 'name';
  String idString = 'userId';
  String imageString = 'image';
  String tokenString = 'fcm_token';
  getUser() async {
    doc = await FirebaseFirestore.instance
        .collection("AllUsers")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();

    if (doc != null) {
      nameString = doc['name'];
      idString = doc['userId'];
      imageString = doc['image'];
      tokenString = doc['fcm_token'];
      setState(() {});
    }
  }

  String dropdownValue = '1';
  List <String> spinnerItems = [
    '1',
    '2',
    '3',
    '4',
    '5',
  ] ;

  final TextEditingController appointmentRequestController = TextEditingController();
  final TextEditingController reviewController = TextEditingController();
  final TextEditingController requestForAppointment = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: lightColor,
        centerTitle: true,
        title: Text("Dr Dentist",
          style: GoogleFonts.lexendExa(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            /// image, name, quialification and review of dcotor
            Padding(
              padding: const EdgeInsets.only(top: 20,left: 15,right: 15),
              child: Container(
                child: Row(
                  children: [
                    /// give review to doctor criteria
                    Stack(
                      // overflow: Overflow.visible,
                      fit: StackFit.loose,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.yellow,
                          ),
                          child: Image.network(
                            widget.image,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          left: 100,
                          top: 95,
                          child: InkWell(
                            onTap: (){
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        backgroundColor: Colors.white,
                                        title: Column(
                                          children: [
                                            // cancel icon
                                            Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Row(
                                                children: [
                                                  Spacer(),
                                                  InkWell(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Icon(
                                                        Icons.cancel_outlined,
                                                        color: Colors.black,
                                                      )),
                                                ],
                                              ),
                                            ),
                                            // give a review
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, right: 10, top: 20),
                                              child: Text(
                                                "Write review about ${widget.name} :",
                                                style: GoogleFonts.quicksand(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                            /// rating
                                            Padding(
                                              padding: const EdgeInsets.only(right: 10),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  DropdownButton<String>(
                                                    value: dropdownValue,
                                                    icon: Icon(Icons.arrow_drop_down),
                                                    iconSize: 24,
                                                    elevation: 16,
                                                    style: TextStyle(color: Colors.black, fontSize: 18),
                                                    underline: Container(
                                                      height: 1,
                                                      color: darkRedColor,
                                                    ),
                                                    onChanged: (String data) {
                                                      setState(() {
                                                        dropdownValue = data;
                                                      });
                                                    },
                                                    items: spinnerItems.map<DropdownMenuItem<String>>((String value) {
                                                      return DropdownMenuItem<String>(
                                                        value: value,
                                                        child: Text(value),
                                                      );
                                                    }).toList(),
                                                  ),
                                                  SizedBox(width: 5,),
                                                  Icon(Icons.star,color: Colors.yellow,size: 18,),
                                                ],
                                              ),
                                            ),
                                            /// review
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  top: 20,
                                                  bottom: 50),
                                              child: TextFormField(
                                                controller: reviewController,
                                                obscureText: false,
                                                maxLines: 3,
                                                cursorColor:darkRedColor,
                                                decoration: InputDecoration(
                                                  focusedBorder: OutlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(10),
                                                    borderSide: BorderSide(
                                                        color: Colors.black,
                                                        width: 1),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(10),
                                                    borderSide: BorderSide(
                                                        color:Colors.black,
                                                        width: 1),
                                                  ),
                                                  labelText:
                                                  "${widget.name} is ...",
                                                  labelStyle: GoogleFonts.quicksand(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // submit
                                            InkWell(
                                              onTap: () {
                                                submitReviewAboutUser();
                                              },
                                              child: Container(
                                                height: 40,
                                                width: 140,
                                                decoration: BoxDecoration(
                                                  color:
                                                  darkRedColor,
                                                  borderRadius:
                                                  BorderRadius.circular(12),
                                                  border: Border.all(
                                                      color: Colors.white),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black12,
                                                      offset: Offset(1, 1),
                                                      spreadRadius: 1,
                                                      blurRadius: 1,
                                                    )
                                                  ],
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    "Submit",
                                                    style: GoogleFonts.quicksand(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 16,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            },
                            child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: lightColor,
                                ),
                                child: Icon(Icons.edit,color: Colors.white,size: 20,)),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding:
                      EdgeInsetsDirectional.fromSTEB(20, 10, 0, 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            height: 40,
                            width: 150,
                            child: FittedBox(
                              child: Center(
                                child: Text(
                                widget.name,
                                  style: GoogleFonts.quicksand(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          widget.qualification == null
                              ? Text(
                            "Maxillofacial",
                            style: GoogleFonts.quicksand(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                              : Text(
                            widget.qualification,
                          ),
                          SizedBox(height: 5,),
                          Row(
                            children: [
                              Text(
                                "5",
                                style: GoogleFonts.quicksand(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Icon(Icons.star,color: Colors.yellow,size: 18,),
                              Text(
                                "(22 Reviews)",
                                style: GoogleFonts.quicksand(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
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
            /// location timings , images
            Padding(
              padding: const EdgeInsets.only(left: 15,right: 15,top: 30),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: Colors.black,
                    size: 24,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Row(
                    children: [
                      Text(
                        widget.openTime,
                        style: GoogleFonts.quicksand(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                       "  to  ",
                        style: GoogleFonts.quicksand(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      widget.closeTime == null
                          ? Text(
                        "Event end date/time",
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.w500,
                        ),
                      )
                          : Text(
                        widget.closeTime,
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15,right: 15,top:15),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Icon(
                    Icons.location_on,
                    color: Colors.black,
                    size: 24,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  widget.openTime == null
                      ? Text(
                    "Address",
                    style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.w500,
                    ),
                  )
                      : Text(
                    widget.openTime,
                    style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            /// chat whatsapp images directions
            Padding(
              padding: const EdgeInsets.only(top: 20,bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                      onTap: ()=> launchUrL(),
                      child: myCont("WhatsApp", Colors.green,Icons.call)),
                  SizedBox(width: 15,),
                  InkWell(
                      onTap: (){
                        if(idString == widget.userId){
                          Fluttertoast.showToast(
                              msg: "You cannot send message to yourself",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black38,
                              textColor: Colors.white,
                              fontSize: 15.0);
                        }
                        else {
                          print("idddd of reciever === ${widget.userId}");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ChatterScreen(
                                    receiverId: widget.userId,
                                    userName: widget.name,
                                    userImage: widget.image,
                                  ),
                            ),
                          );
                        }
                      },
                      child: myCont("Chat", Colors.blue,Icons.message)),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                    onTap: (){
                      Navigator.of(context).
                      push(MaterialPageRoute(builder: (context)=>
                          ShowClinicImages(
                            widget.image1,
                            widget.image2,
                          ),),);
                    },
                    child: myCont("Images", Colors.purple,Icons.camera)),
                SizedBox(width: 15,),
                InkWell(
                    onTap: () {
                      MapsLauncher.launchQuery(
                          widget.address);
                    },
                    child: myCont("Directions", Colors.red,Icons.add_location)),
              ],
            ),
            /// send a appointment request
            SizedBox(height: 10,),
            InkWell(
              onTap: (){
                showDialog(
                    context: context,
                    builder: (context) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: Colors.white,
                          title: Column(
                            children: [
                              // cancel icon
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Spacer(),
                                    InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Icon(
                                          Icons.cancel_outlined,
                                          color: Colors.black,
                                        )),
                                  ],
                                ),
                              ),
                              // give a review
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 20),
                                child: Text(
                                  "Send Appointment Request to ${widget.name} :",
                                  style: GoogleFonts.quicksand(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              /// review
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                    top: 20,
                                    bottom: 50),
                                child: TextFormField(
                                  controller: requestForAppointment,
                                  obscureText: false,
                                  maxLines: 3,
                                  cursorColor:darkRedColor,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Colors.black,
                                          width: 1),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color:Colors.black,
                                          width: 1),
                                    ),
                                    labelText:
                                    "I need appointment on...",
                                    labelStyle: GoogleFonts.quicksand(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                              // submit
                              InkWell(
                                onTap: () {
                                  sendAppointmentRequest();
                                  acceptCommentRequest(request: widget.request);
                                },
                                child: Container(
                                  height: 40,
                                  width: 180,
                                  decoration: BoxDecoration(
                                    color:
                                    darkRedColor,
                                    borderRadius:
                                    BorderRadius.circular(12),
                                    border: Border.all(
                                        color: Colors.white),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        offset: Offset(1, 1),
                                        spreadRadius: 1,
                                        blurRadius: 1,
                                      )
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Submit Request",
                                      style: GoogleFonts.quicksand(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              },
              child: Container(
                height: 40,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(
                    color: Colors.black12,
                    offset: Offset(3,3),
                    spreadRadius: 3,
                    blurRadius: 3,
                  )],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.edit_outlined,color: Colors.black,size: 14,),
                    SizedBox(width: 5,),
                    Text("Send Appointment Request",
                      style: GoogleFonts.quicksand(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            /// reviews
            Padding(
              padding: const EdgeInsets.only(top: 30,left: 15,right: 15),
              child: Row(
                children: [
                  Text(
                    "All Review\'s :",
                    style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            ReviewOfAnDoctor(
              nameString,
              imageString,
              idString,
              widget.userId,
            ),
          ],
        ),
      ),
    );
  }
  /// whatsapp url launcher
  void launchUrL() async => await canLaunch(widget.whatsapp)
      ? await launch(widget.whatsapp)
      : throw 'Could not launch $widget.event.whatsappLink!';
  /// 4 containers
Container myCont(String title, Color color,IconData iconData){
    return Container(
      height: 40,
      width: 110,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(iconData,color: Colors.white,),
          SizedBox(width: 5,),
          Text(title,
            style: GoogleFonts.quicksand(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
}

  /// submit a review about user
  submitReviewAboutUser() {

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy – kk:mm').format(now);

    showDialogF(context);
    if (reviewController.text.isEmpty || dropdownValue.isEmpty) {
      Fluttertoast.showToast(
          msg: "Fill teh required fields",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black38,
          textColor: Colors.white,
          fontSize: 15.0);
      Navigator.pop(context);
    } else{
      ReviewAnDoctor data = ReviewAnDoctor(
        review: reviewController.text,
        rating: dropdownValue,
        userName: nameString,
        userImage: imageString,
        userId: idString,
        doctorId: widget.userId,
        dateTimeNow: formattedDate,
      );

      FirebaseFirestore.instance
          .collection("ReviewToAnDoctor")
          .add(data.toMap())
          .then((value) {
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>NavBarPage(),),);

        Fluttertoast.showToast(
            msg: "Review submitted successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black38,
            textColor: Colors.white,
            fontSize: 15.0);
      });
    }
  }
  /// send appointment request
  sendAppointmentRequest(){
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy – kk:mm').format(now);

    showDialogF(context);
    if (requestForAppointment.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Fill teh required fields",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black38,
          textColor: Colors.white,
          fontSize: 15.0);
      Navigator.pop(context);
    } else{
      SendAppointmentRequest data = SendAppointmentRequest(
        request: requestForAppointment.text,
        userName: nameString,
        userImage: imageString,
        userId: idString,
        doctorId: widget.userId,
        dateTimeNow: formattedDate,
        fcmTokenOfDoctor: widget.token,
        fcmTokenOfUser: tokenString,
        requestStatus: "Pending",
        doctorImage: widget.image,
        doctorName: widget.name,
        doctorClinicAddress: widget.address,
        doctorQualification: widget.qualification,
      );

      FirebaseFirestore.instance
          .collection("RequestForAppointment")
          .add(data.toMap())
          .then((value) {
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>NavBarPage(),),);

        Fluttertoast.showToast(
            msg: "Request submitted successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black38,
            textColor: Colors.white,
            fontSize: 15.0);
      });
    }
  }
  /// send not to admin
  acceptCommentRequest({SendAppointmentRequest request}) {
      sendNotification(
        myContext,
        msg: 'Pending',
        request: request,
      );
  }


  sendNotification(BuildContext context,
      {String msg, SendAppointmentRequest request}) async {
    Dio dio = new Dio();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers['authorization'] = serverKey;

    String senderToken = widget.token;

    print("firebaseToken ${widget.token}");

    NotificationModelOne _notification = new NotificationModelOne(
        title: "$nameString send appointment request",
        body: '$nameString send appointment request');

    NotificationRequest _notifModel =
    new NotificationRequest(notification: _notification, to: senderToken);

    try {
      var response = await dio.post(
        url,
        data: _notifModel.toJson(),
        options: Options(
          followRedirects: false,
          validateStatus: (status) {
            print("response code $status");
            if (status == 200) {
              updateCommentStatus(context, msg, request.id);
              saveNotificationInDatabase(_notification,request);
            } else
              myErrorHandler(status);
            return;
          },
        ),
      );
      print("MY Response $response");
    } catch (e) {
      print("ERROR in sending Notification");
    }
  }

  updateCommentStatus(
      BuildContext context,
      String status,
      String requestId,
      ) {
    Map<String, dynamic> dataPut = {"RequestStatus": status};
    print("requestId $requestId");

    FirebaseFirestore.instance
        .collection("RequestForAppointment")
        .doc(requestId)
        .update(dataPut)
        .then((value) async {
      print("dataPut $dataPut");
    });
  }

  void saveNotificationInDatabase(NotificationModelOne notification, SendAppointmentRequest request) {
    notifModel.NotificationModel _pushNotification =
    notifModel.NotificationModel(
      title: notification.title,
      message: notification.body,
      userId: widget.userId,
    );

    FirebaseFirestore.instance
        .collection("PushNotifications")
        .add(_pushNotification.toMap())
        .then((value) {
      print("Data saved to push Notifications");
    });
  }
}


class ShowClinicImages extends StatefulWidget {
  String image1;
  String image2;
   ShowClinicImages(this.image1,this.image2,{Key key}) : super(key: key);

  @override
  _ShowClinicImagesState createState() => _ShowClinicImagesState();
}

class _ShowClinicImagesState extends State<ShowClinicImages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: EdgeInsets.only(left: 250, bottom: 20),
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: darkRedColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 300,
            width: MediaQuery.of(context).size.width,
            child: Carousel(
                indicatorBarColor: Colors.transparent,
                autoScrollDuration: Duration(seconds: 2),
                animationPageDuration: Duration(milliseconds: 300),
                activateIndicatorColor: Colors.black,
                animationPageCurve: Curves.bounceInOut,
                indicatorBarHeight: 20,
                indicatorHeight: 8,
                indicatorWidth: 8,
                unActivatedIndicatorColor: Colors.grey,
                stopAtEnd: false,
                autoScroll: true,
                // widgets
                items: [
                  Container(
                    alignment: Alignment.center,
                    height: 300,
                    width: double.infinity,
                    child: Image.network(widget.image1,fit: BoxFit.cover,),
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 300,
                    width: double.infinity,
                    child: Image.network(widget.image2,fit: BoxFit.cover,),
                  ),
                ],
            ),
          ),
        ],
      ),
    );
  }
}


class ReviewOfAnDoctor extends StatefulWidget {
  String userName;
  String userImage;
  String userId;
  String doctorId;
   ReviewOfAnDoctor(
       this.userId,this.userName,
      this.userImage,this.doctorId,{Key key}) : super(key: key);

  @override
  _ReviewOfAnDoctorState createState() => _ReviewOfAnDoctorState();

}

class _ReviewOfAnDoctorState extends State<ReviewOfAnDoctor> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 700,
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('ReviewToAnDoctor')
              .where('DoctorId', isEqualTo: widget.doctorId)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(
                    color: darkRedColor,
                  ),
                ),
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
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  physics: BouncingScrollPhysics(),
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (_, index) {
                    print(snapshot.data.docs[index]);
                    ReviewAnDoctor review = ReviewAnDoctor.fromJson(
                      snapshot.data.docs[index].data(),
                      snapshot.data.docs[index].id,
                    );
                    return Padding(
                      padding:
                      const EdgeInsets.only(left: 20, right: 20, top: 10),
                      child: Container(
                        // height : 150,
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              offset: Offset(2, 2),
                              blurRadius: 2,
                              spreadRadius: 2,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 10, left: 15, right: 15),
                          child: Column(
                            children: [
                              /// 1st Row of user who give review
                              Stack(
                                // overflow: Overflow.visible,
                                fit: StackFit.loose,
                                children: [
                                  Container(
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 40,
                                          width: 40,
                                          child: review.userImage != null
                                              ? ClipRRect(
                                            borderRadius:
                                            BorderRadius.circular(20),
                                            child: Image.network(
                                              review.userImage,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                              : Container(),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Container(
                                          width: 200,
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                review.userName != null
                                                    ? Text(
                                                  review.userName,
                                                  style: GoogleFonts
                                                      .montserrat(
                                                    color: Colors.black,
                                                    fontSize: 18,
                                                    fontWeight:
                                                    FontWeight.w600,
                                                  ),
                                                )
                                                    : Text(""),
                                                review.rating != null
                                                    ? Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      review.rating,
                                                      style: GoogleFonts
                                                          .montserrat(
                                                        color: Colors
                                                            .black54,
                                                        fontSize: 14,
                                                        fontWeight:
                                                        FontWeight
                                                            .w500,
                                                      ),
                                                    ),
                                                    Icon(
                                                      Icons.star,
                                                      color:
                                                      Colors.yellow,
                                                      size: 20,
                                                    ),
                                                  ],
                                                )
                                                    : Row(),
                                                review.review != null
                                                    ? Text(
                                                  review.review,
                                                  style: GoogleFonts
                                                      .montserrat(
                                                    color: Colors.black54,
                                                    fontSize: 14,
                                                    fontWeight:
                                                    FontWeight.w500,
                                                  ),
                                                )
                                                    : Text(""),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    child: Column(
                                      children: [
                                        review.dateTimeNow != null
                                            ? Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 15),
                                          child: Text(
                                            review.dateTimeNow,
                                            style: GoogleFonts.montserrat(
                                              color: Colors.black54,
                                              fontSize: 8,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        )
                                            : Text("date"),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            );
          }),
    );
  }
}



int myErrorHandler(int status) {
  showToast("Error $status");
  print("Custom Error $status");
}

showToast(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black38,
      textColor: Colors.white,
      fontSize: 15.0);
}
