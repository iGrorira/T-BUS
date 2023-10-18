import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:runnn/const/appColors.dart';
import 'package:runnn/user/detail/car_detail_user.dart';

class History extends StatelessWidget {
  const History({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('เที่ยวรถที่พึ่งดูไป'),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("UsersHistory")
              .doc(FirebaseAuth.instance.currentUser!.email)
              .collection("HistoryCar")
              .orderBy('timestamp', descending: true)
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
                'ไม่มีข้อมูลที่พึ่งดูไป',
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
                                  .collection("UsersHistory")
                                  .doc(FirebaseAuth.instance.currentUser!.email)
                                  .collection("HistoryCar")
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
                                              style: Textstyle().text20,
                                            ),
                                            Text(
                                              data["Origin"],
                                              style: Textstyle().text20,
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            const SizedBox(height: 2),
                                            Text(
                                              data["NameTour"],
                                              style: Textstyle().text20,
                                            ),
                                            const Icon(
                                              Icons.directions_bus,
                                              color: Colors.blue,
                                            ),
                                            Text(
                                              data["TypeofCar"],
                                              style: Textstyle().text20,
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              data["TimetoArrive"],
                                              style: Textstyle().text20,
                                            ),
                                            Text(
                                              data["Destination"],
                                              style: Textstyle().text20,
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
                                          style: Textstyle().text20,
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
        ));
  }
}
