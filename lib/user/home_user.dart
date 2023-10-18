import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:runnn/admin/sideManuBar/noti/notification_services.dart';
import 'package:runnn/admin/sideManuBar/noti/screen_notification.dart';
import 'package:runnn/signin_signup_forgot/login_screen.dart';
import 'package:runnn/user/chat.dart';
import 'package:runnn/user/company_user.dart';
import 'package:runnn/user/map_user.dart';
import 'package:runnn/user/news_promotion_user.dart';
//import 'package:flutter/foundation.dart';

class HomeUser extends StatefulWidget {
  const HomeUser({Key? key}) : super(key: key);

  @override
  State<HomeUser> createState() => _HomeUserState();
}

class _HomeUserState extends State<HomeUser> {
  NotificationServices notificationServices = NotificationServices();
  @override
  void initState() {
    super.initState();
    checkAuthenticationStatus();
    setupInteractedMessage();
    notificationServices.requestNotificationPermission();
    getToken();
  }

  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data['type'] == 'news') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ScreenNotification(
                    topic: message.data['Topic'],
                    detail: message.data['Detail'],
                    imageUrlNews: message.data['imageUrlNews'],
                    time: message.data['time'],
                  )));
    }
  }

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  Future<void> getToken() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    var currentUser = auth.currentUser;
    String? token = await messaging.getToken();
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection("Users");

    if (currentUser != null) {
      collectionRef
          .doc(currentUser.email)
          .update({'token': token}).then((value) {
        print(token);
      });
    } else {
      FirebaseFirestore.instance
          .collection("token")
          .add({'token': token}).then((value) {
        print(token);
      });
    }
  }

  Future logout() async {
    await FirebaseAuth.instance.signOut().then((value) => Navigator.of(context)
        .pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false));
  }

  //เช็ค User
  bool _isAuthenticated = false;
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
        title: Text(
          'หน้าหลัก',
          style: GoogleFonts.baiJamjuree(color: Colors.white),
        ),
        centerTitle: false,
        leading: const Icon(Icons.home),
        actions: [
          if (_isAuthenticated)
            IconButton(onPressed: logout, icon: const Icon(Icons.logout)),
        ],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 90,
                  width: 300,
                  child: FloatingActionButton.extended(
                      label: Text(
                        'รายชื่อบริษัทรถทัวร์',
                        style: GoogleFonts.baiJamjuree(
                            color: Colors.black, fontSize: 24),
                      ),
                      heroTag: 'รายชื่อบริษัทรถทัวร์',
                      backgroundColor: const Color.fromARGB(255, 65, 200, 241),
                      icon: const Icon(
                        Icons.directions_bus_filled_outlined,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (_) => const CompanyUser()));
                      }),
                ),
                const SizedBox(
                  height: 12,
                ),
                SizedBox(
                  height: 90,
                  width: 300,
                  child: FloatingActionButton.extended(
                    label: Text(
                      'สอบถามข้อมูล',
                      style: GoogleFonts.baiJamjuree(
                          color: Colors.black, fontSize: 24),
                    ),
                    heroTag: 'สอบถามข้อมูล',
                    backgroundColor: const Color.fromARGB(255, 65, 200, 241),
                    icon: const Icon(
                      Icons.chat,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          CupertinoPageRoute(builder: (_) => const Chat()));
                    },
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                SizedBox(
                  height: 90,
                  width: 300,
                  child: FloatingActionButton.extended(
                    label: Text(
                      'ข่าวสารโปรโมชั่น',
                      style: GoogleFonts.baiJamjuree(
                          color: Colors.black, fontSize: 24),
                    ),
                    heroTag: 'ข่าวสารโปรโมชั่น',
                    backgroundColor: const Color.fromARGB(255, 65, 200, 241),
                    icon: const Icon(
                      Icons.notifications_active,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const NewsPromotionUser()));
                    },
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                SizedBox(
                  height: 90,
                  width: 300,
                  child: FloatingActionButton.extended(
                    label: Text(
                      'ขนส่งใกล้ฉัน',
                      style: GoogleFonts.baiJamjuree(
                        color: Colors.black,
                        fontSize: 24,
                      ),
                    ),
                    heroTag: 'ขนส่งใกล้ฉัน',
                    backgroundColor: const Color.fromARGB(255, 65, 200, 241),
                    icon: const Icon(
                      Icons.maps_home_work,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (_) => const MapScreenUser(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
