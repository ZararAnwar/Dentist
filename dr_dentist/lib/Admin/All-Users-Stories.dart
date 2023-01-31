import 'package:dr_dentist/Doctor-ShowCase/Create-Story/story-util.dart';
import 'package:dr_dentist/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';


class AllUsersStories extends StatefulWidget {
  const AllUsersStories({Key key}) : super(key: key);

  @override
  _AllUsersStoriesState createState() => _AllUsersStoriesState();
}

class _AllUsersStoriesState extends State<AllUsersStories> {
  @override
  Widget build(BuildContext context) {
    final w = Colors.white;
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(onPressed: (){
              Navigator.pop(context);
            }, icon: Icon(Icons.arrow_back,color: Colors.white,)),
            backgroundColor: lightColor,
            toolbarHeight: 80,
            elevation: 0,
            bottom: TabBar(
                isScrollable: true,
                physics: BouncingScrollPhysics(),
                indicatorColor: w,
                indicatorWeight: 4,
                indicatorSize: TabBarIndicatorSize.label,
                tabs: [
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Users",
                        style: GoogleFonts.montserrat(
                          color: w,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Stories",
                        style: GoogleFonts.montserrat(
                            color: w,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ]),
          ),
          body: TabBarView(children: [
            Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('AllUsers').snapshots(),
                builder: (_, snapshot) {
                  if (snapshot.hasError) return Text('Error = ${snapshot.error}');
                  if (snapshot.hasData) {
                    final docs = snapshot.data.docs;
                    return ListView.builder(
                      itemCount: docs.length,
                      itemBuilder: (_, i) {
                        final data = docs[i].data();
                        return Padding(
                          padding: const EdgeInsets.only(left: 10,right: 10,top: 15),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [BoxShadow(
                                color: Colors.black12,
                                offset: Offset(2,2),
                                spreadRadius: 2,
                                blurRadius: 2,
                              )],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10,bottom: 10,left: 10,right: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                        data['image'] ??
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
                                      Row(
                                        children: [
                                          Text(
                                            data['name'] ?? "Name",
                                            style: GoogleFonts.montserrat(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "Mobile:  ${data['mobile']}",
                                        style: GoogleFonts.montserrat(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  InkWell(
                                      onTap: ()async{
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
                                                  'Are you sure to delete this user ?',
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
                                                        final collection = FirebaseFirestore.
                                                        instance.collection('AllUsers');
                                                        collection
                                                            .doc(data['userId'])   // <-- Doc ID to be deleted.
                                                            .delete() // <-- Delete
                                                            .then((_) => print('Deleted'))
                                                            .catchError((error) => print('Delete failed: $error'));
                                                        Navigator.pop(context);
                                                      },
                                                      child: Container(
                                                        height: 30,
                                                        width: 70,
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
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
                                      child: Icon(Icons.delete,color:Colors.red)),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }

                  return Center(child: CircularProgressIndicator());
                },
              ),
            ),
            Container(
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
                              color:darkRedColor,
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
                      padding: const EdgeInsets.only(top: 20,left: 10,right: 10),
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
                            snapshot.data.docs[gridViewIndex].data() as Map<String, dynamic>,
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
                                    width: MediaQuery.of(context).size.width * 0.5,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10,right: 10),
                                  child: Row(
                                    children: [
                                      Spacer(),
                                      InkWell(
                                          onTap: ()async{
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
                                                      'Êtes-vous sûr de supprimer cette Story  ?',
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
                                                                "Non",
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
                                                            final collection = FirebaseFirestore.instance.collection('NewStories');
                                                            collection
                                                                .doc(story.id)   // <-- Doc ID to be deleted.
                                                                .delete() // <-- Delete
                                                                .then((_) => print('Deleted'))
                                                                .catchError((error) => print('Delete failed: $error'));
                                                            Navigator.pop(context);
                                                          },
                                                          child: Container(
                                                            height: 30,
                                                            width: 70,
                                                            decoration: BoxDecoration(
                                                              color: Colors.white,
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
                                                                "Oui",
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
                                          child: Icon(Icons.delete,color:Colors.red,)),
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
            ),
          ]),
        ));
  }
}
