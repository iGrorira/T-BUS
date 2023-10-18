import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:runnn/const/appcolors.dart';
import 'package:runnn/user/detail/company_detail.dart';

class CompanyBookmaskUser extends StatelessWidget {
  const CompanyBookmaskUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("รายชื่อบริษัททัวร์กดติดตาม"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("UsersFavouriteCompany")
            .doc(FirebaseAuth.instance.currentUser!.email)
            .collection("Company")
            .orderBy('NameTour', descending: true)
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
              'ไม่มีข้อมูลที่กดติดตาม',
              style: Textstyle().text20,
            ));
          }

          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot data = snapshot.data!.docs[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CompanyDetail(
                                listCompany: data,
                              )));
                },
                child: Slidable(
                  endActionPane: ActionPane(
                    motion: const StretchMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          FirebaseFirestore.instance
                              .collection("UsersFavouriteCompany")
                              .doc(FirebaseAuth.instance.currentUser!.email)
                              .collection("Company")
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
                      child: Row(children: [
                        const SizedBox(width: 3),
                        Center(
                          child: ClipRRect(
                            child: CachedNetworkImage(
                              imageUrl: data['ImageUrlLogo'],
                              width: 80,
                              height: 60,
                              //placeholder: (context, url) => CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const CircleAvatar(
                                child: Icon(Icons.image),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          data['NameTour'],
                          style: Textstyle().text18,
                        ),
                      ]),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
