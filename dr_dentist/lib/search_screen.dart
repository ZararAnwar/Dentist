import 'dart:async';
import 'package:dr_dentist/chat-with-doctors/chatter-screen.dart';

import 'package:dr_dentist/User-ShowCase/Home-Page/Home-Page.dart';

import 'package:dr_dentist/video_disease.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'Utils/User.dart';
import 'favourite_screen.dart';
import 'main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  final TextEditingController searchedUser = TextEditingController();

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

  int _selectedIndex = 0;

  void onTapped(int value) {
    setState(() {
      _selectedIndex = value;
    });
  }

  String _resultAddress;
  var bPadding=0.0;
  Completer<GoogleMapController> _newGooglecontroller = Completer();
  GoogleMapController userMap;
  // Position currentPosition;
  List<LatLng> pLineCoordinates=[];
  Set<Polyline> polyLineSet={};
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBgColor,
      body: ListView(
        children: [
          Stack(
      fit: StackFit.loose,
      alignment: AlignmentDirectional.topCenter,
      children: <Widget>[
        _backBgCover(),
        _search(),
        Positioned(
          top: 150,
          child: Container(
            height: 50,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: TextFormField(
              controller: searchedUser,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                prefixIcon: IconButton(onPressed: (){}, icon: Icon(
                  Icons.search,
                  color: Colors.black,
                  size: 25,
                )),
                suffixIcon: IconButton(onPressed: (){}, icon: Icon(
                  Icons.filter_list,
                  color: Colors.black,
                  size: 25,
                )),
                hintText: "Search by name...",
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
          SizedBox(
            height: 50.0,
          ),
          SearchUsers(searchedUser: searchedUser.text),
        ],
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
      top: 40,
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
            'Search Reputed Doctor\'s and take suggestions..!! ',
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
}




class SearchUsers extends StatefulWidget {
  String searchedUser;
  SearchUsers({this.searchedUser});

  @override
  _SearchUsersState createState() => _SearchUsersState();
}

class _SearchUsersState extends State<SearchUsers> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('AllUsers')
          .where('name', isEqualTo: widget.searchedUser).snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {

        if (snapshot.hasData) {
          if (snapshot.data.size > 0) {
            final messages = snapshot.data.docs.reversed;

            List<SearchItem> searchWidgets = [];
            for (var message in messages) {
              final name = message.get('name');
              final image = message.get('image');
              final address = message.get('address');

              final searchItem = SearchItem(
                name: name,
                image: image,
                address : address,
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
          } else if(widget.searchedUser == widget.searchedUser)
            return Container(
              height: 500,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    Container(
                      height: 500,
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
                                    child: Text("Pas encore de données à afficher"),
                                  ));
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 10,bottom: 50),
                              child: ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  itemCount: snapshot.data.docs.length,
                                  itemBuilder: (_, index) {
                                    print("Another try ${snapshot.data.docs[index].id}");
                                    return users(snapshot.data.docs[index]);
                                  }),
                            );
                          }),
                    ),
                    SizedBox(height: 50),
                  ],
                ),
              ),
            );
          else{
            return Column(
              children: [
                SizedBox(height: 50,),
                Text("Aucune annonce associée",
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
    );
  }

  // users

  users(QueryDocumentSnapshot doc){
    Userr user = Userr.fromJson(doc.data());
    print("userModel ${doc.id}");
    return user.mainValue == "Doctor" ?
      Padding(
      padding: const EdgeInsets.only(left: 20,right: 20,top: 15),
      child: InkWell(
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ChatterScreen(
            userImage: user.image,
            userName: user.name,
            receiverId: doc.id,
          ),),);
        },
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
                    Text(user.name ?? "Name",
                      style: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(user.doctorClinicAddress ?? "address",
                      style: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ):
        Container();
  }

}



/// search list
class SearchItem extends StatelessWidget {

  SearchItem({
    this.name,this.image,this.address,
  });

  String name,image,address;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
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
                    child: Text("Pas encore de données à afficher"),
                  ));
            }
            return Padding(
              padding: const EdgeInsets.only(top: 10,bottom: 50),
              child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: 1,
                  itemBuilder: (_, index) {
                    print("Another try ${snapshot.data.docs[index].id}");
                    return okay(snapshot.data.docs[index],context);
                  }),
            );
          }),
    );
  }
  okay(QueryDocumentSnapshot doc, BuildContext context){
    Userr user = Userr.fromJson(doc.data());
    print("userModel ${doc.id}");
    return InkWell(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ChatterScreen(
          userName: name,
          userImage: image,
          receiverId: doc.id,
        ),),);
      },
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Image.network(image,fit: BoxFit.cover,),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20, 10, 0, 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          name ?? 'n/a',
                          style: GoogleFonts.montserrat(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          address ?? 'n/a',
                          style: GoogleFonts.montserrat(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
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
    );
  }
}
