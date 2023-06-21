import 'package:board/Home/home.dart';
import 'package:board/Widgets/job_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Widgets/bottom_nav_bar.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchQueryController = TextEditingController();
  String searchQuery = 'Search query';

  Widget _buildSearchFiled() {
    return TextField(
      controller: _searchQueryController,
      autocorrect: true,
      decoration: const InputDecoration(
        hintText: 'Поиск...',
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.black),
      ),
      style: const TextStyle(color: Colors.black, fontSize: 16.0),
      onChanged: (query) => updateSearchQuery(query),
    );
  }



  List<Widget> _buildActions() {
    return <Widget>[
      IconButton(
        onPressed: () {
          _clearSearchQuery();
        },
        icon: const Icon(
          Icons.clear,
          color: Colors.black,
        ),
      ),
    ];
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery('');
    });
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
      print(searchQuery);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBarApp(
          indexNum: 1,
        ),
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0,
          flexibleSpace: Container(
            color: Colors.grey,
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
          title: _buildSearchFiled(),
          actions: _buildActions(),
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('jobs')
              .where('jobTitle', isGreaterThanOrEqualTo: searchQuery)
              .where('recruitment', isEqualTo: true)
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.data?.docs.isNotEmpty == true) {
                return ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return JobWidget(
                      jobTitle: snapshot.data?.docs[index]['jobTitle'],
                      jobDescription: snapshot.data?.docs[index]
                          ['jobDescription'],
                      jobId: snapshot.data?.docs[index]['jobId'],
                      uploadedBy: snapshot.data?.docs[index]['uploadedBy'],
                      userImage: snapshot.data?.docs[index]['userImage'],
                      name: snapshot.data?.docs[index]['name'],
                      recruitment: snapshot.data?.docs[index]['recruitment'],
                      email: snapshot.data?.docs[index]['email'],
                      location: snapshot.data?.docs[index]['location'],
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text('Работы нет'),
                );
              }
            }
            return const Center(
              child: Text(
                'Что-то пошло не так',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
