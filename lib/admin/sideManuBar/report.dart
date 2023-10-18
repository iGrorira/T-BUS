import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:runnn/const/appcolors.dart';

class ReportAdmin extends StatefulWidget {
  const ReportAdmin({super.key});

  @override
  State<ReportAdmin> createState() => _ReportAdminState();
}

class _ReportAdminState extends State<ReportAdmin> {
  String timeDate = DateFormat('dd MMMM 2566').format(DateTime.now());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'วันที่ $timeDate',
                  style: Textstyle().text20,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  fetchUseApp(),
                  fetchAllUser(),
                  fetchAllCompany(),
                  fetchAllRoute(),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Container(
                      width: 524,
                      height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: const Color(0xff9dd1ef),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 5),
                              child: Text(
                                'เส้นทางที่ถูกค้นหามากที่สุด 5 อันดับ',
                                style: Textstyle().text20,
                              ),
                            ),
                            fetchRouteMost(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Container(
                      width: 524,
                      height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: const Color(0xffa3dcfd),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 5),
                              child: Text(
                                'บริษัทที่ถูกค้นหามากที่สุด 5 อันดับ',
                                style: Textstyle().text20,
                              ),
                            ),
                            fetchCompanyMost(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  String time = DateFormat('dd_M_2566').format(DateTime.now());

  fetchCompanyMost() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("CountCompanyMost")
          .doc(time)
          .collection('Company')
          .orderBy('count', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Column(
            children: [
              Center(
                child: Text(
                  'ยังไม่มีข้อมูล',
                  style: Textstyle().text18,
                ),
              )
            ],
          );
        }

        // ดึงข้อมูลจาก snapshot
        List<DocumentSnapshot> documents = snapshot.data!.docs;

        return ListView.builder(
          shrinkWrap: true,
          itemCount: documents.length < 5 ? documents.length : 5,
          itemBuilder: (context, index) {
            Map<String, dynamic> data =
                documents[index].data() as Map<String, dynamic>;
            if (index < documents.length) {
              return ListTile(
                title: Text(
                  "${index + 1}. ${data['NameTour']}",
                  style: Textstyle().text18,
                ),
                trailing: Text(
                  data['count'].toString(),
                  style: Textstyle().text18,
                ),
              );
            } else {
              return null; // หรือ Widget ที่ไม่แสดงอะไรเลย
            }
          },
        );
      },
    );
  }

  fetchRouteMost() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("CountRouteMost")
          .doc(time)
          .collection('Route')
          .orderBy('count', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Column(
            children: [
              Center(
                child: Text(
                  'ยังไม่มีข้อมูล',
                  style: Textstyle().text18,
                ),
              )
            ],
          );
        }

        // ดึงข้อมูลจาก snapshot
        List<DocumentSnapshot> documents = snapshot.data!.docs;

        return ListView.builder(
          shrinkWrap: true,
          itemCount: documents.length < 5 ? documents.length : 5,
          itemBuilder: (context, index) {
            Map<String, dynamic> data =
                documents[index].data() as Map<String, dynamic>;
            if (index < documents.length) {
              return ListTile(
                title: Text(
                  "${index + 1}. ${data['routeTour']}",
                  style: Textstyle().text18,
                ),
                trailing: Text(
                  data['count'].toString(),
                  style: Textstyle().text18,
                ),
              );
            } else {
              return null; // หรือ Widget ที่ไม่แสดงอะไรเลย
            }
          },
        );
      },
    );
  }

  //จำนวนเข้าใช้งานวันนี้
  fetchUseApp() {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection("Counter")
          .doc(time)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        return Padding(
          padding: const EdgeInsets.all(12),
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xffcdff8d),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    snapshot.data?.data()?["count"].toString() ?? "0",
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 48,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'จำนวนเข้าใช้งานวันนี้',
                    style: Textstyle().text18,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

//จำนวนผู้ใช้งานทั้งหมด
  fetchAllUser() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Users').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        /*if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // หรือ Widget ที่แสดงในระหว่างโหลดข้อมูล
        }*/
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xfffae89f),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '0',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 48,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'จำนวนผู้ใช้งานทั้งหมด',
                      style: Textstyle().text18,
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // นับจำนวน doc.id ที่ถูกส่งกลับมาจาก Firebase
        int numberOfDocs = snapshot.data!.docs.length;

        return Padding(
          padding: const EdgeInsets.all(12),
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xfffae89f),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$numberOfDocs',
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 48,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'จำนวนผู้ใช้งานทั้งหมด',
                    style: Textstyle().text18,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  //จำนวนบริษัททั้งหมด
  fetchAllCompany() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('nameTour').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xfffdbe97),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '0',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 48,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'จำนวนบริษัททั้งหมด',
                      style: Textstyle().text18,
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // นับจำนวน doc.id ที่ถูกส่งกลับมาจาก Firebase
        int numberOfDocs = snapshot.data!.docs.length;

        return Padding(
          padding: const EdgeInsets.all(12),
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xfffdbe97),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$numberOfDocs',
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 48,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'จำนวนบริษัททั้งหมด',
                    style: Textstyle().text18,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  //จำนวนเที่ยวรถทั้งหมด
  fetchAllRoute() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('ListCar').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xffffa9a9),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '0',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 48,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'จำนวนเที่ยวรถทั้งหมด',
                      style: Textstyle().text18,
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // นับจำนวน doc.id ที่ถูกส่งกลับมาจาก Firebase
        int numberOfDocs = snapshot.data!.docs.length;

        return Padding(
          padding: const EdgeInsets.all(12),
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xffffa9a9),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$numberOfDocs',
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 48,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'จำนวนเที่ยวรถทั้งหมด',
                    style: Textstyle().text18,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
