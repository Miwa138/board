import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Widgets/bottom_nav_bar.dart';

class AllWorkersScreen extends StatefulWidget {


  @override
  State<AllWorkersScreen> createState() => _AllWorkersScreenState();
}

class _AllWorkersScreenState extends State<AllWorkersScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBarApp(indexNum: 1,),
        backgroundColor: Colors.white,
      ),
    );
  }
}
