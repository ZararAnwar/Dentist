import 'package:dr_dentist/Bottom-Nav/Main-Page.dart';
import 'package:dr_dentist/Widgets/disease.dart';
import 'package:dr_dentist/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

import 'Utils/utils.dart';
import 'favourite_screen.dart';
class VideoDisease extends StatefulWidget {
  @override
  _VideoDiseaseState createState() => _VideoDiseaseState();
}

class _VideoDiseaseState extends State<VideoDisease> {
  int _selectedIndex=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBgColor,
appBar: new PreferredSize(
  child: new Container(
    padding: new EdgeInsets.only(
        top: MediaQuery.of(context).padding.top
    ),
    child: new Row(
      children: [
        SizedBox(width: 20,),
        InkWell(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>NavBarPage(),),);
            },
            child: Icon(Icons.arrow_back,color: Colors.white,)),
        Padding(
          padding: const EdgeInsets.only(
              left: 30.0,
              top: 20.0,
              bottom: 20.0
          ),
          child: new Text(
            'Diseases',
            style: new TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
                color: Colors.white
            ),
          ),
        ),
      ],
    ),
    decoration: new BoxDecoration(
      gradient: purpleGradient,
    ),
  ),
  preferredSize: new Size(
      MediaQuery.of(context).size.width,
      150.0
  ),
),    
body: ListView(
  children: [
    ProductIte(image: "assets/images/diseasetwo.jpeg", productName:"Periodontal disease", url: "https://youtu.be/oVSss3AgCt4"),
    ProductIte(image: "assets/images/diseasethree.jpeg", productName:"Enamal Erosion", url: "https://youtu.be/VARG0tEULvY"),
    ProductIte(image: "assets/images/diseaseone.jpeg", productName:"Gingivitis", url: "https://youtu.be/1IbOpj_pUe0"),
  ],
),
    );
  }
}
