import 'package:dr_dentist/User-ShowCase/Review-A-Doctor/Review-A-Doctor-Util.dart';
import 'package:dr_dentist/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';



class MyReviews extends StatefulWidget {
  const MyReviews({Key key}) : super(key: key);

  @override
  _MyReviewsState createState() => _MyReviewsState();
}

class _MyReviewsState extends State<MyReviews> {

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Stack(
              alignment: AlignmentDirectional.topCenter,
              children: <Widget>[
                _backBgCover(),
                _search(),

              ],
            ),
            /// all reviews
            Container(
              height: 600,
              width: MediaQuery.of(context).size.width,
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('ReviewToAnDoctor')
                      .where('DoctorId', isEqualTo: idString)
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
            ),
          ],
        ),
      ),
    );
  }

  Container _backBgCover() {
    return Container(
      height: 200.0,
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
      top: 60,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Health Care',
            style:  GoogleFonts.quicksand(
              fontSize: 36,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Review about you are Here !',
            style: GoogleFonts.quicksand(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

}
