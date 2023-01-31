import 'package:dr_dentist/Notification/Notification.dart';
import 'package:dr_dentist/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserNotification extends StatefulWidget {
  const UserNotification({Key key}) : super(key: key);

  @override
  _UserNotificationState createState() => _UserNotificationState();
}

class _UserNotificationState extends State<UserNotification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: lightColor,
        automaticallyImplyLeading: false,
        title: Text(
          'Notifications',
          style: GoogleFonts.lexendExa(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 4,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('PushNotifications')
                .where("userId",
                isEqualTo: FirebaseAuth.instance.currentUser.uid)
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
              print(snapshot.data.docs.length.toString() + "ffffffffffffffffff");
              if (snapshot.data.docs.length == 0) {
                return Container(
                    child: Center(
                      child: Text("Nothing Here"),
                    ));
              }
              return Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: BouncingScrollPhysics(),
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (_, index) {
                      NotificationModel notification =
                      NotificationModel.fromJson(
                        snapshot.data.docs[index].data() as Map<String, dynamic>,
                        snapshot.data.docs[index].id,
                      );

                      String title = notification.title;
                      print(title);

                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            child: Container(
                              // height: 80,
                              width:double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    offset: Offset(2, 2),
                                    blurRadius: 2,
                                    spreadRadius: 2,
                                  )
                                ],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    10, 10, 10, 10),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: 260,
                                          child: Center(
                                            child: Text(
                                              notification.title ?? 'n/a',
                                              style: GoogleFonts.quicksand(
                                                color: B,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                            onTap: () async {
                                              final shouldPop = await showDialog(
                                                context: context,
                                                builder: (context) => AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(15),
                                                  ),
                                                  backgroundColor:
                                                  Colors.red[900],
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
                                                        'Are you sure to delete this notification ?',
                                                        textAlign:
                                                        TextAlign.center,
                                                        style: GoogleFonts
                                                            .montserrat(
                                                          color: Colors.white,
                                                          fontSize: 15,
                                                          fontWeight:
                                                          FontWeight.w400,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              Navigator.of(
                                                                  context)
                                                                  .pop(false);
                                                            },
                                                            child: Container(
                                                              height: 30,
                                                              width: 70,
                                                              decoration:
                                                              BoxDecoration(
                                                                color:
                                                                Colors.white,
                                                                borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                    7),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                      color: Colors
                                                                          .black12,
                                                                      offset:
                                                                      Offset(
                                                                          2,
                                                                          2),
                                                                      spreadRadius:
                                                                      2,
                                                                      blurRadius:
                                                                      2)
                                                                ],
                                                              ),
                                                              child: Center(
                                                                child: Text(
                                                                  "No",
                                                                  style: GoogleFonts
                                                                      .montserrat(
                                                                    color: Colors
                                                                        .red[900],
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
                                                            onTap: () async{
                                                              await FirebaseFirestore.
                                                              instance.runTransaction((Transaction myTransaction) async {
                                                                await myTransaction.delete(snapshot.data.docs[index].reference);
                                                              });
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Container(
                                                              height: 30,
                                                              width: 70,
                                                              decoration:
                                                              BoxDecoration(
                                                                color:
                                                                Colors.white,
                                                                borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                    7),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                      color: Colors
                                                                          .black12,
                                                                      offset:
                                                                      Offset(
                                                                          2,
                                                                          2),
                                                                      spreadRadius:
                                                                      2,
                                                                      blurRadius:
                                                                      2)
                                                                ],
                                                              ),
                                                              child: Center(
                                                                child: Text(
                                                                  "Yes",
                                                                  style: GoogleFonts
                                                                      .montserrat(
                                                                    color: Colors
                                                                        .red[900],
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
                                            child: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            )),
                                      ],
                                    ),
                                    Text(
                                      notification.message ?? 'n/a',
                                      style: GoogleFonts.quicksand(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
              );
            }),
      ),
    );
  }
}
