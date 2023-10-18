// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:runnn/const/appcolors.dart';
import 'package:runnn/main.dart';
import 'package:runnn/signin_signup_forgot/login_screen.dart';
import 'package:runnn/user/bottom_nav_page/profileSetting/favourite_user.dart';
import 'package:runnn/user/bottom_nav_page/profileSetting/company_boomask_user.dart';
import 'package:runnn/user/bottom_nav_page/profileSetting/history.dart';
import 'package:runnn/user/bottom_nav_page/profileSetting/profile_user.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ข้อมูลส่วนตัว', style: Textstyle().text20),
      ),
      body: _isAuthenticated
          ? Column(
              children: [
                fechData(),
                Divider(
                  height: 1,
                  color: Colors.black45,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => CompanyBookmaskUser()));
                  },
                  child: ListTile(
                    leading: Icon(Icons.bookmark),
                    title: Text(
                      'ดูบริษัทที่กดติดตาม',
                      style: Textstyle().text18,
                    ),
                    trailing: Icon(Icons.navigate_next),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => FavouriteUser()));
                  },
                  child: ListTile(
                    leading: Icon(Icons.favorite),
                    title: Text(
                      'ดูข้อมูลที่กดถูกใจ',
                      style: Textstyle().text18,
                    ),
                    trailing: Icon(Icons.navigate_next),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => History()));
                  },
                  child: ListTile(
                    leading: Icon(Icons.search),
                    title: Text(
                      'เที่ยวรถที่พึ่งดู',
                      style: Textstyle().text18,
                    ),
                    trailing: Icon(Icons.navigate_next),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    logout();
                  },
                  child: ListTile(
                    leading: Icon(Icons.logout),
                    title: Text(
                      'ออกจากระบบ',
                      style: Textstyle().text18,
                    ),
                  ),
                ),
              ],
            )
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

  Future logout() async {
    await FirebaseAuth.instance.signOut().then((value) => Navigator.of(context)
        .pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false));
  }

  fechData() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .collection("UsersProfile")
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot data = snapshot.data!.docs[index];
              return Padding(
                padding: const EdgeInsets.only(top: 5),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(mq.height * .03),
                    child: CachedNetworkImage(
                      width: mq.height * .055,
                      height: mq.height * .055,
                      imageUrl: data['ImageUrl'],
                      //placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                    ),
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['username'],
                        style: Textstyle().text20,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => ProfileUser(
                                        profile: data,
                                      )));
                        },
                        child: Text(
                          'แก้ไขข้อมูลส่วนตัว',
                          style: TextStyle(color: Colors.blue, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else {}
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  fetchProfileUser() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .collection("UsersProfile")
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        // ดึงข้อมูลจาก Sub Collection
        final List<QueryDocumentSnapshot<Object?>> subCollectionData =
            snapshot.data!.docs;
        return ListView.builder(
          shrinkWrap: true,
          itemCount: subCollectionData.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(top: 5),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height * .03),
                  child: CachedNetworkImage(
                    width: mq.height * .055,
                    height: mq.height * .055,
                    imageUrl: subCollectionData[index]['ImageUrl'],
                    //placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                  ),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subCollectionData[index]['username'],
                      style: Textstyle().text20,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ProfileUser(
                                      profile: subCollectionData,
                                    )));
                      },
                      child: Text(
                        'แก้ไขข้อมูลส่วนตัว',
                        style: TextStyle(color: Colors.blue, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
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
