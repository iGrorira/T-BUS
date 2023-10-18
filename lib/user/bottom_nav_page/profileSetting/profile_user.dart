import 'dart:developer';
import 'dart:io';
//import 'package:path/path.dart' as p;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:runnn/const/appcolors.dart';
import 'package:runnn/main.dart';

class ProfileUser extends StatefulWidget {
  final profile;
  const ProfileUser({
    super.key,
    this.profile,
  });

  @override
  State<ProfileUser> createState() => _ProfileUserState();
}

class _ProfileUserState extends State<ProfileUser> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  final username = TextEditingController();

  @override
  void initState() {
    super.initState();
    username.text = widget.profile['username'] ?? "";
  }

  //up image form Phone
  ///// รูปโปรไฟล์
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
    uploadFile();
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
    uploadFile();
  }

  Future uploadFile() async {
    final userId = FirebaseAuth.instance.currentUser!.email;

    if (_photo == null) return;
    //final timeImage = DateTime.now().toString();
    //final fileName = p.basename(_photo!.path);
    final destination = 'profileUser/$userId.png';

    try {
      final ref = FirebaseStorage.instance.ref().child(destination);
      await ref.putFile(_photo!);
      final imageUrl = await ref.getDownloadURL();

      final userDocRef = FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection("UsersProfile")
          .doc(userId);
      await userDocRef.update({'ImageUrl': imageUrl}).then(
          (value) => Fluttertoast.showToast(msg: 'อัพเดทรูปสำเร็จ'));
      log("imageUrl: $imageUrl");
    } catch (e) {
      log('error occured: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('แก้ไข้ข้อมูล', style: Textstyle().textTitleAppbar)),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Text(
                widget.profile['email'].toString(),
                style: Textstyle().text18,
              ),
              const SizedBox(height: 5),
              _photo != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(mq.height * .1),
                      child: Image.file(
                        _photo!,
                        width: mq.height * .2,
                        height: mq.height * .2,
                        fit: BoxFit.cover,
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(mq.height * .1),
                      child: CachedNetworkImage(
                        width: mq.height * .2,
                        height: mq.height * .2,
                        fit: BoxFit.cover,
                        imageUrl: widget.profile['ImageUrl'],
                        //placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          imgFromCamera();
                        },
                        icon: Icon(Icons.camera_alt_rounded,
                            color: Colors.blue.shade300)),
                    IconButton(
                        onPressed: () {
                          imgFromGallery();
                        },
                        icon: Icon(Icons.add_photo_alternate_rounded,
                            color: Colors.blue.shade300)),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: username,
                style: GoogleFonts.baiJamjuree(color: Colors.black),
                autovalidateMode: AutovalidateMode.always,
                validator: (val) =>
                    val != null && val.isNotEmpty ? null : 'กรุณาใส่ชื่อผู้ใช้',
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  labelText: 'ชื่อผู้ใช้',
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    updateUsername();
                    Fluttertoast.showToast(msg: "เปลี่ยนชื่อผู้ใช้สำเร็จ");
                  } else {
                    Fluttertoast.showToast(msg: "เปลี่ยนชื่อใช้ไม่สำเร็จ");
                  }
                },
                child: Text(
                  'บันทึกชื่อผู้ใช้',
                  style: Textstyle().buttomTextWhite,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> updateUsername() async {
    try {
      final userDocRef = FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .collection("UsersProfile")
          .doc(FirebaseAuth.instance.currentUser!.email);
      await userDocRef.update({
        'username': username.text,
      });
      log('User data updated successfully');
    } catch (e) {
      log('Error updating user data: $e');
    }
  }
}
