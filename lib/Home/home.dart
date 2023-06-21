import 'package:board/Search/search_job.dart';
import 'package:board/Widgets/bottom_nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Persistent/persistent.dart';
import '../Widgets/job_widget.dart';


class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? jobCategoryFilter;


  _showTaskCategoriesDialog({required Size size}) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor: Colors.black54,
            title: const Text(
              'Выбрать категорию',
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
            content: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                width: size.width * 0.75,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: Persistent.CategoryList.length,
                  itemBuilder: (ctx, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          jobCategoryFilter = Persistent.CategoryList[index];
                        });
                        Navigator.canPop(context)
                            ? Navigator.pop(context)
                            : null;
                        print(
                            'jobCategoryList[index], ${Persistent.CategoryList[index]}');
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.arrow_right_alt_outlined,
                            color: Colors.grey,
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              Persistent.CategoryList[index],
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: const Text(
                  'Закрыть',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    jobCategoryFilter = null;
                  });
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: const Text(
                  'Закрыть',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        });
  }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    Persistent persistentObject = Persistent();
    persistentObject.getMyData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Scaffold(
          backgroundColor: Colors.white,
          bottomNavigationBar: BottomNavigationBarApp(
            indexNum: 0,
          ),
          appBar: AppBar(
            elevation: 0.0,
            flexibleSpace: Container(
              color: Colors.white,
            ),
            leading: IconButton(
                icon: const Icon(
                  Icons.list_rounded,
                  color: Colors.black,
                ),
                onPressed: () {
                  _showTaskCategoriesDialog(size: size);
                }),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (c) => SearchScreen()));
                },
                icon: const Icon(
                  Icons.search_outlined,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('jobs')
                .where('jobCategory', isEqualTo: jobCategoryFilter)
                .where('recruitment', isEqualTo: true)
                .orderBy('createdAt', descending: false)
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
                        jobDescription: snapshot.data?.docs[index]['jobDescription'],
                        jobId: snapshot.data?.docs[index]['jobId'],
                        uploadedBy: snapshot.data?.docs[index]['uploadedBy'],
                        userImage: snapshot.data?.docs[index]['userImage'],
                        name: snapshot.data?.docs[index]['name'],
                        recruitment: snapshot.data?.docs[index]['recruitment'],
                        email: snapshot.data?.docs[index]['email'],
                        location: snapshot.data?.docs[index]['location'],
                      );
                    }
                  );
                } else {
                  return const Center(
                    child: Text('Рабочих мест нет'),
                  );
                }
              }
              return const Center(
                child: Text(
                  'Что-то н так...',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              );
            }
        ),
      ),
    );
  }
}
