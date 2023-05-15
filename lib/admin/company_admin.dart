import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:runnn/admin/add_car.dart';
import 'package:runnn/admin/company1.dart';

class ComAdmin extends StatefulWidget {
  const ComAdmin({Key? key}) : super(key: key);

  @override
  State<ComAdmin> createState() => _ComAdminState();
}

class _ComAdminState extends State<ComAdmin> {
  final _firestoreInstance = FirebaseFirestore.instance;
  final List _company = [];

  fetchCars() async {
    QuerySnapshot qn = await _firestoreInstance.collection("ListCompany").get();

    setState(() {
      for (int i = 0; i < qn.docs.length; i++) {
        _company.add({
          "NameTour": qn.docs[i]["NameTour"],
          "imageUrl": qn.docs[i]["imageUrl"],
        });
      }
    });
  }

  @override
  void initState() {
    fetchCars();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("รายชื่อบริษัททัวร์"),
        actions: [
          IconButton(
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const AddCom())),
              icon: const Icon(Icons.add_circle_outline)),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _company.length,
                  itemBuilder: (_, index) {
                    return GestureDetector(
                      onTap: () {},
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
                            Image.network(
                              _company[index]["imageUrl"],
                              width: 80,
                              height: 60,
                            ),
                            Text("${_company[index]["NameTour"]}"),
                          ]),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
