import 'package:dr_dentist/Constant/Notification-Model.dart';
import 'package:dr_dentist/Constant/server-key-constant.dart';
import 'package:dr_dentist/Notification/Notification.dart' as notifModel;
import 'package:dr_dentist/Notification/Notification.dart';
import 'package:dr_dentist/User-ShowCase/send-Appointment-Request/send-appointment-request.dart';
import 'package:dr_dentist/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';



class DoctorRequestsScreen extends StatefulWidget {
  const DoctorRequestsScreen({Key key}) : super(key: key);

  @override
  _DoctorRequestsScreenState createState() => _DoctorRequestsScreenState();
}

class _DoctorRequestsScreenState extends State<DoctorRequestsScreen> {

  BuildContext myContext;
  String dummyImage =
      'https://talbottinn.com/wp-content/uploads/2013/11/dummy-image-landscape-300x171.jpg';

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          /// bg
          Stack(
            // overflow: Overflow.visible,
            fit: StackFit.loose,
            alignment: AlignmentDirectional.topCenter,
            children: <Widget>[
              _backBgCover(),
              _search(),
            ],
          ),
          /// appointments
          Container(
            height: 500,
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('RequestForAppointment')
                    .where("DoctorId", isEqualTo: idString)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Container(
                      child: Center(
                          child: CircularProgressIndicator(
                            color: darkRedColor,
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
                    padding: const EdgeInsets.only(top: 20, bottom: 120),
                    child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (_, index) =>
                            allAppointments(index, snapshot.data.docs)),
                  );
                }),
          ),
        ],
      ),
    );
  }

  /// appointments
  allAppointments(int index, List<QueryDocumentSnapshot> docs) {
    print('\n.\n\n.\n  docs[index] ${docs[index].data()}');
    SendAppointmentRequest request = SendAppointmentRequest.fromJson(
      docs[index].data() as Map<String, dynamic>,
      docs[index].id,
    );
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.black12.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding:
          const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
          child: Column(
            children: [
              /// row of name image or delete option
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Row(
                      children: [
                        request.userImage != null
                            ? Container(
                          height: 30,
                          width: 30,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                request == null || request.userImage == null
                                    ? dummyImage
                                    : request.userImage,
                                fit: BoxFit.cover,
                              )),
                        )
                            : Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                dummyImage,
                                fit: BoxFit.cover,
                              )),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        request.userName != null
                            ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              request.userName,
                              style: GoogleFonts.montserrat(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                            : Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "",
                              style: GoogleFonts.montserrat(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                      onTap: () async {
                        final shouldPop = await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
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
                                  'Are you sure to delete this request ?',
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
                                      onTap: () {
                                        Navigator.of(context).pop(false);
                                      },
                                      child: Container(
                                        height: 30,
                                        width: 70,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.circular(7),
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
                                            "No",
                                            style: GoogleFonts.montserrat(
                                              color: Colors.red[900],
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        final collection = FirebaseFirestore
                                            .instance
                                            .collection('RequestForAppointment');
                                        collection
                                            .doc(request
                                            .id) // <-- Doc ID to be deleted.
                                            .delete() // <-- Delete
                                            .then((_) => print('Deleted'))
                                            .catchError((error) =>
                                            print('Delete failed: $error'));
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        height: 30,
                                        width: 70,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.circular(7),
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
                                            "Yes",
                                            style: GoogleFonts.montserrat(
                                              color: Colors.red[900],
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
                      },
                      child: Icon(Icons.delete, color: Colors.red)),
                ],
              ),
              // review
              request.request != null
                  ? Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  request.request,
                  maxLines: 2,
                  style: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              )
                  : Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "",
                  maxLines: 2,
                  style: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              // divider
              Padding(
                padding:
                EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                child: Divider(
                  thickness: 2,
                  color: Colors.black12,
                ),
              ),
              /// accept or either declined
              buttonsHandling(request),
            ],
          ),
        ),
      ),
    );
  }
  Container _backBgCover() {
    return Container(
      height: 180.0,
      decoration: BoxDecoration(
        gradient: purpleGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
    );
  }

  Positioned _search() {
    return Positioned(
      left: 20,
      top: 55,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Dr_Dentist',
            style: GoogleFonts.quicksand(
              fontSize: 36,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'All your Appointments are Here..!! ',
            style: GoogleFonts.quicksand(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  /// button handling
  buttonsHandling(SendAppointmentRequest request) {
    print("request requeststatus ${request.requestStatus}");
    if (request != null) {
      if (request.requestStatus == 'Pending')
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => rejectCommentRequest(request: request),
              child: Container(
                height: 40,
                width: MediaQuery.of(context).size.width * 0.3,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    "Reject",
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            GestureDetector(
              onTap: () {
                acceptCommentRequest(request: request);
              },
              child: Container(
                height: 40,
                width: MediaQuery.of(context).size.width * 0.3,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    "Accept",
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      else if (request.requestStatus == 'Approved')
        return Container(
          height: 40,
          width: MediaQuery.of(context).size.width * 0.3,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              "Accepted",
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      else if (request.requestStatus == 'Rejected')
        return Container(
          height: 40,
          width: MediaQuery.of(context).size.width * 0.3,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              "Rejected",
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      else
        return Container();
    }
  }
/// handling end


/// accept or declined request

  acceptCommentRequest({SendAppointmentRequest request}) {
      sendNotification(
        myContext,
        msg: 'Approved',
        request: request,
      );
  }

  rejectCommentRequest({SendAppointmentRequest request}) {
      sendNotification(
        myContext,
        msg: 'Rejected',
        request: request,
      );
  }

  sendNotification(BuildContext context,
      {String msg, SendAppointmentRequest request}) async {
    Dio dio = new Dio();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers['authorization'] = serverKey;

    String senderToken = request.fcmTokenOfUser;

    print("firebaseToken ${request.fcmTokenOfUser}");

    NotificationModelOne _notification = new NotificationModelOne(
        title: "Your appointment request is $msg",
        body: 'The appointment request you are submitted to ${request.doctorName} is $msg');

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
      userId: request.userId,
    );

    FirebaseFirestore.instance
        .collection("PushNotifications")
        .add(_pushNotification.toMap())
        .then((value) {
      print("Data saved to push Notifications");
    });
  }

/// end
}
