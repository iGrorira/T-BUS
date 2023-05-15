import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:runnn/admin/car.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../const/appColors.dart';

class AddCom extends StatefulWidget {
  const AddCom({Key? key}) : super(key: key);

  @override
  State<AddCom> createState() => _AddComState();
}

class _AddComState extends State<AddCom> {
  final _nametourController = TextEditingController();
  final _detailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future addCom() async {
    await FirebaseFirestore.instance
        .collection('ListCompany')
        .add({
          'NameTour': _nametourController.text,
          'Detail': _detailController.text,
          'imageUrl': imageUrl,
        })
        .then((value) => {})
        .catchError((error) => print("Failed to add user: $error"));
  }

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  File? _photo;
  final ImagePicker _picker = ImagePicker();
  String imageUrl = '';

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
      } else {
        Fluttertoast.showToast(msg: "ไม่ได้เลือกรูปภาพ");
      }
    });
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
      } else {
        Fluttertoast.showToast(msg: "ไม่ได้เลือกรูปภาพ");
      }
    });
  }

  Future uploadFile() async {
    if (_photo == null) return;
    final fileName = basename(_photo!.path);
    final destination = 'files/$fileName';

    try {
      final ref =
          firebase_storage.FirebaseStorage.instance.ref().child(destination);

      await ref.putFile(_photo!);
      imageUrl = await ref.getDownloadURL();
      addCom();
    } catch (e) {
      print('error occured');
    }

    print(imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เพิ่มเที่ยวรถทัวร์'),
        backgroundColor: Colors.blueAccent[500],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.h),
                  const Text(
                    'อัพโหลดโลโก้บริษัท',
                    style: TextStyle(fontSize: 16),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => imgFromCamera(),
                        icon: const Icon(
                          Icons.add_a_photo,
                          size: 36,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        width: 200,
                        height: 180,
                        child: _photo == null
                            ? const Icon(
                                Icons.photo,
                                size: 150,
                              )
                            : Image.file(
                                _photo!,
                              ),
                      ),
                      IconButton(
                        onPressed: () => imgFromGallery(),
                        icon: const Icon(
                          Icons.add_photo_alternate,
                          size: 36,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _nametourController,
                    decoration: InputDecoration(
                      labelText: 'ชื่อบริษัททัวร์',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 0, 65, 117)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณาใส่ชื่อบริษัททัวร์';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10.h),
                  detail(),
                  SizedBox(height: 10.h),
                  buttom(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding buttom() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 75.0),
      child: GestureDetector(
        onTap: () {
          if (_formKey.currentState!.validate()) {
            uploadFile();
          }
        },
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: AppColors.buttomapp,
              borderRadius: BorderRadius.circular(12)),
          child: const Center(
            child: Text(
              'เข้าสู่ระบบ',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container detail() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      height: 120,
      child: TextFormField(
        controller: _detailController,
        maxLines: 100,
        decoration: InputDecoration(
          labelText: 'กรอกรายละเอียด',
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: Color.fromARGB(255, 0, 65, 117)),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'กรุณาใส่กรอกรายละเอียด';
          }
          return null;
        },
      ),
    );
  }
}
