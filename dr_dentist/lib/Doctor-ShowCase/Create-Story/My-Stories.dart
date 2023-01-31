import 'package:dr_dentist/Doctor-ShowCase/Create-Story/Create-Story.dart';
import 'package:dr_dentist/Doctor-ShowCase/Create-Story/story-util.dart';
import 'package:dr_dentist/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';


class MyStories extends StatefulWidget {
  const MyStories({Key key}) : super(key: key);

  @override
  _MyStoriesState createState() => _MyStoriesState();
}

class _MyStoriesState extends State<MyStories> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: lightColor,
        title: Text("My Stories",
          style: GoogleFonts.lexendExa(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('NewStories')
              .where("DoctorId",
              isEqualTo: FirebaseAuth.instance.currentUser.uid)
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
            print(snapshot.data.docs.length.toString() +
                "dddddddddddddd");
            if (snapshot.data.docs.length == 0) {
              return Container(
                  child: Center(
                    child: Text("Nothing Here"),
                  ));
            }
            return Padding(
              padding:
              const EdgeInsets.only(top: 20, left: 10, right: 10),
              child: GridView.builder(
                padding: EdgeInsets.zero,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, gridViewIndex) {
                  print(snapshot.data.docs[gridViewIndex].data());
                  CreateStory story = CreateStory.fromJson(
                    snapshot.data.docs[gridViewIndex].data()
                    as Map<String, dynamic>,
                    snapshot.data.docs[gridViewIndex].id,
                  );

                  return Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 100,
                    decoration: BoxDecoration(
                      color: mainBgColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: darkRedColor,
                      ),
                    ),
                    child: Stack(
                      // overflow: Overflow.visible,
                      fit: StackFit.loose,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            story.image,
                            height: MediaQuery.of(context).size.height,
                            width:
                            MediaQuery.of(context).size.width * 0.5,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.only(top: 10, right: 10),
                          child: Row(
                            children: [
                              Spacer(),
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
                                              'Êtes-vous sûr de supprimer cette histoire ?',
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
                                                        "Non",
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
                                                  onTap: () {
                                                    final collection =
                                                    FirebaseFirestore
                                                        .instance
                                                        .collection(
                                                        'NewStories');
                                                    collection
                                                        .doc(story
                                                        .id) // <-- Doc ID to be deleted.
                                                        .delete() // <-- Delete
                                                        .then((_) => print(
                                                        'Deleted'))
                                                        .catchError(
                                                            (error) =>
                                                            print(
                                                                'Delete failed: $error'));
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
                                                        "Oui",
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
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }),
    );
  }
}
