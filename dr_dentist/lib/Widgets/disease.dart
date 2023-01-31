import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_dentist/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductIte extends StatefulWidget {

  final String productName;
  final String image;
  final String url;
  ProductIte({
    @required this.image,
    @required this.productName,
    @required this.url,

  });

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductIte> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, right: 10.0, left: 10.0),
      child: InkWell(
        onTap: (){
          _launchURL(widget.url);
        },
        child: Container(

          width: MediaQuery
              .of(context)
              .size
              .width,
          child: Column(
            children: <Widget>[
              Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.2,
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.99,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(0),
                  child: Image.asset(
                    widget.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                widget.productName,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 25),
                              ),
                            ),



                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [

                            IconButton(icon: Icon(Icons.remove_red_eye,
                              color: Colors.white, size: 30.0,), onPressed: () {
                              _launchURL(widget.url);
                              setState(() {

                              });
                              //print(caloriesGet);
                              // getSUm(caloriesGet,widget.productPrice);
                              //   caloriesGet=widget.productPrice;
                            },),

                          ],
                        )
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                    Row(
                      children: <Widget>[
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(

            border: Border.all(
                color: Colors.white, // set border color
                width: 2.0),
            borderRadius: BorderRadius.circular(30),
            gradient: purpleGradient,
          ),
        ),
      ),
    );
  }
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

}
