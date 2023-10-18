import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:runnn/const/appColors.dart';
import 'package:runnn/signin_signup_forgot/login_screen.dart';

class CompanyDetail extends StatefulWidget {
  final DocumentSnapshot listCompany;
  const CompanyDetail({super.key, required this.listCompany});

  @override
  State<CompanyDetail> createState() => _CompanyDetailState();
}

class _CompanyDetailState extends State<CompanyDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
          title: Text(
            "รายละเอียด",
            style: Textstyle().textTitleAppbar,
          ),
          actions: _buildAppBarActions()),
      body: SingleChildScrollView(
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 200,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 2),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 5,
                        color: Colors.grey,
                        offset: Offset(1, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        widget.listCompany['NameTour'],
                        style: GoogleFonts.baiJamjuree(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "จังหวัดที่ให้บริการเดินรถ",
                style: GoogleFonts.baiJamjuree(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: Colors.black),
              ),
              const SizedBox(height: 10),
              Text("ภาคกลาง", style: Textstyle().text20),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(widget.listCompany['Central'],
                    style: Textstyle().text18),
              ),
              const SizedBox(height: 10),
              Text("ภาคตะวันออกเฉียงเหนือ", style: Textstyle().text20),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(widget.listCompany['Northeast'],
                    style: Textstyle().text18),
              ),
              const SizedBox(height: 10),
              Text("ภาคเหนือ", style: Textstyle().text20),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(widget.listCompany['Northern'],
                    style: Textstyle().text18),
              ),
              const SizedBox(height: 10),
              Text("ภาคใต้", style: Textstyle().text20),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(widget.listCompany['Southern'],
                    style: Textstyle().text18),
              ),
              const SizedBox(height: 10),
              Text("ภาคตะวันออก", style: Textstyle().text20),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(widget.listCompany['Eastern'],
                    style: Textstyle().text18),
              ),
              const SizedBox(height: 20),
              Text(
                "ศูนย์บริการ",
                style: GoogleFonts.baiJamjuree(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: Colors.black),
              ),
              const SizedBox(height: 2),
              fetchSaleTicketPoint(),
            ],
          ),
        )),
      ),
    );
  }

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

  //กดถูกใจ
  Future<void> toggleBookmaskCompany() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    var currentUser = auth.currentUser;
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection("UsersFavouriteCompany");

    final snapshot = await collectionRef
        .doc(currentUser!.email)
        .collection("Company")
        .where("NameTour", isEqualTo: widget.listCompany['NameTour'])
        .get();

    if (snapshot.docs.isEmpty) {
      // The item doesn't exist in the favorites, add it.
      await collectionRef
          .doc(currentUser.email)
          .collection("Company")
          .doc(widget.listCompany.id)
          .set({
        "ImageUrlLogo": widget.listCompany['ImageUrlLogo'],
        "Number": widget.listCompany['Number'],
        "NameTour": widget.listCompany['NameTour'],
        "Northeast": widget.listCompany['Northeast'],
        "Central": widget.listCompany["Central"],
        "Southern": widget.listCompany["Southern"],
        "Northern": widget.listCompany["Northern"],
        "Eastern": widget.listCompany["Eastern"],
      });
    } else {
      // The item already exists in the favorites, remove it.
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
    }
  }

  //เช็คการเข้าสู่ระบบ
  List<Widget> _buildAppBarActions() {
    if (_isAuthenticated) {
      // Actions for authenticated users
      return [
        StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("UsersFavouriteCompany")
              .doc(FirebaseAuth.instance.currentUser!.email)
              .collection("Company")
              .where("NameTour", isEqualTo: widget.listCompany['NameTour'])
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return const Text("");
            }
            return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: IconButton(
                  onPressed: toggleBookmaskCompany,
                  icon: snapshot.data.docs.isEmpty
                      ? const Icon(
                          Icons.bookmark_border_outlined,
                          color: Colors.white,
                        )
                      : const Icon(
                          Icons.bookmark,
                          color: Colors.amber,
                        ),
                ));
          },
        ),
      ];
    } else {
      // Actions for non-authenticated users
      return [
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(
                    'คุณต้องการเข้าสู่ระบบหรือไม่?',
                    style: Textstyle().text18,
                  ),
                  content: Text(
                    'กดตกลงเพื่อเข้าสู่ระบบ',
                    style: Textstyle().text16,
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('ยกเลิก'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const LoginScreen()),
                            (route) => false);
                      },
                      child: const Text(
                        'ตกลง',
                      ),
                    ),
                  ],
                );
              },
            );
          },
          icon: const Icon(
            Icons.bookmark_border_outlined,
            color: Colors.white,
          ),
        ),
      ];
    }
  }

  fetchSaleTicketPoint() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('SaleTicketPoint')
          .doc(widget.listCompany.id)
          .collection("SalePoint")
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        /*if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // หรือ Widget ที่แสดงในระหว่างโหลดข้อมูล
        }*/
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return Column(
            children: [
              Center(child: Text("ไม่มีข้อมูล", style: Textstyle().text18)),
            ],
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot data = snapshot.data!.docs[index];
            return Padding(
              padding:
                  const EdgeInsets.only(top: 8, bottom: 8, left: 5, right: 5),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0),
                  ),
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
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Center(
                          child: Text(
                        data['name'],
                        style: Textstyle().text18,
                      )),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Table(
                      columnWidths: const {
                        0: FlexColumnWidth(1.2),
                        1: FlexColumnWidth(3),
                      },
                      children: [
                        TableRow(children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              "ที่อยู่ :",
                              style: Textstyle().text18,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              data['address'],
                              style: Textstyle().text18,
                            ),
                          ),
                        ]),
                        TableRow(children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              "ติดต่อ :",
                              style: Textstyle().text18,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              data['contact'],
                              style: Textstyle().text18,
                            ),
                          ),
                        ]),
                        TableRow(children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              "เวลาทำการ :",
                              style: Textstyle().text18,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              data['officeHours'],
                              style: Textstyle().text18,
                            ),
                          ),
                        ]),
                      ],
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
}
