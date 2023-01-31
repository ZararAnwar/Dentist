
import 'package:dr_dentist/Admin/All-Users-Stories.dart';
import 'package:dr_dentist/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../main.dart';

class AdminVerification extends StatefulWidget {
  const AdminVerification({Key key}) : super(key: key);

  @override
  _AdminVerificationState createState() => _AdminVerificationState();
}

class _AdminVerificationState extends State<AdminVerification> {

  Map<String, dynamic> adminData;

  @override
  void initState() {
    super.initState();
    // getUserDataFormMap();
  }

  // void getUserDataFormMap() async {
  //   adminData = await getAdminData();
  //   setState(() {});
  // }


  final TextEditingController adminEmailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: lightColor,
        title: Text("Verification",
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(left: 20,right: 20,top: 20),
          child: Column(
            children: [
              // text field
              SizedBox(height: 15,),
              Container(
                child: TextFormField(
                  controller: adminEmailController,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    prefixIcon: IconButton(onPressed: (){},
                        icon: Icon(Icons.email,color: Colors.black,)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: Colors.black26),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    hintText: "Email",
                    hintStyle: GoogleFonts.montserrat(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              // continue
              SizedBox(height: 30,),
              InkWell(
                onTap: (){
                  createAdminToDataBase(context);
                },
                child: Container(
                  height: 44,
                  width: MediaQuery.of(context).size.width * 0.5,
                  decoration: BoxDecoration(
                    color: lightColor,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Center(
                    child: Text("Continue",
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  createAdminToDataBase(BuildContext context){

    if( adminEmailController.text.isEmpty){
      Fluttertoast.showToast(
          msg: "Fill the required field",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black38,
          textColor: Colors.white,
          fontSize: 15.0);
    }
    if(adminEmailController.text == "zarar@gmail.com"){
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AllUsersStories(),),);
    }
    else{
      Fluttertoast.showToast(
          msg: "The information you stored is wrong",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black38,
          textColor: Colors.white,
          fontSize: 15.0);
    }

    print(adminData["AdminName"]);

  }

}
