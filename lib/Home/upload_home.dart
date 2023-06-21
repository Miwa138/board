import 'package:board/Home/home.dart';
import 'package:board/Persistent/persistent.dart';
import 'package:board/Services/global_method.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

import '../Services/global_variables.dart';
import '../Widgets/bottom_nav_bar.dart';

class UploadHome extends StatefulWidget {
  @override
  State<UploadHome> createState() => _UploadHomeState();
}

class _UploadHomeState extends State<UploadHome> {
  final TextEditingController _categoryController =
      TextEditingController(text: 'Выбрать категорию');
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _deadLinenController =
      TextEditingController(text: 'Выбрать дату');

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  DateTime? picked;
  Timestamp? deadlineDateTimeStamp;

  @override
  void dispose() {
    super.dispose();
    _categoryController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _deadLinenController.dispose();
  }

  Widget _textTitles({required String label}) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Text(
        label,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );
  }



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
                          _categoryController.text =
                              Persistent.CategoryList[index];
                        });
                        Navigator.pop(context);
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
                  'Выйти',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              )
            ],
          );
        });
  }

  void _pickDateDialog() async {
    picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(const Duration(days: 0)),
        lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _deadLinenController.text =
            '${picked!.year} - ${picked!.month} - ${picked!.day}';
        deadlineDateTimeStamp = Timestamp.fromMicrosecondsSinceEpoch(
            picked!.microsecondsSinceEpoch);
      });
    }
  }

  void _uploadTask(BuildContext context) async {
    final jodId = const Uuid().v4();
    User? user = FirebaseAuth.instance.currentUser;
    final _uid = user!.uid;
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      if (_deadLinenController.text == 'Выбрать дату' ||
          _categoryController.text == 'Выбрать категорию') {
        GlobalMethod.showErrorDialog(error: 'Заполните форму', ctx: context);
        return;
      }
      setState(() {
        _isLoading = true;
      });
      try {
        await FirebaseFirestore.instance.collection('jobs').doc(jodId).set({
          'jobId': jodId,
          'uploadedBy': _uid,
          'views' : 0,
          'email': user.email,
          'jobTitle': _titleController.text,
          'jobDescription': _descriptionController.text,
          'deadLineDate': _deadLinenController.text,
          'deadLineDateTimeStamp': deadlineDateTimeStamp,
          'jobCategory': _categoryController.text,
          'jobComments': [],
          'recruitment': true,
          'createdAt': Timestamp.now(),
          'name': name,
          'userImage': userImage,
          'location': location,
          'applicants': 0,
        });
        await Fluttertoast.showToast(
          msg: 'Данные сохранены',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.grey,
          fontSize: 18.0,
        );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Home()));
        _titleController.clear();
        _descriptionController.clear();
        setState(() {
          _categoryController.text = 'Выберете категорию';
          _deadLinenController.text = 'Выберете дату';
        });
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        GlobalMethod.showErrorDialog(error: toString(), ctx: context);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      print('Ошибка');
    }
  }

  Widget _textFormFiled({
    required String valueKey,
    required TextEditingController controller,
    required bool enabled,
    required Function fct,
    required int maxLenght,
  }) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: InkWell(
        onTap: () {
          fct();
        },
        child: TextFormField(
          validator: (value) {
            if (value!.isEmpty) {
              return 'Введите значенте';
            }
            return null;
          },
          controller: controller,
          enabled: enabled,
          key: ValueKey(valueKey),
          style: const TextStyle(
            color: Colors.white,
          ),
          maxLines: valueKey == 'Описание' ? 5 : 1,
          maxLength: maxLenght,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
            filled: true,
            fillColor: Colors.black54,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBarApp(
          indexNum: 2,
        ),
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Card(
              color: Colors.white10,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 11,
                    ),
                    const Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.all(9.0),
                        child: Text(
                          'Создать резюме',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _textTitles(label: 'Категория:'),
                            _textFormFiled(
                                valueKey: 'Категория',
                                controller: _categoryController,
                                enabled: false,
                                fct: () {
                                  _showTaskCategoriesDialog(size: size);
                                },
                                maxLenght: 100),
                            _textTitles(label: 'Профессия:'),
                            _textFormFiled(
                              valueKey: 'Профессия',
                              controller: _titleController,
                              enabled: true,
                              fct: () {},
                              maxLenght: 100,
                            ),
                            _textTitles(label: 'Описание:'),
                            _textFormFiled(
                              valueKey: 'Описание',
                              controller: _descriptionController,
                              enabled: true,
                              fct: () {},
                              maxLenght: 100,
                            ),
                            _textTitles(label: 'Крайний срок поиска:'),
                            _textFormFiled(
                              valueKey: 'Выбрать дату',
                              controller: _deadLinenController,
                              enabled: false,
                              fct: () {
                                _pickDateDialog();
                              },
                              maxLenght: 100,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : MaterialButton(
                                onPressed: () {
                                  _uploadTask(context);
                                },
                                color: Colors.black,
                                elevation: 8,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text(
                                        'Опубликовать',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 23),
                                      ),
                                      SizedBox(
                                        width: 9,
                                      ),
                                      Icon(
                                        Icons.upload_file,
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
          ),
        ),
      ),
    );
  }
}
