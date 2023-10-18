import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:runnn/signin_signup_forgot/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:runnn/user/bottom_nav_page/bottom_nuv_user.dart';
import '../const/appcolors.dart';

class RegistrationSrceen extends StatefulWidget {
  const RegistrationSrceen({Key? key}) : super(key: key);

  @override
  State<RegistrationSrceen> createState() => _RegistrationSrceenState();
}

class _RegistrationSrceenState extends State<RegistrationSrceen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  sendUserRole() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    var currentUser = auth.currentUser;
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection("Users");
    return collectionRef.doc(currentUser!.email).set({
      "role": "User",
      "email": currentUser.email,
    });
  }

  sendUserData() async {
    String time = DateFormat('dd2566kkmmss').format(DateTime.now());
    final FirebaseAuth auth = FirebaseAuth.instance;
    var currentUser = auth.currentUser;
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection("Users");
    return collectionRef
        .doc(currentUser!.email)
        .collection("UsersProfile")
        .doc(currentUser.email)
        .set({
      "username": "username$time",
      "email": currentUser.email,
      "ImageUrl":
          "https://firebasestorage.googleapis.com/v0/b/runnn-tbus.appspot.com/o/profileUser%2Fprofiletbus.png?alt=media&token=287b6502-959e-4f72-b7a8-692e2afccb14",
    });
  }

  signUp() async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);
      var authCredential = credential.user;
      log(authCredential!.uid);
      sendUserRole();
      sendUserData();
      if (authCredential.uid.isNotEmpty) {
        Navigator.push(
            context, CupertinoPageRoute(builder: (_) => const ButtomNuvUser()));
      } else {
        Fluttertoast.showToast(msg: "Something is wrong");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(msg: "The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(
            msg: "The account already exists for that email.");
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appblue,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "icons/logotbus.png",
                    width: 160,
                    height: 160,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'สมัครสมาชิก',
                    style: GoogleFonts.baiJamjuree(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 20),
                  Email(),
                  const SizedBox(height: 10),
                  Password(),
                  const SizedBox(height: 10),
                  confirmpassword(),
                  const SizedBox(height: 10),
                  button(),
                  const SizedBox(height: 10),
                  aMember(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String timeDoc = DateFormat('dd_M_2566').format(DateTime.now());
  String time = DateFormat('dd/M/2566').format(DateTime.now());
  int count = 0;
  Padding button() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 100),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.buttomapp,
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
          shape: const StadiumBorder(),
        ),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            signUp();
            final countRouteMostRef =
                FirebaseFirestore.instance.collection("Counter").doc(timeDoc);

            final existingData = await countRouteMostRef.get();

            if (existingData.exists) {
              // กรณีมีข้อมูลอยู่แล้ว
              final existingCount = existingData.data()?['count'] ?? 0;
              count =
                  existingCount + 1; // เพิ่มค่า count เมื่อเก็บข้อมูลต่อเนื่อง
            } else {
              // กรณียังไม่มีข้อมูล
              count =
                  1; // เริ่มนับใหม่เมื่อเก็บข้อมูลลงคอลเลกชันที่ยังไม่มีข้อมูล
            }

            await countRouteMostRef.set({
              "count": count,
              "time": time,
            });
          }
        },
        child: Center(
          child: Text(
            'สมัครสมาชิก',
            style: GoogleFonts.baiJamjuree(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Row aMember(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'เป็นสมาชิกอยู่แล้ว?',
          style: GoogleFonts.baiJamjuree(
              fontWeight: FontWeight.bold, color: Colors.black),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(context,
                CupertinoPageRoute(builder: (context) => const LoginScreen()));
          },
          child: Text(
            'เข้าสู่ระบบเลย',
            style: GoogleFonts.baiJamjuree(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Padding confirmpassword() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        style: GoogleFonts.baiJamjuree(color: Colors.black),
        controller: _confirmpasswordController,
        obscureText: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: Color.fromARGB(255, 0, 65, 117)),
          ),
          labelText: 'ยืนยันรหัสผ่าน',
          fillColor: Colors.white,
          filled: true,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'กรุณาใส่รหัสผ่าน';
          }

          if (_passwordController.text != _confirmpasswordController.text) {
            return "รหัสผ่านไม่ตรงกัน";
          }

          return null;
        },
      ),
    );
  }

  Padding Password() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        style: GoogleFonts.baiJamjuree(color: Colors.black),
        controller: _passwordController,
        obscureText: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: Color.fromARGB(255, 0, 65, 117)),
          ),
          labelText: 'รหัสผ่าน',
          fillColor: Colors.white,
          filled: true,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'กรุณาใส่รหัสผ่าน';
          }
          if (_passwordController.text != _confirmpasswordController.text) {
            return "รหัสผ่านไม่ตรงกัน";
          }

          return null;
        },
      ),
    );
  }

  Padding Email() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        style: GoogleFonts.baiJamjuree(color: Colors.black),
        controller: _emailController,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: Color.fromARGB(255, 0, 65, 117)),
          ),
          labelText: 'อีเมล',
          fillColor: Colors.white,
          filled: true,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'กรุณาใส่อีเมล';
          }
          return null;
        },
      ),
    );
  }
}
