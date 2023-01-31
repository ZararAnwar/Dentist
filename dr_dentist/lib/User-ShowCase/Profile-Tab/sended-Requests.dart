
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_dentist/User-ShowCase/send-Appointment-Request/send-appointment-request.dart';
import 'package:dr_dentist/Utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class SendedRequests extends StatefulWidget {
  const SendedRequests({Key key}) : super(key: key);

  @override
  _SendedRequestsState createState() => _SendedRequestsState();
}

class _SendedRequestsState extends State<SendedRequests> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: lightColor,
        centerTitle: true,
        title: Text("All Requests",
        style: GoogleFonts.lexendExa(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('RequestForAppointment')
            .where("UserId", isEqualTo: FirebaseAuth.instance.currentUser.uid)
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
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 120),
            child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: snapshot.data.docs.length,
                itemBuilder: (_, index) =>
                    singleReviewItem(index, snapshot.data.docs,context)),
          );
        },
      ),
    );
  }
}



  singleReviewItem(int index, List<QueryDocumentSnapshot> docs,BuildContext context) {
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
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(2,2),
              spreadRadius: 2,
              blurRadius: 2,
            ),
          ],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: darkRedColor),
        ),
        child: Padding(
          padding:
          const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
          child: Column(
            children: [
              /// date or time
              Row(
                children: [
                  request.dateTimeNow != null ?
                  Text(request.dateTimeNow,
                    style: GoogleFonts.quicksand(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ) : Text(""),
                  Spacer(),
                  buttonsHandling(request, context),
                ],
              ),
              /// row of doctor image , name  , address
              Padding(
                padding: const EdgeInsets.only(left: 10,right: 10),
                child: Row(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          request.doctorImage != null ?
                          Container(
                            height: 70,
                            width: 70,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: Image.network(request.doctorImage,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ) : Container(),
                          SizedBox(width: 10,),
                          Column(
                            children: [
                              request.doctorName != null ?
                              Text(request.doctorName,
                                style: GoogleFonts.quicksand(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ) : Text(""),
                              request.doctorQualification != null ?
                              Text(request.doctorQualification,
                                style: GoogleFonts.quicksand(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ) : Text(""),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              /// location of clinic
              Padding(
                padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
                child: Row(
                  children: [
                    Icon(Icons.location_on,color: Colors.black,),
                    SizedBox(width: 15,),
                    request.doctorClinicAddress != null ?
                    Text(request.doctorClinicAddress,
                      style: GoogleFonts.quicksand(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ) : Text(""),
                  ],
                ),
              ),
              /// request
              Padding(
                padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
                child: Row(
                  children: [
                    Icon(Icons.assignment,color: Colors.black,),
                    SizedBox(width: 15,),
                    request.request != null ?
                    Container(
                      width: 200,
                      child: Text(request.request,
                        style: GoogleFonts.quicksand(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ) : Text(""),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buttonsHandling(SendAppointmentRequest request,BuildContext context) {
    // print("event eventstatus ${request.commentStatus}");
    if (request != null) {
      if (request.requestStatus == 'Pending')
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 40,
              width: MediaQuery.of(context).size.width * 0.3,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  "Pending",
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
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
              "Approved",
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


// class Detailed extends StatefulWidget {
//   SubmitReview request;
//   Detailed(this.request,{Key key}) : super(key: key);
//
//   @override
//   _DetailedState createState() => _DetailedState();
// }
//
// class _DetailedState extends State<Detailed> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: FlutterFlowTheme.primaryColor,
//         title: Text(
//           "Annonce",
//           style: GoogleFonts.montserrat(
//             color: Colors.white,
//             fontSize: 18,
//             fontWeight: FontWeight.w900,
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(15),
//         child: SingleChildScrollView(
//           scrollDirection: Axis.vertical,
//           child: Column(
//             children: [
//               Row(
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   Container(
//                     width: 120,
//                     height: 120,
//                     clipBehavior: Clip.antiAlias,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(15),
//                       color: Colors.yellow,
//                     ),
//                     child: Image.network(
//                       widget.request.eventImage,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsetsDirectional.fromSTEB(20, 10, 0, 10),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.max,
//                       children: [
//                         Container(
//                           width: 120,
//                           child: FittedBox(
//                             child: Center(
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.max,
//                                 children: [
//                                   Text(
//                                     widget.request.announcementName,
//                                     style: FlutterFlowTheme.bodyText1.override(
//                                       fontFamily: 'Poppins',
//                                       color: FlutterFlowTheme.black,
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                   widget.request.sportsType == null
//                                       ? Text(
//                                     "(Sports)",
//                                     style: FlutterFlowTheme.bodyText1
//                                         .override(
//                                       fontFamily: 'Poppins',
//                                       color: FlutterFlowTheme.black,
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   )
//                                       : Text(
//                                     " (" + widget.request.sportsType + ")",
//                                     style: FlutterFlowTheme.bodyText1
//                                         .override(
//                                       fontFamily: 'Poppins',
//                                       color: FlutterFlowTheme.black,
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 15,
//               ),
//               Row(
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   Icon(
//                     Icons.calendar_today,
//                     color: Colors.black,
//                     size: 24,
//                   ),
//                   SizedBox(
//                     width: 10,
//                   ),
//                   Column(
//                     children: [
//                       Text(
//                         widget.request.eventStartTime +
//                             " à " +
//                             widget.request.eventEndTime,
//                         style: FlutterFlowTheme.bodyText1.override(
//                           fontFamily: 'Poppins',
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       widget.event.eventEndDate == null
//                           ? Text(
//                         "Event end date/time",
//                         style: FlutterFlowTheme.bodyText1.override(
//                           fontFamily: 'Poppins',
//                           fontWeight: FontWeight.w500,
//                         ),
//                       )
//                           : Text(
//                         widget.event.eventEndDate,
//                         style: FlutterFlowTheme.bodyText1.override(
//                           fontFamily: 'Poppins',
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 5,
//               ),
//               Row(
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   Icon(
//                     Icons.location_on,
//                     color: Colors.black,
//                     size: 24,
//                   ),
//                   SizedBox(
//                     width: 10,
//                   ),
//                   Text(
//                     widget.event.announcementLocation,
//                     style: FlutterFlowTheme.bodyText1.override(
//                       fontFamily: 'Poppins',
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 15,
//               ),
//               Row(
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   Text(
//                     "Description :  ",
//                     style: FlutterFlowTheme.bodyText1.override(
//                       fontFamily: 'Poppins',
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//               widget.event.eventDesc == null
//                   ? Text(
//                 "(Desc)",
//                 style: FlutterFlowTheme.bodyText1
//                     .override(
//                   fontFamily: 'Poppins',
//                   color: FlutterFlowTheme.black,
//                   fontSize: 12,
//                   fontWeight: FontWeight.w600,
//                 ),
//               )
//                   : Text(
//                 widget.event.eventDesc,
//                 style: FlutterFlowTheme.bodyText1
//                     .override(
//                   fontFamily: 'Poppins',
//                   color: FlutterFlowTheme.black,
//                   fontSize: 12,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               SizedBox(height: 30),
//               Row(
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   Text(
//                     "Participants :  ",
//                     style: FlutterFlowTheme.bodyText1.override(
//                       fontFamily: 'Poppins',
//                       fontWeight: FontWeight.w700,
//                       fontSize: 18,
//                     ),
//                   ),
//                   widget.event.eventParticipants == null
//                       ? Text(
//                     "(Participants)",
//                     style: FlutterFlowTheme.bodyText1
//                         .override(
//                       fontFamily: 'Poppins',
//                       color: FlutterFlowTheme.black,
//                       fontSize: 12,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   )
//                       : Text(
//                     widget.event.eventParticipants,
//                     style: FlutterFlowTheme.bodyText1
//                         .override(
//                       fontFamily: 'Poppins',
//                       color: FlutterFlowTheme.black,
//                       fontSize: 12,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
