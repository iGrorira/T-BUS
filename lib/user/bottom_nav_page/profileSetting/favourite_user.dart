import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:runnn/const/appcolors.dart';
import 'package:runnn/signin_signup_forgot/login_screen.dart';
import 'package:runnn/user/detail/car_detail_user.dart';

class FavouriteUser extends StatefulWidget {
  const FavouriteUser({super.key});

  @override
  State<FavouriteUser> createState() => _FavouriteUserState();
}

class _FavouriteUserState extends State<FavouriteUser> {
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
        leading: const Icon(Icons.favorite),
        title: const Text("เที่ยวรถที่กดถูกใจ"),
      ),
      body: _isAuthenticated
          ? StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("UsersFavouriteCar")
                  .doc(FirebaseAuth.instance.currentUser!.email)
                  .collection("Car")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (!snapshot.hasData || snapshot.data == null) {
                  return Center(
                      child: Text(
                    'ไม่มีข้อมูลที่กดถูกใจ',
                    style: Textstyle().text20,
                  ));
                }
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot data = snapshot.data!.docs[index];
                        return Slidable(
                          endActionPane: ActionPane(
                            motion: const StretchMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  FirebaseFirestore.instance
                                      .collection("UsersFavouriteCar")
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.email)
                                      .collection("Car")
                                      .doc(data.id)
                                      .delete();
                                },
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'ลบ',
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      // Set border width

                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10.0),
                                      ), // Set rounded corner radius
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 5,
                                          color: Colors.grey,
                                          offset: Offset(1, 3),
                                        ),
                                      ], // Make rounded corner of border
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  data["DepartureTime"],
                                                  style:
                                                      GoogleFonts.baiJamjuree(
                                                          fontSize: 20,
                                                          color: Colors.black),
                                                ),
                                                Text(
                                                  data["Origin"],
                                                  style:
                                                      GoogleFonts.baiJamjuree(
                                                          fontSize: 20,
                                                          color: Colors.black),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                const SizedBox(height: 2),
                                                Text(
                                                  data["NameTour"],
                                                  style:
                                                      GoogleFonts.baiJamjuree(
                                                          fontSize: 20,
                                                          color: Colors.black),
                                                ),
                                                const Icon(
                                                  Icons.directions_bus,
                                                  color: Colors.blue,
                                                ),
                                                Text(
                                                  data["TypeofCar"],
                                                  style:
                                                      GoogleFonts.baiJamjuree(
                                                          fontSize: 20,
                                                          color: Colors.black),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  data["TimetoArrive"],
                                                  style:
                                                      GoogleFonts.baiJamjuree(
                                                          fontSize: 20,
                                                          color: Colors.black),
                                                ),
                                                Text(
                                                  data["Destination"],
                                                  style:
                                                      GoogleFonts.baiJamjuree(
                                                          fontSize: 20,
                                                          color: Colors.black),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const Divider(
                                          color: Colors.black38,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            GestureDetector(
                                              onTap: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      carDetailUser(
                                                    listCar: data,
                                                  ),
                                                ),
                                              ),
                                              child: Text(
                                                "รายละเอียดเพิ่มเติม",
                                                style: GoogleFonts.baiJamjuree(
                                                    fontSize: 18,
                                                    color: const Color.fromARGB(
                                                        255, 93, 176, 244)),
                                              ),
                                            ),
                                            Text(
                                              "${data['Price']} บาท",
                                              style: GoogleFonts.baiJamjuree(
                                                  fontSize: 20,
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                } else {}
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
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
