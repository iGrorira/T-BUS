import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:runnn/admin/sideManuBar/car_admin.dart';
import 'package:runnn/admin/sideManuBar/company_admin.dart';
import 'package:runnn/admin/sideManuBar/news_promotion.dart';
import 'package:runnn/signin_signup_forgot/login_screen.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({Key? key}) : super(key: key);

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  Future logout() async {
    await FirebaseAuth.instance.signOut().then((value) => Navigator.of(context)
        .pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('หน้าหลักแอดมิน'),
        centerTitle: false,
        backgroundColor: const Color.fromARGB(255, 21, 79, 224),
        leading: const Icon(Icons.home),
        actions: [
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
                    width: 350,
                    child: FloatingActionButton.extended(
                        label: const Text(
                          'รายชื่อบริษัท',
                          style: TextStyle(fontSize: 24),
                        ),
                        heroTag: 'รายชื่อบริษัท',
                        backgroundColor:
                            const Color.fromARGB(255, 65, 200, 241),
                        icon: const Icon(
                          Icons.directions_bus_filled_outlined,
                          size: 30,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (_) => const CompanyAdmin()));
                        }),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 90,
                    width: 350,
                    child: FloatingActionButton.extended(
                        label: const Text(
                          'เที่ยวรถทัวร์',
                          style: TextStyle(fontSize: 24),
                        ),
                        heroTag: 'เที่ยวรถทัวร์',
                        backgroundColor:
                            const Color.fromARGB(255, 65, 200, 241),
                        icon: const Icon(
                          Icons.directions_bus_filled_outlined,
                          size: 30,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (_) => const CarAdmin()));
                        }),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 90,
                    width: 350,
                    child: FloatingActionButton.extended(
                        label: const Text(
                          'ขนส่ง',
                          style: TextStyle(fontSize: 24),
                        ),
                        heroTag: 'ขนส่ง',
                        backgroundColor:
                            const Color.fromARGB(255, 65, 200, 241),
                        icon: const Icon(
                          Icons.directions_bus_filled_outlined,
                          size: 30,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (_) => const CarAdmin()));
                        }),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 90,
                    width: 350,
                    child: FloatingActionButton.extended(
                        label: const Text(
                          'แชท',
                          style: TextStyle(fontSize: 24),
                        ),
                        heroTag: 'แชท',
                        backgroundColor:
                            const Color.fromARGB(255, 65, 200, 241),
                        icon: const Icon(
                          Icons.directions_bus_filled_outlined,
                          size: 30,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (_) => const CarAdmin()));
                        }),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 90,
                    width: 350,
                    child: FloatingActionButton.extended(
                        label: const Text(
                          'ข่าวสาร',
                          style: TextStyle(fontSize: 24),
                        ),
                        heroTag: 'ข่าวสาร',
                        backgroundColor:
                            const Color.fromARGB(255, 65, 200, 241),
                        icon: const Icon(
                          Icons.directions_bus_filled_outlined,
                          size: 30,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (_) => const newsPromotion()));
                        }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
