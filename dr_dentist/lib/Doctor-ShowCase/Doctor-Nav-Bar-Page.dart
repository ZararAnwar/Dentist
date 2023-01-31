import 'package:dr_dentist/Doctor-ShowCase/Chats/Doctor-Chat-screen.dart';
import 'package:dr_dentist/Doctor-ShowCase/Chats/DoctorChat.dart';
import 'package:dr_dentist/Doctor-ShowCase/Profile/Doctor-Profile.dart';
import 'package:dr_dentist/Doctor-ShowCase/Profile/Notifications-Screen.dart';
import 'package:dr_dentist/Doctor-ShowCase/Requests/Doctor-Requests.dart';
import 'package:dr_dentist/User-ShowCase/Home-Page/Home-Page.dart';
import 'package:dr_dentist/favourite_screen.dart';
import 'package:dr_dentist/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class DoctorNabBarPage extends StatefulWidget {
  DoctorNabBarPage({Key key, this.initialPage}) : super(key: key);

  final String initialPage;

  @override
  _DoctorNabBarPageState createState() => _DoctorNabBarPageState();
}

/// This is the private State class that goes with DoctorNabBarPage.
class _DoctorNabBarPageState extends State<DoctorNabBarPage> {
  final TextEditingController opinionController = TextEditingController();
  String _currentPage = 'HomePage';

  String section1Value;
  String section2Value;
  String section3Value;
  String section4Value;

  int isClicked;

  /// on will pop metod
  Future<bool> onWillPop()async{
    final shouldPop = await showDialog(
      context: context,
      builder: (context)=> AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
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
              'Are you sure to exit the app ?',
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
                  onTap: (){
                    Navigator.of(context).pop(false);
                  },
                  child: Container(
                    height: 25,
                    width: 70,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7),
                      boxShadow: [BoxShadow(
                          color: Colors.black12,
                          offset: Offset(2, 2),
                          spreadRadius: 2,
                          blurRadius: 2
                      )],
                    ),
                    child: Center(
                      child: Text("NO",
                        style: GoogleFonts.quicksand(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20,),
                InkWell(
                  onTap: (){
                    Navigator.of(context).pop(true);
                  },
                  child: Container(
                    height: 25,
                    width: 70,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7),
                      boxShadow: [BoxShadow(
                          color: Colors.black12,
                          offset: Offset(2, 2),
                          spreadRadius: 2,
                          blurRadius: 2
                      )],
                    ),
                    child: Center(
                      child: Text("YES",
                        style: GoogleFonts.quicksand(
                            color: Colors.red,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
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
    return shouldPop ?? false;
  }

  /// end

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage ?? _currentPage;
  }

  @override
  Widget build(BuildContext context) {
    final tabs = {
      'HomePage': DoctorChatScreen(),
      'Search': DoctorRequestsScreen(),
      'MyChats': DoctorChat(),
      'MyPosts': DoctorProfileScreen(),
    };
    return Scaffold(
      body: WillPopScope(onWillPop: onWillPop, child: tabs[_currentPage]),
      bottomNavigationBar: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home_filled,
                size: 24,
              ),
              label: 'Home',
              tooltip: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                size: 20,
              ),
              activeIcon: Icon(
                Icons.search,
                size: 20,
              ),
              label: 'Requests',
              tooltip: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.chat,
                size: 24,
              ),
              label: 'Chat',
              tooltip: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.account_circle_outlined,
                size: 24,
              ),
              label: 'Profile',
              tooltip: '',
            ),
          ],
          backgroundColor: Colors.white,
          currentIndex: tabs.keys.toList().indexOf(_currentPage),
          selectedItemColor: Colors.purple,
          unselectedItemColor: Color(0x8A000000),
          onTap: (i) => setState(() => _currentPage = tabs.keys.toList()[i]),
          showSelectedLabels: true,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }
}
