// ignore_for_file: non_constant_identifier_names, camel_case_types
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
//import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as p;
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:runnn/admin/Controller/controller.dart';
import 'package:runnn/admin/model/model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:runnn/const/appcolors.dart';

class addEditNewPromotion extends StatefulWidget {
  final index;
  final newsAndPromotion_model? newsPromotion;
  const addEditNewPromotion({super.key, this.newsPromotion, this.index});

  @override
  State<addEditNewPromotion> createState() => _addEditNewPromotionState();
}

class _addEditNewPromotionState extends State<addEditNewPromotion> {
  String time = DateFormat('dd MMMM 2566 เวลา kk:mm:ss').format(DateTime.now());
  String _imageFile = '';
  // Variable to hold the selected image file
  Uint8List? selectedImageInBytes;
  final id = TextEditingController();
  final Topic = TextEditingController();
  final Detail = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isEditingMode = false;
  @override
  void initState() {
    if (widget.index != null) {
      isEditingMode = true;
      id.text = widget.newsPromotion?.id;
      Topic.text = widget.newsPromotion?.Topic;
      Detail.text = widget.newsPromotion?.Detail;
      imageUrlNews = widget.newsPromotion?.imageUrlNews;
      selectedImageInBytes = null;
    } else {
      isEditingMode = false;
    }
    super.initState();
  }

  //up image form Phone
  ///// รูปข่าว
  File? _photo;
  final ImagePicker _picker = ImagePicker();
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

  Future uploadFile() async {
    final timeImage = DateTime.now().toString();
    if (_photo == null) return;
    final fileName = p.basename(_photo!.path);
    final destination = 'files/$fileName$timeImage';

    try {
      final ref = FirebaseStorage.instance.ref().child(destination);

      await ref.putFile(_photo!);
      imageUrlNews = await ref.getDownloadURL();
    } catch (e) {
      log('error occured: $e');
    }
  }

  // Method to pick image in flutter web
  Future<void> pickImage() async {
    try {
      // Pick image using file_picker package
      FilePickerResult? fileResult = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      // If user picks an image, save selected image to variable
      if (fileResult != null) {
        setState(() {
          _imageFile = fileResult.files.first.name;
          selectedImageInBytes = fileResult.files.first.bytes;
        });
      }
    } catch (e) {
      // If an error occured, show SnackBar with error message
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error:$e")));
    }
  }

  // Method to upload selected image in flutter web
  // This method will get selected image in Bytes
  String imageUrlNews = '';
  Future<String> uploadImage(Uint8List selectedImageInBytes) async {
    try {
      final timeImage = DateTime.now().toString();
      // This is referance where image uploaded in firebase storage bucket
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('newsPromotion/$_imageFile$timeImage');

      // metadata to save image extension
      final metadata = SettableMetadata(contentType: 'image/jpeg');

      // UploadTask to finally upload image
      UploadTask uploadTask = ref.putData(selectedImageInBytes, metadata);

      // After successfully upload show SnackBar
      await uploadTask.whenComplete(() => ScaffoldMessenger.of(context));
      return imageUrlNews = await ref.getDownloadURL();
    } catch (e) {
      // If an error occured while uploading, show SnackBar with error message
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
    return '';
  }

  void sendNotificationsToAllToken() {
    // ดึงค่าทั้งหมดจากคอลเลกชัน "token" ใน Firestore
    FirebaseFirestore.instance.collection('token').get().then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        // สร้าง JSON ข้อมูลสำหรับการส่งข้อความแจ้งเตือน
        var data = {
          'priority': 'high',
          'notification': {
            'title': Topic.text, // Change to your desired title
            'body': Detail.text, // Change to your desired body
          },
          'data': {
            'type': 'news',
            'Topic': Topic.text,
            'Detail': Detail.text,
            'imageUrlNews': imageUrlNews,
            'time': time,
          }
        };

        // วนลูปผ่านทุกเอกสารในคอลเลกชัน "token" เพื่อส่งการแจ้งเตือน
        for (var doc in querySnapshot.docs) {
          String toValue = doc['token'];
          if (toValue.isNotEmpty) {
            // เพิ่มค่า "to" ใน JSON ข้อมูล
            data['to'] = toValue;

            // ส่งคำขอ HTTP ไปยัง FCM
            http.post(
              Uri.parse('https://fcm.googleapis.com/fcm/send'),
              body: jsonEncode(data),
              headers: {
                HttpHeaders.contentTypeHeader: 'application/json',
                HttpHeaders.authorizationHeader:
                    'key=AAAAwRmBeUo:APA91bH9mfFenKTZc625Q3uOf-jDO8l6qi6VYyPOhgvFPR71AFboVO619aJ6gY7uuM6uA6P7dSSKzhQm41jR8C6n_B7Cmg6TgKzOjn93QrER7ThU1Q_Ec2LHcxjKDG91_176iTqOMyOh', // Replace with your FCM server key
              },
            );
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isEditingMode == true
            ? const Text('แก้ไขข่าวสารโปรโมชั่น')
            : const Text('เพิ่มข่าวสารโปรโมชั่น'),
        backgroundColor: Colors.blueAccent[500],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Form(
              key: _formKey,
              child: Center(
                child: SizedBox(
                  width: 1120,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'อัพโหลดรูปภาพ',
                        style: Textstyle().text18,
                      ),
                      Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          width: 200,
                          height: 180,
                          child: isEditingMode == true
                              ? _imageFile.isEmpty
                                  ? Image.network(imageUrlNews)
                                  : Image.memory(selectedImageInBytes!)
                              : _imageFile.isNotEmpty
                                  ? Image.memory(selectedImageInBytes!)
                                  : const Icon(
                                      Icons.photo,
                                      size: 150,
                                    ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[300],
                            elevation: 3,
                          ),
                          onPressed: () {
                            // Calling pickImage Method
                            pickImage();
                          },
                          child: Text('เพิ่มรูปภาพ',
                              style: Textstyle().buttomTextWhite),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      topic(),
                      SizedBox(height: 10.h),
                      detail(),
                      SizedBox(height: 20.h),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 75.0),
                          child: SizedBox(
                            width: 150,
                            height: 50,
                            child: ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    if (isEditingMode == true) {
                                      if (selectedImageInBytes != null) {
                                        await uploadImage(
                                            selectedImageInBytes!);
                                      }
                                      newsPromotion_controller()
                                          .update_newsPromotion(
                                              newsAndPromotion_model(
                                        id: id.text,
                                        Topic: Topic.text,
                                        Detail: Detail.text,
                                        imageUrlNews: imageUrlNews,
                                        time: time,
                                      ));
                                      sendNotificationsToAllToken();
                                    } else {
                                      await uploadImage(selectedImageInBytes!);

                                      newsPromotion_controller()
                                          .add_newsPromotion(
                                        newsAndPromotion_model(
                                          Topic: Topic.text,
                                          Detail: Detail.text,
                                          imageUrlNews: imageUrlNews,
                                          time: time,
                                        ),
                                      );
                                      sendNotificationsToAllToken();
                                    }

                                    if (context.mounted) {
                                      Navigator.pop(context);
                                    }
                                    Fluttertoast.showToast(
                                        msg: "เพิ่มข่าวสารโปรโมชั่น");
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: "เพิ่มข่าวสารโปรโมชั่นไม่สำเร็จ");
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue[300],
                                  elevation: 3,
                                ),
                                child: isEditingMode == true
                                    ? Text("บันทึกข้อมูล",
                                        style: Textstyle().buttomTextWhite)
                                    : Text("เพิ่มข่าวสาร",
                                        style: Textstyle().buttomTextWhite)),
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
      ),
    );
  }

  TextFormField topic() {
    return TextFormField(
      style: Textstyle().text18,
      keyboardType: TextInputType.text,
      controller: Topic,
      decoration: InputDecoration(
        labelText: 'หัวข้อ',
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color.fromARGB(255, 0, 65, 117)),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'กรุณาใส่รายละเอียด';
        }
        return null;
      },
    );
  }

  Container detail() {
    return Container(
      margin: const EdgeInsets.only(top: 1),
      height: 250,
      child: TextFormField(
        style: Textstyle().text18,
        controller: Detail,
        maxLines: 100,
        decoration: InputDecoration(
          labelText: 'รายละเอียด',
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
