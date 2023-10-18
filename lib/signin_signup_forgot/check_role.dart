// ignore_for_file: camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:runnn/admin/sideManuBar/side_manu_bar.dart';
import 'package:runnn/user/bottom_nav_page/bottom_nuv_user.dart';

class checkRole extends StatefulWidget {
  const checkRole({super.key});

  @override
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
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .get();

    setState(() {
      role = snap['role'];
    });

    if (role == 'User') {
      navigateNext(const ButtomNuvUser());
    } else if (role == 'Admin') {
      navigateNext(const SideBarManu());
    }
  }

  void navigateNext(Widget route) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => route));
  }

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
