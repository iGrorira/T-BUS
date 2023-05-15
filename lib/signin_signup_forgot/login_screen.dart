import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:runnn/admin/add_car.dart';
import 'package:runnn/admin/company_admin.dart';
import 'package:runnn/bottom_nav_page/home.dart';
import 'package:runnn/bottom_nav_page/bottom_nuv_user.dart';
import 'package:runnn/const/appcolors.dart';
import 'package:runnn/admin/car.dart';
import 'package:runnn/signin_signup_forgot/registration_screen.dart';
import 'package:runnn/ui/bottom_nav_controller.dart';

import 'forgot_password_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  String role = 'User';
  final _formKey = GlobalKey<FormState>();

  signIn() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
      var authCredential = credential.user;
      print(authCredential!.uid);
      if (authCredential.uid.isNotEmpty) {
        _checkRole();
        /*Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => const AddCar(),
          ),
        );*/
      } else {
        Fluttertoast.showToast(msg: "มีบางอย่างผิดปกติ");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(msg: "ไม่พบอีเมลล์ของคุณ");
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(msg: "ผ่านไม่ถูกต้อง");
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    _checkRole();
    super.initState();
  }

  void _checkRole() async {
    final DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users-form-data')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .get();

    setState(() {
      role = snap['role'];
    });

    if (role == 'User') {
      Navigator.push(
          context, CupertinoPageRoute(builder: (_) => const ButtomNuvUser()));
    } else if (role == 'Admin') {
      Navigator.push(
          context, CupertinoPageRoute(builder: (_) => const AddCar()));
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
                      width: 170,
                      height: 170,
                    ),
                    const Text(
                      'ยินดีต้อนรับ',
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 20),
                    Email(),
                    const SizedBox(height: 10),
                    Password(),
                    const SizedBox(height: 10),
                    ForgotPassword(context),
                    const SizedBox(height: 10),
                    BottonSignIn(),
                    const SizedBox(height: 10),
                    NotMember(context),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Padding bottom2(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 75.0),
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            signIn();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('เข้าสู่ระบบสำเร็จ')),
            );
          }
        },
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
    );
  }

  Padding BottonSignIn() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 75.0),
      child: GestureDetector(
        onTap: () {
          if (_formKey.currentState!.validate()) {
            signIn();
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

  Padding Email() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        controller: _emailController,
        decoration: InputDecoration(
          labelText: 'อีเมล',
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
            return 'กรุณาใส่อีเมล';
          }
          return null;
        },
      ),
    );
  }

  Row NotMember(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'ยังไม่ได้เป็นสมาชิก?',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => const RegistrationSrceen()));
          },
          child: const Text(
            'สมัครสมาชิกตอนนี้',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Padding ForgotPassword(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const ForgotPasswordPage();
                  },
                ),
              );
            },
            child: const Text('ลืมรหัสผ่าน?',
                style: TextStyle(
                    color: Color.fromARGB(255, 0, 136, 255),
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Padding Password() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'กรุณาใส่รหัสผ่าน';
          }
          return null;
        },
        controller: _passwordController,
        obscureText: _obscureText,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: Color.fromARGB(255, 0, 65, 117)),
          ),
          labelText: 'รหัสผ่าน',
          fillColor: Colors.white,
          filled: true,
          suffixIcon: _obscureText == true
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _obscureText = false;
                    });
                  },
                  icon: Icon(
                    Icons.remove_red_eye,
                    size: 20.w,
                  ))
              : IconButton(
                  onPressed: () {
                    setState(() {
                      _obscureText = true;
                    });
                  },
                  icon: Icon(
                    Icons.visibility_off,
                    size: 20.w,
                  ),
                ),
        ),
      ),
    );
  }
}
