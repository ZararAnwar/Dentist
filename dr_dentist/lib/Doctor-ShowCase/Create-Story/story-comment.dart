import 'package:dr_dentist/User-ShowCase/Home-Page/review-to-Story.dart';
import 'package:dr_dentist/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';


class StoryComment extends StatefulWidget {
  const StoryComment({Key key}) : super(key: key);

  @override
  _StoryCommentState createState() => _StoryCommentState();
}

class _StoryCommentState extends State<StoryComment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: lightColor,
        automaticallyImplyLeading: false,
        title: Text(
          'Comments',
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
                .collection('ReviewToDoctorStory')
                .where("DoctorId",
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
                      ReviewToDoctorStory review = ReviewToDoctorStory.fromJson(
                        snapshot.data.docs[index].data() as Map<String, dynamic>,
                        snapshot.data.docs[index].id,
                      );

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
                                          child: Row(
                                            children: [
                                              Container(
                                                height: 60,
                                                width: 60,
                                                child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(30),
                                                    child: Image.network(review.userImage,fit: BoxFit.cover,)),
                                              ),
                                              SizedBox(width: 15,),
                                              Text(
                                                review.userName ?? 'n/a',
                                                style: GoogleFonts.quicksand(
                                                  color: B,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 40,
                                          width: 40,
                                          child: ClipRRect(
                                              borderRadius: BorderRadius.circular(30),
                                              child: Image.network(review.storyImage,fit: BoxFit.cover,)),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      review.review ?? 'n/a',
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
