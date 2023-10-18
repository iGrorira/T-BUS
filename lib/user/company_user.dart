import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:runnn/const/appcolors.dart';
import 'package:runnn/user/detail/company_detail.dart';

class CompanyUser extends StatelessWidget {
  const CompanyUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("รายชื่อบริษัททัวร์"),
      ),
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
                );
              },
            );
          } else {}
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
