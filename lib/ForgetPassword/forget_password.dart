import 'package:board/Services/global_method.dart';
import 'package:board/SignUpPage/signUp_Screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../ForgetPassword/forget_password.dart';
import '../LoginPage/login_screen.dart';
import '../Services/global_variables.dart';

class ForgetPassword extends StatefulWidget {
  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword>
    with TickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _passForgetTextController =
      TextEditingController(text: '');

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 30));
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.linear)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((animationStatus) {
            if (animationStatus == AnimationStatus.completed) {
              _animationController.reset();
              _animationController.forward();
            }
          });

    _animationController.forward();

    super.initState();
  }

  void _forgetPassSubmitForm() async {
    try{
       await _auth.sendPasswordResetEmail(email: _passForgetTextController.text);
       Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Login()));
    }catch(error){
      Fluttertoast.showToast(msg: error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: ForgetUrlImage,
            errorWidget: (context, url, error) => const Icon(Icons.error),
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            alignment: FractionalOffset(_animation.value, 0),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              children: [
                SizedBox(
                  height: size.height * 0.1,
                ),
                const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    'Восстановить пароль',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        fontFamily: 'Signatra'),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    'Email адрес',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        fontStyle: FontStyle.italic),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _passForgetTextController,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white54,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                MaterialButton(
                  onPressed: () {
                    _forgetPassSubmitForm();
                  },
                  color: Colors.cyan,
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Text(
                      'Сбросить пароль',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,fontStyle: FontStyle.italic,fontSize: 20
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
