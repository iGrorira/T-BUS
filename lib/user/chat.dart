import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:runnn/const/appcolors.dart';
import 'package:runnn/signin_signup_forgot/login_screen.dart';
import 'package:runnn/user/chat_to_admin.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "แชทกับแอดมิน",
          style: Textstyle().textTitleAppbar,
        ),
      ),
      body: _isAuthenticated
          ? const ChatToAdmin()
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'กรุณาเข้าสู่ระบบ',
                    style: Textstyle().text20,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  buttom(context),
                ],
              ),
            ),
    );
  }

  //เช็ค User
  bool _isAuthenticated = false;
  @override
  void initState() {
    super.initState();
    checkAuthenticationStatus();
  }

  Future<void> checkAuthenticationStatus() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    var currentUser = auth.currentUser;
    if (currentUser != null) {
      setState(() {
        _isAuthenticated = true;
      });
    } else {
      setState(() {
        _isAuthenticated = false;
      });
    }
  }

  Padding buttom(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 75.0),
      child: SizedBox(
        width: 150,
        height: 50,
        child: ElevatedButton(
          onPressed: () async {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[300],
            elevation: 3,
          ),
          child: Text(
            "ล็อกอิน",
            style: GoogleFonts.baiJamjuree(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
