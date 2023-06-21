import 'package:board/Services/global_method.dart';
import 'package:board/Services/global_variables.dart';
import 'package:board/Widgets/comments_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:uuid/uuid.dart';

import '../Widgets/bottom_nav_bar.dart';
import 'home.dart';

class JobDetail extends StatefulWidget {
  final String uploadedBy;
  final String jobID;

  JobDetail({
    required this.uploadedBy,
    required this.jobID,
  });

  @override
  State<JobDetail> createState() => _JobDetailState();
}

class _JobDetailState extends State<JobDetail> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _commentController = TextEditingController();
  bool showComment = false;
  bool _isCommenting = false;
  String? authorName;
  String? userImageUrl;
  String? jobCategory;
  String? jobDescription;
  String? jobTitle;
  bool? recruitment;
  Timestamp? postedDateTimeStamp;
  Timestamp? deadlineDateTimeStamp;
  String? postedDate;
  String? deadlineDate;
  String? locationCompany = '';
  String? emailCompany = '';
  int applicants = 0;

  bool isDeadlineAvailable = false;
  DateTime? picked;
  bool isVisible = false;
  Timestamp? TimeValidate;

  void _del(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    final _uid = user!.uid;
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
                    Icons.delete_outline,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Удалить запись?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
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
                onPressed: () async {
                  if (widget.uploadedBy == _uid) {
                    await FirebaseFirestore.instance
                        .collection('jobs')
                        .doc(widget.jobID)
                        .delete();
                    await Fluttertoast.showToast(
                      msg: 'Обьявление удалено',
                      toastLength: Toast.LENGTH_LONG,
                      backgroundColor: Colors.grey,
                      fontSize: 18.0,
                    );
                  }
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => Home()));
                },
                child: const Text(
                  'Да',
                  style: TextStyle(color: Colors.green, fontSize: 18),
                ),
              ),
            ],
          );
        });
  }

  void getJobData() async {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uploadedBy)
        .get();

    if (userDoc == null) {
      return;
    } else {
      setState(() {
        authorName = userDoc.get('name');
        userImageUrl = userDoc.get('userImage');
      });
    }
    final DocumentSnapshot jobDatabase = await FirebaseFirestore.instance
        .collection('jobs')
        .doc(widget.jobID)
        .get();
    if (jobDatabase == null) {
      return;
    } else {
      setState(() {
        jobTitle = jobDatabase.get('jobTitle');
        jobDescription = jobDatabase.get('jobDescription');
        recruitment = jobDatabase.get('recruitment');
        emailCompany = jobDatabase.get('email');
        locationCompany = jobDatabase.get('location');
        applicants = jobDatabase.get('applicants');
        // views = jobDatabase.get('views');
        postedDateTimeStamp = jobDatabase.get('createdAt');
        deadlineDateTimeStamp = jobDatabase.get('deadLineDateTimeStamp');
        deadlineDate = jobDatabase.get('deadLineDate');
        var postDate = postedDateTimeStamp!.toDate();
        postedDate = '${postDate.year}-${postDate.month}-${postDate.day}';
      });
      var date = deadlineDateTimeStamp!.toDate();
      isDeadlineAvailable = date.isAfter(DateTime.now());
    }
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getJobData();


  }

  Widget dividerWidget() {
    return Column(
      children: const [
        SizedBox(
          height: 10,
        ),
        Divider(
          thickness: 1,
          color: Colors.grey,
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  applyForJob() {
    final Uri params = Uri(
        scheme: 'mailto',
        path: emailCompany,
        query:
        'subject=Вакансия $jobTitle&body=Здравствуйте, отправьте резюме! $authorName');
    final url = params.toString();
    launchUrlString(url);
    addNewApplicant();
  }

  void addNewApplicant() async {
    var docRef =
    FirebaseFirestore.instance.collection('jobs').doc(widget.jobID);

    docRef.update({
      'applicants': applicants + 1,
    });
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Home()));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBarApp(
          indexNum: 2,
        ),
        backgroundColor: Colors.white,
        appBar: AppBar(
          flexibleSpace: Container(),
          leading: IconButton(
            icon: Icon(
              Icons.close,
              size: 40,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Home()));
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(4.0),
                child: Card(
                  color: Colors.black54,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 4),
                          child: Center(
                            child: Text(
                              jobTitle == null ? '' : jobTitle!,
                              maxLines: 3,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 3,
                                  color: Colors.grey,
                                ),
                                shape: BoxShape.rectangle,
                                image: DecorationImage(
                                  image: NetworkImage(
                                    userImageUrl == null
                                        ? 'https://d2yht872mhrlra.cloudfront.net/user/91559/user_91559.jpg'
                                        : userImageUrl!,
                                  ),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    authorName == null ? '' : authorName!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    locationCompany!,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        dividerWidget(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 28.0),
                              child: Text(
                                applicants.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            const Text(
                              'Заявители',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Icon(
                              Icons.how_to_reg_sharp,
                              color: Colors.grey,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            FirebaseAuth.instance.currentUser!.uid !=
                                widget.uploadedBy
                                ? Container()
                                : Row(
                              children: [
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Container(
                                    child: Row(
                                      children: [
                                        TextButton.icon(
                                          onPressed: () {
                                            _del(context);
                                          },
                                          icon: const Padding(
                                            padding:
                                            EdgeInsets.only(left: 80),
                                            child: Icon(Icons.delete),
                                          ),
                                          label: const Text(
                                            'Удалить',
                                            style: TextStyle(
                                                color: Colors.grey),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        FirebaseAuth.instance.currentUser!.uid !=
                            widget.uploadedBy
                            ? Container()
                            : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            dividerWidget(),
                            const Text(
                              'Снять с публикации',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    User? user = _auth.currentUser;
                                    final _uid = user!.uid;
                                    if (_uid == widget.uploadedBy) {
                                      try {
                                        FirebaseFirestore.instance
                                            .collection('jobs')
                                            .doc(widget.jobID)
                                            .update(
                                            {'recruitment': true});
                                      } catch (error) {
                                        GlobalMethod.showErrorDialog(
                                          error:
                                          'Действие не может быть выполнено',
                                          ctx: context,
                                        );
                                      }
                                    } else {
                                      GlobalMethod.showErrorDialog(
                                          error:
                                          'Вы не можете выполнить это действие',
                                          ctx: context);
                                    }
                                    getJobData();
                                  },
                                  child: const Text(
                                    'Отображать',
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                                Opacity(
                                  opacity: recruitment == true ? 1 : 0,
                                  child: const Icon(
                                    Icons.check_box,
                                    color: Colors.green,
                                  ),
                                ),
                                const SizedBox(
                                  width: 40,
                                ),
                                TextButton(
                                  onPressed: () {
                                    User? user = _auth.currentUser;
                                    final _uid = user!.uid;
                                    if (_uid == widget.uploadedBy) {
                                      try {
                                        FirebaseFirestore.instance
                                            .collection('jobs')
                                            .doc(widget.jobID)
                                            .update(
                                            {'recruitment': false});
                                      } catch (error) {
                                        GlobalMethod.showErrorDialog(
                                          error:
                                          'Действие не может быть выполнено',
                                          ctx: context,
                                        );
                                      }
                                    } else {
                                      GlobalMethod.showErrorDialog(
                                          error:
                                          'Вы не можете выполнить это действие',
                                          ctx: context);
                                    }
                                    getJobData();
                                  },
                                  child: const Text(
                                    'Снять',
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                                Opacity(
                                  opacity: recruitment == false ? 1 : 0,
                                  child: const Icon(
                                    Icons.check_box,
                                    color: Colors.red,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ],
                        ),
                        dividerWidget(),
                        const Text(
                          'Описание работы',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          jobDescription == null ? '' : jobDescription!,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        dividerWidget()
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(4.0),
                child: Card(
                  color: Colors.black54,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            isDeadlineAvailable ? 'Активна' : 'Неактивно',
                            style: TextStyle(
                              color: isDeadlineAvailable
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        FirebaseAuth.instance.currentUser!.uid ==
                            widget.uploadedBy
                            ? Container()
                            :
                        Center(
                          child: MaterialButton(
                            onPressed: () {
                              applyForJob();
                            },
                            color: Colors.blueAccent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 14),
                              child: Text(
                                'Отозваться',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                        dividerWidget(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Дата размещения:',
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              postedDate == null ? '' : postedDate!,
                              style: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Дата окончания:',
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              deadlineDate == null ? '' : deadlineDate!,
                              style: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          ]
                        ),
                        dividerWidget(),

                         Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Просмотры',
                              style: TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: Colors.black54,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(
                            milliseconds: 500,
                          ),
                          child: _isCommenting
                              ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                flex: 3,
                                child: TextField(
                                  controller: _commentController,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                  maxLength: 200,
                                  keyboardType: TextInputType.text,
                                  maxLines: 6,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Theme
                                        .of(context)
                                        .scaffoldBackgroundColor,
                                    enabledBorder:
                                    const UnderlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.white),
                                    ),
                                    focusedBorder:
                                    const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.pink,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: MaterialButton(
                                        onPressed: () async {
                                          if (_commentController
                                              .text.length <
                                              7) {
                                            GlobalMethod.showErrorDialog(
                                              error:
                                              'Комментарий не меннее  семи символов',
                                              ctx: context,
                                            );
                                          } else {
                                            final _generatedId =
                                            const Uuid().v4();
                                            await FirebaseFirestore
                                                .instance
                                                .collection('jobs')
                                                .doc(widget.jobID)
                                                .update({
                                              'jobComments':
                                              FieldValue.arrayUnion([
                                                {
                                                  'userId': FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .uid,
                                                  'commentId':
                                                  _generatedId,
                                                  'name': name,
                                                  'userImageUrl':
                                                  userImage,
                                                  'commentBody':
                                                  _commentController
                                                      .text,
                                                  'time': Timestamp.now(),
                                                }
                                              ]),
                                            });
                                            await Fluttertoast.showToast(
                                                msg:
                                                'Комментарий добавлен',
                                                toastLength:
                                                Toast.LENGTH_LONG,
                                                backgroundColor:
                                                Colors.grey,
                                                fontSize: 18.0);
                                            _commentController.clear();
                                          }
                                          setState(() {
                                            showComment = true;
                                          });
                                        },
                                        color: Colors.blueAccent,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(8),
                                        ),
                                        child: const Text(
                                          'Комментарий',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14),
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          _isCommenting = !_isCommenting;
                                          showComment = false;
                                        });
                                      },
                                      child: Text('Закрыть'),
                                    )
                                  ],
                                ),
                              )
                            ],
                          )
                              : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isCommenting = !_isCommenting;
                                  });
                                },
                                icon: const Icon(
                                  Icons.add_comment,
                                  color: Colors.blueAccent,
                                  size: 40,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    showComment = true;
                                  });
                                },
                                icon: const Icon(
                                  Icons.arrow_drop_down_circle,
                                  color: Colors.blueAccent,
                                  size: 40,
                                ),
                              ),
                            ],
                          ),
                        ),
                        showComment == false ? Container() : Padding(
                          padding: EdgeInsets.all(16.0),
                          child: FutureBuilder<DocumentSnapshot>(
                            future: FirebaseFirestore.instance.collection(
                                'jobs').doc(widget.jobID).get(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),);
                              }
                              else {
                                if (snapshot.data == null) {
                                  const Center(
                                    child: Text('Нет комментариев'),);
                                }
                              }
                              return ListView.separated(shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index){
                                return CommentWidget(
                                 commentId: snapshot.data!['jobComments'][index]['commentId'],
                                  commenterId: snapshot.data!['jobComments'][index]['userId'],
                                  commenterName: snapshot.data!['jobComments'][index]['name'],
                                  commentBody: snapshot.data!['jobComments'][index]['commentBody'],
                                  commenterImageUrl: snapshot.data!['jobComments'][index]['userImageUrl'],
                                );
                                },

                                separatorBuilder: (context, index)
                                {
                                  return const Divider(
                                    thickness: 1,
                                    color: Colors.grey,
                                  );
                                  },
                                itemCount: snapshot.data!['jobComments'].length,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//Круглая кнопка
// SizedBox.fromSize(
// size: Size(56,56),
// child: ClipOval(
// child: Material(
// color: Colors.orange,
// child: InkWell(
// splashColor: Colors.green,
// onTap: (){_del(context);},
// child: Column(
// mainAxisAlignment: MainAxisAlignment.center,
// children: <Widget>[
// Icon(Icons.delete),
// ],
// ),
//
// ),
// ),
// ),
// ),
