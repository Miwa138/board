// import 'package:board/Services/global_method.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
//
// import '../Widgets/bottom_nav_bar.dart';
// import 'home.dart';
//
// class JobDetail extends StatefulWidget {
//   final String uploadedBy;
//   final String jobID;
//
//   JobDetail({
//     required this.uploadedBy,
//     required this.jobID,
//   });
//
//   @override
//   State<JobDetail> createState() => _JobDetailState();
// }
//
// class _JobDetailState extends State<JobDetail> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   String? authorName;
//   String? userImageUrl;
//   String? jobCategory;
//   String? jobDescription;
//   String? jobTitle;
//   bool? recruitment;
//   Timestamp? postedDateTimeStamp;
//   Timestamp? deadlineDateTimeStamp;
//   String? postedDate;
//   String? deadlineDate;
//   String? locationCompany = '';
//   String? emailCompany = '';
//   int applicants = 0;
//   bool isDeadlineAvailable = false;
//
//   bool isVisible = false;
//
//   // void inVisible() {
//   //   setState(() {
//   //     if (FirebaseAuth.instance.currentUser!.uid != widget.uploadedBy) {
//   //       isVisible = false;
//   //     } else if (FirebaseAuth.instance.currentUser!.uid == widget.uploadedBy) {
//   //       isVisible = true;
//   //     }
//   //   });
//   // }
//
//   void _del(BuildContext context) {
//     final FirebaseAuth _auth = FirebaseAuth.instance;
//     User? user = _auth.currentUser;
//     final _uid = user!.uid;
//     showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             backgroundColor: Colors.black54,
//             title: Row(
//               children: const [
//                 Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Icon(
//                     Icons.delete_outline,
//                     color: Colors.white,
//                     size: 36,
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Text(
//                     'Удалить запись?',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 20,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.canPop(context) ? Navigator.pop(context) : null;
//                 },
//                 child: const Text(
//                   'Нет',
//                   style: TextStyle(color: Colors.green, fontSize: 18),
//                 ),
//               ),
//               TextButton(
//                 onPressed: () async {
//                   if (widget.uploadedBy == _uid) {
//                     await FirebaseFirestore.instance
//                         .collection('jobs')
//                         .doc(widget.jobID)
//                         .delete();
//                     await Fluttertoast.showToast(
//                       msg: 'Обьявление удалено',
//                       toastLength: Toast.LENGTH_LONG,
//                       backgroundColor: Colors.grey,
//                       fontSize: 18.0,
//                     );
//                   }
//                   Navigator.pushReplacement(
//                       context, MaterialPageRoute(builder: (context) => Home()));
//                 },
//                 child: const Text(
//                   'Да',
//                   style: TextStyle(color: Colors.green, fontSize: 18),
//                 ),
//               ),
//             ],
//           );
//         });
//   }
//
//   void getJobData() async {
//     final DocumentSnapshot userDoc = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(widget.uploadedBy)
//         .get();
//
//     if (userDoc == null) {
//       return;
//     } else {
//       setState(() {
//         authorName = userDoc.get('name');
//         userImageUrl = userDoc.get('userImage');
//       });
//     }
//     final DocumentSnapshot jobDatabase = await FirebaseFirestore.instance
//         .collection('jobs')
//         .doc(widget.jobID)
//         .get();
//     if (jobDatabase == null) {
//       return;
//     } else {
//       setState(() {
//         jobTitle = jobDatabase.get('jobTitle');
//         jobDescription = jobDatabase.get('jobDescription');
//         recruitment = jobDatabase.get('recruitment');
//         emailCompany = jobDatabase.get('email');
//         locationCompany = jobDatabase.get('location');
//         applicants = jobDatabase.get('applicants');
//         postedDateTimeStamp = jobDatabase.get('createdAt');
//         deadlineDateTimeStamp = jobDatabase.get('deadLineDateTimeStamp');
//         deadlineDate = jobDatabase.get('deadLineDate');
//         var postDate = postedDateTimeStamp!.toDate();
//         postedDate = '${postDate.year}-${postDate.month}-${postDate.day}';
//       });
//       var date = deadlineDateTimeStamp!.toDate();
//       isDeadlineAvailable = date.isAfter(DateTime.now());
//     }
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getJobData();
//     // inVisible();
//   }
//
//   Widget dividerWidget() {
//     return Column(
//       children: const [
//         SizedBox(
//           height: 10,
//         ),
//         Divider(
//           thickness: 1,
//           color: Colors.grey,
//         ),
//         SizedBox(
//           height: 10,
//         ),
//       ],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Scaffold(
//         bottomNavigationBar: BottomNavigationBarApp(
//           indexNum: 2,
//         ),
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           flexibleSpace: Container(),
//           leading: IconButton(
//             icon: Icon(
//               Icons.close,
//               size: 40,
//               color: Colors.white,
//             ),
//             onPressed: () {
//               Navigator.pushReplacement(
//                   context, MaterialPageRoute(builder: (context) => Home()));
//             },
//           ),
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: EdgeInsets.all(4.0),
//                 child: Card(
//                   color: Colors.black54,
//                   child: Padding(
//                     padding: EdgeInsets.all(8.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Padding(
//                           padding: EdgeInsets.only(left: 4),
//                           child: Center(
//                             child: Text(
//                               jobTitle == null ? '' : jobTitle!,
//                               maxLines: 3,
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 30,
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 20,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Container(
//                               height: 60,
//                               width: 60,
//                               decoration: BoxDecoration(
//                                 border: Border.all(
//                                   width: 3,
//                                   color: Colors.grey,
//                                 ),
//                                 shape: BoxShape.rectangle,
//                                 image: DecorationImage(
//                                   image: NetworkImage(
//                                     userImageUrl == null
//                                         ? 'https://d2yht872mhrlra.cloudfront.net/user/91559/user_91559.jpg'
//                                         : userImageUrl!,
//                                   ),
//                                   fit: BoxFit.fill,
//                                 ),
//                               ),
//                             ),
//                             Padding(
//                               padding: EdgeInsets.only(left: 10.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     authorName == null ? '' : authorName!,
//                                     style: const TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 16,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                   const SizedBox(
//                                     height: 5,
//                                   ),
//                                   Text(
//                                     locationCompany!,
//                                     style: const TextStyle(color: Colors.grey),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                         dividerWidget(),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.only(left: 28.0),
//                               child: Text(
//                                 applicants.toString(),
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 18,
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(
//                               width: 6,
//                             ),
//                             const Text(
//                               'Заявители',
//                               style: TextStyle(
//                                 color: Colors.grey,
//                               ),
//                             ),
//                             const SizedBox(
//                               width: 10,
//                             ),
//                             const Icon(
//                               Icons.how_to_reg_sharp,
//                               color: Colors.grey,
//                             ),
//                             SizedBox(
//                               width: 10,
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(left: 90),
//                               child: Text(
//                                 'Удалить',
//                                 style: TextStyle(color: Colors.grey),
//                               ),
//                             ),
//                             TextButton(
//                                 onPressed: () {
//                                   _del(context);
//                                 },
//                                 child: const Icon(Icons.delete)),
//
//                           ],
//                         ),
//                         FirebaseAuth.instance.currentUser!.uid !=
//                             widget.uploadedBy
//                             ? Container()
//                             : Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             dividerWidget(),
//                             const Text(
//                               'Персонал',
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(
//                               height: 5,
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 TextButton(
//                                   onPressed: () {
//                                     User? user = _auth.currentUser;
//                                     final _uid = user!.uid;
//                                     if (_uid == widget.uploadedBy) {
//                                       try {
//                                         FirebaseFirestore.instance
//                                             .collection('jobs')
//                                             .doc(widget.jobID)
//                                             .update(
//                                             {'recruitment': true});
//                                       } catch (error) {
//                                         GlobalMethod.showErrorDialog(
//                                           error:
//                                           'Действие не может быть выполнено',
//                                           ctx: context,
//                                         );
//                                       }
//                                     } else {
//                                       GlobalMethod.showErrorDialog(
//                                           error:
//                                           'Вы не можете выполнить это действие',
//                                           ctx: context);
//                                     }
//                                     getJobData();
//                                   },
//                                   child: const Text(
//                                     'Вкл',
//                                     style: TextStyle(
//                                       fontStyle: FontStyle.italic,
//                                       color: Colors.black,
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.normal,
//                                     ),
//                                   ),
//                                 ),
//                                 Opacity(
//                                   opacity: recruitment == true ? 1 : 0,
//                                   child: const Icon(
//                                     Icons.check_box,
//                                     color: Colors.green,
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: 40,
//                                 ),
//                                 TextButton(
//                                   onPressed: () {
//                                     User? user = _auth.currentUser;
//                                     final _uid = user!.uid;
//                                     if (_uid == widget.uploadedBy) {
//                                       try {
//                                         FirebaseFirestore.instance
//                                             .collection('jobs')
//                                             .doc(widget.jobID)
//                                             .update(
//                                             {'recruitment': false});
//                                       } catch (error) {
//                                         GlobalMethod.showErrorDialog(
//                                           error:
//                                           'Действие не может быть выполнено',
//                                           ctx: context,
//                                         );
//                                       }
//                                     } else {
//                                       GlobalMethod.showErrorDialog(
//                                           error:
//                                           'Вы не можете выполнить это действие',
//                                           ctx: context);
//                                     }
//                                     getJobData();
//                                   },
//                                   child: const Text(
//                                     'Выкл',
//                                     style: TextStyle(
//                                       fontStyle: FontStyle.italic,
//                                       color: Colors.black,
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.normal,
//                                     ),
//                                   ),
//                                 ),
//                                 Opacity(
//                                   opacity: recruitment == false ? 1 : 0,
//                                   child: const Icon(
//                                     Icons.check_box,
//                                     color: Colors.red,
//                                   ),
//                                 ),
//                                 const SizedBox(
//                                   width: 10,
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
