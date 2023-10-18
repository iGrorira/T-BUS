// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:runnn/const/appcolors.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(
                'ส่งลิงค์เพื่อรีเซ็ตรหัสผ่านแล้ว! กรุณาตรวจสอบอีเมลของคุณ',
                style: GoogleFonts.baiJamjuree(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            );
          });
    } on FirebaseAuthException catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'รีเซ็ทรหัสผ่าน',
          style: GoogleFonts.baiJamjuree(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent[500],
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'กรอกอีเมลที่ใช้ในการสมัครเพื่อรับลิงค์ในการรีเซ็ทรหัสผ่าน',
              style: GoogleFonts.baiJamjuree(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
            ),
          ),

          // email textfield
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextField(
              style: GoogleFonts.baiJamjuree(color: Colors.black),
              controller: _emailController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blueAccent),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.appblue),
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: 'อีเมล',
                fillColor: Colors.grey[200],
                filled: true,
              ),
            ),
          ),
          const SizedBox(height: 10),
          MaterialButton(
            onPressed: passwordReset,
            color: Colors.blue[300],
            child: Text(
              'รีเซ็ทรหัสผ่าน',
              style: GoogleFonts.baiJamjuree(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
