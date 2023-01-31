import 'package:dio/dio.dart';
import 'package:dr_dentist/Constant/Notification-Model.dart';
import 'package:dr_dentist/Constant/server-key-constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';



final _firestore = FirebaseFirestore.instance;
String username = 'User';
String email = 'user@example.com';
String messageText;
User loggedInUser;

class ChatterScreen extends StatefulWidget {
  String receiverId;
  String userName;
  String userImage;
  ChatterScreen({this.receiverId, this.userName, this.userImage});
  @override
  _ChatterScreenState createState() => _ChatterScreenState();
}

class _ChatterScreenState extends State<ChatterScreen> {

  DocumentSnapshot doc;
  String nameString = 'name';
  getUser() async {
    doc = await FirebaseFirestore.instance
        .collection("AllUsers")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();

    if (doc != null) {
      nameString = doc['name'];
      setState(() {});
    }
  }

  final chatMsgTextController = TextEditingController();
  String groupChatId = '';

  final _auth = FirebaseAuth.instance;
  String receiverFirebaseToken = '';

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    getReceiverTokenWithId();
    getUser();
    // getMessages();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      print("currentUser $user");
      if (user != null) {
        loggedInUser = user;
        setGroupId();

        print("receiver ${widget.receiverId}");
        print("userid ${loggedInUser.uid}");
        setState(() {
          username = loggedInUser.displayName;
          email = loggedInUser.email;
        });
      }
    } catch (e) {
      showToast(e.toString());
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 3,
        toolbarHeight: 70,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
        ],
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        title: Center(
          child: Row(
            children: [
              Container(
                height: 50,
                width: 50,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: widget.userImage != null?
                    Image.network(
                      widget.userImage,
                      fit: BoxFit.cover,
                    ) :
                        Container(),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Container(
                width: 150,
                child: Center(
                  child: Text(
                    widget.userName,
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.deepPurple),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ChatStream(groupChatId: groupChatId,name: nameString,),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Material(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white,
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 2,
                        horizontal: 20,
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintText: "Enter message...",
                          hintStyle: GoogleFonts.montserrat(
                            color: Colors.black,
                          ),
                        ),
                        onChanged: (value) {
                          messageText = value;
                        },
                        controller: chatMsgTextController,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: MaterialButton(
                      shape: CircleBorder(),
                      color: Colors.blue,
                      onPressed: () {
                        chatMsgTextController.clear();

                        _firestore
                            .collection('chats')
                            .doc(groupChatId)
                            .collection(groupChatId)
                            .add({
                          'idFrom': loggedInUser.uid,
                          'idTo': widget.receiverId,
                          'sender': nameString,
                          'text': messageText,
                          'timestamp': DateTime.now().millisecondsSinceEpoch,
                          'senderemail': email,
                        });

                        sendNotification(context, username, messageText);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      )
                    // Text(
                    //   'Send',
                    //   style: kSendButtonTextStyle,
                    // ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void setGroupId() {
    if (loggedInUser.uid.hashCode <= widget.receiverId.hashCode) {
      groupChatId = '${loggedInUser.uid}-${widget.receiverId}';
    } else {
      groupChatId = '${widget.receiverId}-${loggedInUser.uid}';
    }

    print("GroupId $groupChatId ");
  }

  sendNotification(
      BuildContext context,
      String title,
      String body,
      ) async {
    Dio dio = new Dio();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers['authorization'] = serverKey;

    String senderToken = receiverFirebaseToken;
    // String senderToken = _senderTokenTemp;

    NotificationModelOne _notification = new NotificationModelOne(
        title: "Un nouveau message de $title", body: '-> $body');

    NotificationRequest _notifModel =
    new NotificationRequest(notification: _notification, to: senderToken);

    try {
      var response = await dio.post(
        url,
        data: _notifModel.toJson(),
        options: Options(
          followRedirects: false,
          validateStatus: (status) {
            print("response code $status");
            if (status == 200) {
              // saveNotificationInDatabase(_notification);
            } else
              myErrorHandler(status);
            return;
          },
        ),
      );
      print("MY Response $response");
    } catch (e) {
      // showToast(e);
    }
  }



  void getReceiverTokenWithId() {
    _firestore
        .collection('AllUsers')
        .doc(widget.receiverId)
        .collection(groupChatId)
        .snapshots();

    var document = _firestore.collection('AllUsers').doc(widget.receiverId);
    document.get().then((value) {
      print("Data from firebase Token ${value}");
      print("Data from firebase Token fcm_token ${value.get('fcm_token')}");
      receiverFirebaseToken = value.get('fcm_token');
    });
  }
}

class ChatStream extends StatelessWidget {
  String groupChatId;
  String name;
  ChatStream({this.groupChatId,this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 570,
      child: StreamBuilder(
        stream: _firestore
            .collection('chats')
            .doc(groupChatId)
            .collection(groupChatId)
            .orderBy('timestamp')
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            print("It has DAta");
            print(snapshot.data.docs.length.toString() + "xxxxxxxx");
            final messages = snapshot.data.docs;
            print("helllllll $messages");
            List<MessageBubble> messageWidgets = [];
            for (var message in messages) {
              final msgText = message.get('text');

              final msgSender = message.get('sender');
              // final msgSenderEmail = message.data['senderemail'];
              final currentUser = name;

              print('MSG $msgSender  currentUser $currentUser');
              final msgBubble = MessageBubble(
                  msgText: msgText,
                  msgSender: msgSender,
                  user: currentUser == msgSender);
              messageWidgets.add(msgBubble);
            }
            return Container(
              height: 550,
              child: ListView(
                reverse: false,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                children: messageWidgets,
              ),
            );
          } else {
            return Center(
              child:
              CircularProgressIndicator(backgroundColor: Colors.deepPurple),
            );
          }
        },
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String msgText;
  final String msgSender;
  final bool user;
  MessageBubble({this.msgText, this.msgSender, this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment:
        user ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Material(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              topLeft: user ? Radius.circular(50) : Radius.circular(0),
              bottomRight: Radius.circular(50),
              topRight: user ? Radius.circular(0) : Radius.circular(50),
            ),
            color: user ? Colors.blue : Colors.white,
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                msgText,
                style: TextStyle(
                  color: user ? Colors.white : Colors.blue,
                  fontFamily: 'Poppins',
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

int myErrorHandler(int status) {
  showToast("Error $status");
  print("Custom Error $status");
}

showToast(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black38,
      textColor: Colors.white,
      fontSize: 15.0);
}
