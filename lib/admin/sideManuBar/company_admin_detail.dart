import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:runnn/admin/add_edit/add_edit_conpany_detail.dart';
import 'package:runnn/admin/model/model.dart';
import 'package:runnn/const/appColors.dart';

class CompanyAdminDetail extends StatelessWidget {
  final listCompany;
  const CompanyAdminDetail({super.key, this.listCompany});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) =>
                    AddEditCompanyDetail(idCompany: listCompany['id']))),
        label: const Text('เพิ่มเพิ่มจุดจำหน่ายตั๋ว'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.pink[300],
      ),
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        title: Text(
          "รายละเอียด",
          style: Textstyle().textTitleAppbar,
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 250,
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
                        listCompany['NameTour'],
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
                child: Text(listCompany['Central'], style: Textstyle().text18),
              ),
              const SizedBox(height: 10),
              Text("ภาคตะวันออกเฉียงเหนือ", style: Textstyle().text20),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child:
                    Text(listCompany['Northeast'], style: Textstyle().text18),
              ),
              const SizedBox(height: 10),
              Text("ภาคเหนือ", style: Textstyle().text20),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(listCompany['Northern'], style: Textstyle().text18),
              ),
              const SizedBox(height: 10),
              Text("ภาคใต้", style: Textstyle().text20),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(listCompany['Southern'], style: Textstyle().text18),
              ),
              const SizedBox(height: 10),
              Text("ภาคตะวันออก", style: Textstyle().text20),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(listCompany['Eastern'], style: Textstyle().text18),
              ),
              const SizedBox(height: 20),
              Text(
                "ศูนย์บริการ",
                style: GoogleFonts.baiJamjuree(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: Colors.black),
              ),
              const SizedBox(height: 10),
              fetchSaleTicketPoint(),
            ],
          ),
        )),
      ),
    );
  }

  fetchSaleTicketPoint() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('SaleTicketPoint')
          .doc(listCompany.id)
          .collection("SalePoint")
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot data = snapshot.data!.docs[index];
            return Slidable(
                endActionPane: ActionPane(
                  motion: const StretchMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        final company = Detail_SaleTicket_model(
                          id: data.id,
                          name: data["name"],
                          address: data["address"],
                          contact: data["contact"],
                          officeHours: data["officeHours"],
                          latitude: data['latitude'],
                          longitude: data['longitude'],
                        );
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => AddEditCompanyDetail(
                                      index: index,
                                      busStation: company,
                                      idCompany: listCompany['id'],
                                    ))));
                      },
                      backgroundColor: const Color(0xFF21B7CA),
                      foregroundColor: Colors.white,
                      icon: Icons.edit,
                      label: 'แก้ไข',
                    ),
                    SlidableAction(
                      onPressed: (context) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  'ลบข้อมูล?',
                                  style: Textstyle().text20,
                                ),
                                content: Text(
                                  'คุณแน่ใจหรือว่าต้องการลบรายการนี้หรือไม่?',
                                  style: Textstyle().text18,
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
                                        Navigator.pop(context);
                                        FirebaseFirestore.instance
                                            .collection('SaleTicketPoint')
                                            .doc(listCompany.id)
                                            .collection("SalePoint")
                                            .doc(data.id)
                                            .delete();
                                      },
                                      child: const Text('ลบ')),
                                ],
                              );
                            });
                      },
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'ลบ',
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      right: 30, left: 30, top: 7, bottom: 7),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
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
                            0: FlexColumnWidth(1),
                            1: FlexColumnWidth(5),
                          },
                          children: [
                            TableRow(children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  "ที่ตั้ง :",
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
                ));
          },
        );
      },
    );
  }
}
