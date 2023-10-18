import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:runnn/signin_signup_forgot/check_role.dart';
import 'package:runnn/user/bottom_nav_page/bottom_nuv_user.dart';
import 'package:runnn/const/appcolors.dart';
import 'package:runnn/signin_signup_forgot/registration_screen.dart';

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
      //print(authCredential!.uid);
      if (authCredential!.uid.isNotEmpty) {
        //_checkRole();
        if (context.mounted) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const checkRole()));
        }
      } else {
        Fluttertoast.showToast(msg: "มีบางอย่างผิดปกติ");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        //Fluttertoast.showToast(msg: "ไม่พบอีเมลล์ของคุณ");
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text(
                  'ไม่พบอีเมลล์ของคุณ',
                  style: GoogleFonts.baiJamjuree(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              );
            });
      } else if (e.code == 'wrong-password') {
        //Fluttertoast.showToast(msg: "รหัสผ่านไม่ถูกต้อง");
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text(
                  'รหัสผ่านไม่ถูกต้อง',
                  style: GoogleFonts.baiJamjuree(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              );
            });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
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
                    const SizedBox(height: 10),
                    Text(
                      'ยินดีต้อนรับ',
                      style: GoogleFonts.baiJamjuree(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 20),
                    email(),
                    const SizedBox(height: 10),
                    passWord(),
                    const SizedBox(height: 10),
                    forgotPassword(context),
                    const SizedBox(height: 10),
                    loginButtom(),
                    const SizedBox(height: 10),
                    notMember(context),
                    const SizedBox(height: 10),
                    skipLogin(context),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  String timeDoc = DateFormat('dd_M_2566').format(DateTime.now());
  String time = DateFormat('dd/M/2566').format(DateTime.now());
  int count = 0;
  Center loginButtom() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 75.0),
        child: SizedBox(
          width: 150,
          height: 50,
          child: ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  signIn();
                  final countRouteMostRef = FirebaseFirestore.instance
                      .collection("Counter")
                      .doc(timeDoc);

                  final existingData = await countRouteMostRef.get();

                  if (existingData.exists) {
                    // กรณีมีข้อมูลอยู่แล้ว
                    final existingCount = existingData.data()?['count'] ?? 0;
                    count = existingCount +
                        1; // เพิ่มค่า count เมื่อเก็บข้อมูลต่อเนื่อง
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[300],
                elevation: 3,
              ),
              child: Text("เข้าสู่ระบบ", style: Textstyle().buttomTextWhite)),
        ),
      ),
    );
  }

  Padding email() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        style: GoogleFonts.baiJamjuree(color: Colors.black),
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
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

  Row notMember(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'ยังไม่ได้เป็นสมาชิก?',
          style: GoogleFonts.baiJamjuree(
              fontWeight: FontWeight.bold, color: Colors.black45),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => const RegistrationSrceen()));
          },
          child: Text(
            'สมัครสมาชิกตอนนี้',
            style: GoogleFonts.baiJamjuree(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Padding forgotPassword(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const ForgotPasswordPage();
                  },
                ),
              );
            },
            child: Text(
              'ลืมรหัสผ่าน?',
              style: GoogleFonts.baiJamjuree(
                  color: const Color.fromARGB(255, 0, 136, 255),
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Padding skipLogin(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () async {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ButtomNuvUser()));
              final countRouteMostRef =
                  FirebaseFirestore.instance.collection("Counter").doc(timeDoc);

              final existingData = await countRouteMostRef.get();

              if (existingData.exists) {
                // กรณีมีข้อมูลอยู่แล้ว
                final existingCount = existingData.data()?['count'] ?? 0;
                count = existingCount +
                    1; // เพิ่มค่า count เมื่อเก็บข้อมูลต่อเนื่อง
              } else {
                // กรณียังไม่มีข้อมูล
                count =
                    1; // เริ่มนับใหม่เมื่อเก็บข้อมูลลงคอลเลกชันที่ยังไม่มีข้อมูล
              }

              await countRouteMostRef.set({
                "count": count,
                "time": time,
              });
            },
            child: Text(
              'ข้ามการล็อกอิน>>>>',
              style: GoogleFonts.baiJamjuree(
                  color: const Color.fromARGB(255, 0, 136, 255),
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Padding passWord() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        style: GoogleFonts.baiJamjuree(color: Colors.black),
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
                  icon: const Icon(
                    Icons.visibility_off,
                  ))
              : IconButton(
                  onPressed: () {
                    setState(() {
                      _obscureText = true;
                    });
                  },
                  icon: const Icon(
                    Icons.remove_red_eye,
                  ),
                ),
        ),
      ),
    );
  }
}
