import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
            return const AlertDialog(
              content:
                  Text('ส่งลิงค์รีเซ็ตรหัสผ่านแล้ว! กรุณาตรวจสอบอีเมลของคุณ'),
            );
          });
    } on FirebaseAuthException catch (e) {
      print(e);
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
        title: const Text('รีเซ็ทรหัสผ่าน'),
        backgroundColor: Colors.blueAccent[500],
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'กรอกอีเมลที่ใช้ในการสมัครเพื่อรับลิงค์ในการรีเซ็ทรหัสผ่าน',
              style: TextStyle(fontSize: 16),
            ),
          ),

          // email textfield
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextField(
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

          MaterialButton(
            onPressed: passwordReset,
            color: Colors.blue[300],
            child: const Text('รีเซ็ทรหัสผ่าน'),
          ),
        ],
      ),
    );
  }
}
