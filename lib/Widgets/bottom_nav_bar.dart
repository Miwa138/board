import 'package:board/Home/home.dart';
import 'package:board/Home/upload_home.dart';
import 'package:board/Search/profile.dart';
import 'package:board/Search/search_company.dart';
import 'package:board/Search/search_job.dart';
import 'package:board/Search/serach.dart';
import 'package:board/user_state.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomNavigationBarApp extends StatelessWidget {
  int indexNum = 0;

  BottomNavigationBarApp({required this.indexNum});

  void _logout(context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.black54,
            title: Row(
              children: const [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.logout,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Выйти',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                    ),
                  ),
                ),
              ],
            ),
            content: const Text(
              'Точно хотите выйти?',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: const Text(
                  'Нет',
                  style: TextStyle(color: Colors.green, fontSize: 18),
                ),
              ),
              TextButton(
                  onPressed: () {
                    _auth.signOut();
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> UserState()));
                  },
                  child: const Text(
                    'Да',
                    style: TextStyle(color: Colors.green, fontSize: 18),
                  ))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      color: Colors.black45,
      backgroundColor: Colors.black45,
      buttonBackgroundColor: Colors.black45,
      height: 50,
      index: indexNum,
      items: const [
        Icon(
          Icons.list,
          size: 19,
          color: Colors.white,
        ),
        Icon(
          Icons.search,
          size: 19,
          color: Colors.white,
        ),
        Icon(
          Icons.add,
          size: 19,
          color: Colors.white,
        ),
        Icon(
          Icons.person_pin,
          size: 19,
          color: Colors.white,
        ),Icon(
          Icons.exit_to_app,
          size: 19,
          color: Colors.white,
        ),
      ],
      animationDuration: Duration(
        milliseconds: 300,
      ),
      animationCurve: Curves.bounceInOut,
      onTap: (index) {
        if (index == 0) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => Home()));
        } else if (index == 1) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => AllWorkersScreen()));
        }else if (index == 2) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => UploadHome()));
        }  else if (index == 3) {
          final FirebaseAuth _auth = FirebaseAuth.instance;
          final User? user = _auth.currentUser;
          final String uid = user!.uid;
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => Profile(userID: uid,)));
        }else if (index == 4) {
              _logout(context);
        }
      },
    );
  }
}
