import 'package:board/Home/job_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class JobWidget extends StatefulWidget {
  final String jobTitle;
  final String jobDescription;
  final String jobId;
  final String uploadedBy;
  final String userImage;
  final String name;
  final bool recruitment;
  final String email;
  final String location;

  const JobWidget({
    required this.jobTitle,
    required this.jobDescription,
    required this.jobId,
    required this.uploadedBy,
    required this.userImage,
    required this.name,
    required this.recruitment,
    required this.email,
    required this.location,
  });

  @override
  State<JobWidget> createState() => _JobWidgetState();
}

class _JobWidgetState extends State<JobWidget> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // int views = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // UpdateCountView();
  }

  // void UpdateCountView() async {
  //   final DocumentSnapshot jobDatabase = await FirebaseFirestore.instance
  //       .collection('jobs')
  //       .doc(widget.jobId)
  //       .get();
  //
  // views = jobDatabase.get('views');
  //
  // }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white24,
      elevation: 8,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: ListTile(
        onTap: () {
          // setState(() {
          //   addViews();
          // });


          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => JobDetail(
                uploadedBy: widget.uploadedBy,
                jobID: widget.jobId,
              ),
            ),
          );
          // UpdateCountView();

        },
        onLongPress: () {},
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(
          padding: const EdgeInsets.only(right: 12),
          decoration: const BoxDecoration(
            border: Border(
              right: BorderSide(
                width: 1,
              ),
            ),
          ),
          child: Image.network(widget.userImage),
        ),
        title: Text(
          widget.jobTitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.amber,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              widget.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              widget.jobDescription,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // addViews() async {
  //   var docRef =
  //       FirebaseFirestore.instance.collection('jobs').doc(widget.jobId);
  //   docRef.update({
  //     'views': views + 1,
  //   });
  // }
}
