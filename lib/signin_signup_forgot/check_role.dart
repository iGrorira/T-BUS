// ignore_for_file: camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:runnn/bottom_nav_page/home.dart';

import 'package:runnn/admin/car.dart';

class checkRole extends StatefulWidget {
  const checkRole({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _checkRoleState createState() => _checkRoleState();
}

class _checkRoleState extends State<checkRole> {
  String role = 'User';

  @override
  void initState() {
    super.initState();
    _checkRole();
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
      navigateNext(const Home());
    } else if (role == 'Admin') {
      navigateNext(const CarAdmin());
    }
  }

  void navigateNext(Widget route) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => route));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Welcome'),
          ],
        ),
      ),
    );
  }
}
