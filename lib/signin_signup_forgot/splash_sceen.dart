import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:runnn/const/appColors.dart';
import 'package:runnn/signin_signup_forgot/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(
        const Duration(seconds: 3),
        () => Navigator.push(
            context, CupertinoPageRoute(builder: (_) => const LoginScreen())));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //mq = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.appblue,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "icons/logotbus.png",
                width: 250,
                height: 250,
              ),
              const SizedBox(
                height: 60,
              ),
              const CircularProgressIndicator(
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
