import 'dart:io';

import 'package:board/Home/home.dart';
import 'package:board/user_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../Widgets/bottom_nav_bar.dart';

class Profile extends StatefulWidget {
  final String userID;

  const Profile({required this.userID});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? name;
  String email = '';
  String phoneNumber = '';
  String imageUrl = '';
  String joinedAt = '';
  bool _isLoading = false;
  bool _isSameUser = false;

  void getUserData() async {
    try {
      _isLoading = true;
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userID)
          .get();
      if (userDoc == null) {
        return;
      } else {
        setState(() {
          name = userDoc.get('name');
          email = userDoc.get('email');
          phoneNumber = userDoc.get('phone');
          imageUrl = userDoc.get('userImage');
          Timestamp joinedAtTimeStamp = userDoc.get('createAt');
          var joinedDate = joinedAtTimeStamp.toDate();
          joinedAt =
          '${joinedDate.year} - ${joinedDate.month} - ${joinedDate.day}';
        });
        User? user = _auth.currentUser;
        final _uid = user!.uid;
        setState(() {
          _isSameUser = _uid == widget.userID;
        });
      }
    } catch (error) {
    } finally {
      _isLoading = false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  Widget userInfo({required IconData icon, required String content}) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            content,
            style: const TextStyle(color: Colors.white54),
          ),
        ),
      ],
    );
  }

  Widget _cantactBy(
      {required Color color, required Function fct, required IconData icon}) {
    return CircleAvatar(
      backgroundColor: color,
      radius: 25,
      child: CircleAvatar(
        radius: 23,
        backgroundColor: Colors.white,
        child: IconButton(
          icon: Icon(
            icon,
            color: color,
          ),
          onPressed: () {
            fct();
          },
        ),
      ),
    );
  }

  void _openWhatsAppChat() async {

    var url_android = "whatsapp://send?phone="+phoneNumber+"&text=hello";
    var url_ios = "https://wa.me/$phoneNumber?text=${Uri.parse("hello")}";

    if(Platform.isIOS){
      if(await launchUrlString(url_ios)){
        launchUrlString(url_ios);
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: new Text("WhatsApp не установлен")));
      }

    }else{
      if(await launchUrlString(url_android)){
        launchUrlString(url_android);
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: new Text("WhatsApp не установлен")));
      }
    }

  }

  void _mailTo() async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: email,
      query:
      'subject=Write subject here, Please&body=Hello, please write details here',
    );
    final url = params.toString();
    launchUrlString(url);
  }

  void _callPhoneNamber() async {
    var url = 'tel://$phoneNumber';
    launchUrlString(url);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          flexibleSpace: Container(
            color: Colors.white,
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Home()));
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBarApp(
          indexNum: 3,
        ),
        backgroundColor: Colors.white,
        body: Center(
          child: _isLoading
              ? const Center(
            child: CircularProgressIndicator(),
          )
              : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Stack(
                children: [
                  Card(
                    color: Colors.white10,
                    margin: const EdgeInsets.all(30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 100,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              name == null ? 'Имя' : name!,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 24.0),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const Divider(
                              thickness: 1, color: Colors.white),
                          const SizedBox(
                            height: 15,
                          ),
                          const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              'Информация об аккаунте :',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 22.0),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: userInfo(
                                icon: Icons.email, content: email),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: userInfo(
                                icon: Icons.phone, content: phoneNumber),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const Divider(
                            thickness: 1,
                            color: Colors.white,
                          ),
                          SizedBox(
                            height: 35,
                          ),
                          _isSameUser
                              ? Container()
                              : Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceAround,
                            children: [
                              _cantactBy(
                                color: Colors.green,
                                fct: ()
                                {
                                  _openWhatsAppChat();
                                },
                                icon: FontAwesome.whatsapp,
                              ),
                              _cantactBy(
                                color: Colors.red,
                                fct: ()
                                {
                                  _mailTo();
                                },
                                icon: Icons.mail_outline,
                              ),
                              _cantactBy(
                                color: Colors.purple,
                                fct: ()
                                {
                                  _callPhoneNamber();
                                },
                                icon: Icons.call,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 25,
                          ),

                          !_isSameUser
                              ? Column()
                              : Center(
                            child: Padding(
                              padding:
                              const EdgeInsets.only(bottom: 30),
                              child: MaterialButton(
                                onPressed: () {
                                  _auth.signOut();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            UserState(),
                                      ));
                                },
                                color: Colors.black,
                                elevation: 8,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(13),
                                ),
                                child: Padding(
                                  padding:
                                  const EdgeInsets.symmetric(
                                      vertical: 14),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: const [
                                      Text(
                                        'Выйти',
                                        style: TextStyle(
                                          color: Colors.white54,
                                          fontWeight:
                                          FontWeight.bold,
                                          fontSize: 28,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Icon(
                                        Icons.logout,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: size.width * 0.26,
                        height: size.width * 0.26,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 8,
                            color:
                            Theme.of(context).scaffoldBackgroundColor,
                          ),
                          image: DecorationImage(
                            image: NetworkImage(
                              // ignore: prefer_if_null_operators, unnecessary_null_comparison
                              imageUrl == null
                                  ? 'https://img.favpng.com/5/3/12/computer-icons-user-download-clip-art-png-favpng-Wt71vidJfXzKPuFkvNDY7rgJj.jpg'
                                  : imageUrl,
                            ),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
