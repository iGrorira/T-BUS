import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:runnn/const/appColors.dart';

class AddDetailDropdown extends StatelessWidget {
  AddDetailDropdown({Key? key}) : super(key: key);

  final provinces = TextEditingController();
  final routes = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();

  void addRoute() {
    firestore.collection('Route').add({
      "route": routes.text,
    });
    routes.clear();
  }

  void addProvince() {
    firestore.collection('Province').add({
      "province": provinces.text,
    });
    provinces.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('ชื่อจังหวัด', style: Textstyle().text18),
              const SizedBox(height: 10),
              Row(
                children: [
                  proVinces(),
                  const SizedBox(width: 12),
                  SizedBox(
                    height: 50,
                    width: 150,
                    child: FloatingActionButton.extended(
                      label: Text('เพิ่มจังหวัด', style: Textstyle().text18),
                      heroTag: 'เพิ่มจังหวัด',
                      backgroundColor: const Color.fromARGB(255, 65, 200, 241),
                      onPressed: () {
                        if (provinces.text.isNotEmpty) {
                          // เช็คว่ามีข้อมูลที่กรอกเข้ามาหรือไม่
                          addProvince();
                          Fluttertoast.showToast(msg: "เพิ่มข้อมูลสำเร็จ");
                        } else {
                          Fluttertoast.showToast(msg: "กรุณากรอกจุดจอดรถ");
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text('จุดจอดรถ', style: Textstyle().text18),
              const SizedBox(height: 10),
              Row(
                children: [
                  rouTes(),
                  const SizedBox(width: 12),
                  SizedBox(
                    height: 50,
                    width: 150,
                    child: FloatingActionButton.extended(
                      label: Text('เพิ่มจุดจอดรถ', style: Textstyle().text18),
                      heroTag: 'เพิ่มจุดจอดรถ',
                      backgroundColor: const Color.fromARGB(255, 65, 200, 241),
                      onPressed: () {
                        if (routes.text.isNotEmpty) {
                          // เช็คว่ามีข้อมูลที่กรอกเข้ามาหรือไม่
                          addRoute();
                          Fluttertoast.showToast(msg: "เพิ่มข้อมูลสำเร็จ");
                        } else {
                          Fluttertoast.showToast(msg: "กรุณากรอกจุดจอดรถ");
                        }
                      },
                    ),
                  ),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }

  SizedBox rouTes() {
    return SizedBox(
      width: 500,
      child: TextFormField(
        style: const TextStyle(fontSize: 16, color: Colors.black),
        keyboardType: TextInputType.text,
        controller: routes,
        decoration: InputDecoration(
          labelText: 'จุดจอดรถ',
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: Color.fromARGB(255, 0, 65, 117)),
          ),
        ),
      ),
    );
  }

  SizedBox proVinces() {
    return SizedBox(
      width: 500,
      child: TextFormField(
        style: const TextStyle(fontSize: 16, color: Colors.black),
        keyboardType: TextInputType.text,
        controller: provinces,
        decoration: InputDecoration(
          labelText: 'จังหวัด',
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: Color.fromARGB(255, 0, 65, 117)),
          ),
        ),
      ),
    );
  }
}
