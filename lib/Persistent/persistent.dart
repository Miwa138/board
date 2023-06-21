import 'package:board/Services/global_variables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Persistent {

  static List<String> CategoryList = [
    'Архитектура и Строительство',
    'Образование и Воспитание',
    'Разработка - Программирование',
    'Бизнесс',
    'Информационные технологии',
    'Люди и Ресурсы',
    'Маркетинг',
    'Дизайн',
  ];

  void getMyData() async {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    name = userDoc.get('name');
    userImage = userDoc.get('userImage');
    location = userDoc.get('location');
  }


}
