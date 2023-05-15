import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:runnn/ui/bottom_nav_controller.dart';
import 'package:runnn/signin_signup_forgot/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  signUp() async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);
      var authCredential = credential.user;
      print(authCredential!.uid);
      if (authCredential.uid.isNotEmpty) {
        Navigator.push(
            context, CupertinoPageRoute(builder: (_) => BottomNavController()));
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
                  const Text(
                    'สมัครสมาชิก',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Email(),
                  const SizedBox(height: 10),
                  Password(),
                  const SizedBox(height: 10),
                  confirmpassword(),
                  const SizedBox(height: 10),
                  BottomSignup(),
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

  Padding BottomSignup() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 75.0),
      child: GestureDetector(
        onTap: () {
          if (_formKey.currentState!.validate()) {
            signUp();
          }
        },
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: AppColors.buttomapp,
              borderRadius: BorderRadius.circular(12)),
          child: const Center(
            child: Text(
              'สมัครสมาชิก',
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

  Row aMember(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'เป็นสมาชิกอยู่แล้ว?',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const LoginScreen();
                },
              ),
            );
          },
          child: const Text(
            ' เข้าสู่ระบบเลย',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Padding SingInButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 75.0),
      child: GestureDetector(
        onTap: signUp,
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: AppColors.buttomapp,
              borderRadius: BorderRadius.circular(12)),
          child: const Center(
            child: Text(
              'สมัครสมาชิก',
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

  Padding confirmpassword() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
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
