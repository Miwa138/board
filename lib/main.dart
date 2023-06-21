import 'package:board/Home/home.dart';
import 'package:board/LoginPage/login_screen.dart';
import 'package:board/user_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initializtion = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initializtion,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MaterialApp(   debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: Text(
                    'Поиск работы',
                    style: TextStyle(
                        color: Colors.cyan,
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Signatra'
                    ),
                  ),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return const MaterialApp(
              home: Scaffold(
                body: Center(
                  child: Text(
                    'Ошибка соединения',
                    style: TextStyle(
                        color: Colors.cyan,
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );
          }
          return MaterialApp(
            title: 'Поиск работы',
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.black,
              primarySwatch: Colors.blue,
            ),
            home: UserState(),
          );
        });
  }
}
