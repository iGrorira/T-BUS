import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:runnn/admin/Controller/controller.dart';
import 'package:runnn/admin/add_edit/add_edit_company.dart';
import 'package:runnn/admin/model/model.dart';
import 'package:runnn/admin/sideManuBar/company_admin_detail.dart';
import 'package:runnn/const/appcolors.dart';

class CompanyAdmin extends StatelessWidget {
  const CompanyAdmin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("ListCompany")
            .orderBy('NameTour', descending: false)
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
                return GestureDetector(
                  onTap: () {
                    CollectionReference collectionRef =
                        FirebaseFirestore.instance.collection("ListCompany");
                    collectionRef.doc(data.id).update({
                      "id": data.id.toString(),
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => CompanyAdminDetail(
                                  listCompany: data,
                                )));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: CachedNetworkImage(
                          imageUrl: data['ImageUrlLogo'],
                          height: 80,
                          width: 60,

                          //placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const CircleAvatar(
                            child: Icon(Icons.image),
                          ),
                        ),
                      ),
                      title: Text(
                        data['NameTour'],
                        style: GoogleFonts.baiJamjuree(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () {
                                final company = company_model(
                                  id: data.id,
                                  ImageUrlLogo: data["ImageUrlLogo"],
                                  NameTour: data["NameTour"],
                                  Number: data["Number"],
                                  Northeast: data["Northeast"],
                                  Central: data["Central"],
                                  Southern: data["Southern"],
                                  Northern: data["Northern"],
                                  Eastern: data["Eastern"],
                                );

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) => addEditCompany(
                                            company: company, index: index))));
                              },
                              icon: const Icon(Icons.edit)),
                          IconButton(
                              onPressed: () {
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
                                                company_controller()
                                                    .detele_company(
                                                        company_model(
                                                            id: data.id));
                                              },
                                              child: const Text('ลบ')),
                                        ],
                                      );
                                    });
                              },
                              icon: const Icon(Icons.delete))
                        ],
                      ),
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
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const addEditCompany())),
        label: const Text('เพิ่มเพิ่มบริษัททัวร์'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.pink[300],
      ),
    );
  }
}
