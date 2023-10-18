// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:runnn/admin/model/model.dart';
import 'package:runnn/const/appcolors.dart';

class AddEditCompanyDetail extends StatefulWidget {
  final index;
  final idCompany;
  final Detail_SaleTicket_model? busStation;
  const AddEditCompanyDetail(
      {super.key, this.idCompany, this.index, this.busStation});

  @override
  State<AddEditCompanyDetail> createState() => _AddEditCompanyDetailState();
}

class _AddEditCompanyDetailState extends State<AddEditCompanyDetail> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();
  final id = TextEditingController();
  final name = TextEditingController();
  final address = TextEditingController();
  final contact = TextEditingController();
  final officeHours = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isEditingMode = false;
  @override
  void initState() {
    if (widget.index != null) {
      isEditingMode = true;
      id.text = widget.busStation?.id;
      name.text = widget.busStation?.name;
      address.text = widget.busStation?.address;
      contact.text = widget.busStation?.contact;
      officeHours.text = widget.busStation?.officeHours;
      double numberLatitude = widget.busStation?.latitude;
      double numberLongitude = widget.busStation?.longitude;
      latitudeController.text = numberLatitude.toString();
      longitudeController.text = numberLongitude.toString();
    } else {
      isEditingMode = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "เพิ่มจุดจำหน่ายตั๋ว",
          style: Textstyle().textTitleAppbar,
        ),
      ),
      body: Form(
        key: formKey,
        child: Center(
          child: SizedBox(
            width: 1120,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  nameAddress(),
                  const SizedBox(height: 10),
                  addressSaleTicket(),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      SizedBox(
                        height: 70,
                        width: 550,
                        child: liti(),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        height: 70,
                        width: 550,
                        child: long(),
                      ),
                    ],
                  ),
                  contactNumber(),
                  const SizedBox(height: 10),
                  officeHoursTime(),
                  const SizedBox(height: 10),
                  buttom(context)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField liti() {
    return TextFormField(
      style: const TextStyle(fontSize: 16, color: Colors.black),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      controller: latitudeController,
      decoration: InputDecoration(
        labelText: 'ละติจูด',
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color.fromARGB(255, 0, 65, 117)),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'กรุณาใส่รายละเอียด';
        }
        return null;
      },
    );
  }

  TextFormField long() {
    return TextFormField(
      style: const TextStyle(fontSize: 16, color: Colors.black),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      controller: longitudeController,
      decoration: InputDecoration(
        labelText: 'ลองติจูด',
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color.fromARGB(255, 0, 65, 117)),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'กรุณาใส่รายละเอียด';
        }
        return null;
      },
    );
  }

  void saveToLocations(latitude, longitude) {
    final CollectionReference reviewsRef =
        FirebaseFirestore.instance.collection('Locations');

    reviewsRef.doc().set({
      'name': name.text,
      'address': address.text,
      'latitude': latitude,
      'longitude': longitude,
    });
  }

  void _saveToFirebase(latitude, longitude) {
    // เชื่อมต่อกับคอลเล็กชัน "reviews" ใน Firebase
    final IdCompany = widget.idCompany.toString();
    final CollectionReference reviewsRef = FirebaseFirestore.instance
        .collection('SaleTicketPoint/$IdCompany/SalePoint');

    reviewsRef.doc().set({
      'name': name.text,
      'address': address.text,
      'contact': contact.text,
      'officeHours': officeHours.text,
      'latitude': latitude,
      'longitude': longitude,
    });
  }

  void _updateToFirebase(latitude, longitude) {
    // เชื่อมต่อกับคอลเล็กชัน "reviews" ใน Firebase
    final IdCompany = widget.idCompany.toString();
    final CollectionReference reviewsRef = FirebaseFirestore.instance
        .collection('SaleTicketPoint/$IdCompany/SalePoint');

    reviewsRef.doc(widget.busStation?.id).update({
      'name': name.text,
      'address': address.text,
      'contact': contact.text,
      'officeHours': officeHours.text,
      'latitude': latitude,
      'longitude': longitude,
    });
  }

  Center buttom(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 75.0),
        child: SizedBox(
          width: 200,
          height: 50,
          child: ElevatedButton(
            onPressed: () async {
              try {
                double latitude = double.parse(latitudeController.text);
                double longitude = double.parse(longitudeController.text);

                if (formKey.currentState!.validate()) {
                  if (isEditingMode == true) {
                    _updateToFirebase(latitude, longitude);
                  } else {
                    _saveToFirebase(latitude, longitude);
                    saveToLocations(latitude, longitude);
                  }

                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                  Fluttertoast.showToast(msg: "เพิ่มจุดให้บริการสำเร็จ");
                } else {
                  Fluttertoast.showToast(
                    msg: "เพิ่มจุดให้บริการไม่สำเร็จ",
                    backgroundColor: Colors.red,
                  );
                }
              } catch (e) {
                // Handle the error when parsing fails (e.g., invalid double)
                Fluttertoast.showToast(
                  msg: "กรุณาใส่ข้อมูลให้ครบ",
                  backgroundColor: Colors.red,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[300],
              elevation: 3,
            ),
            child: isEditingMode == true
                ? Text("บันทึก", style: Textstyle().buttomTextWhite)
                : Text("เพิ่มจุดให้บริการ", style: Textstyle().buttomTextWhite),
          ),
        ),
      ),
    );
  }

  TextFormField nameAddress() {
    return TextFormField(
      style: const TextStyle(fontSize: 16, color: Colors.black),
      keyboardType: TextInputType.text,
      controller: name,
      decoration: InputDecoration(
        labelText: 'ชื่อสถานที่',
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color.fromARGB(255, 0, 65, 117)),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'กรุณากรอกชื่อสถานที่';
        }
        return null;
      },
    );
  }

  Container addressSaleTicket() {
    return Container(
      margin: const EdgeInsets.only(top: 1),
      height: 150,
      child: TextFormField(
        style: const TextStyle(fontSize: 16, color: Colors.black),
        controller: address,
        maxLines: 100,
        decoration: InputDecoration(
          labelText: 'ที่อยู่',
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: Color.fromARGB(255, 0, 65, 117)),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'กรุณากรอกที่อยู่';
          }
          return null;
        },
      ),
    );
  }

  TextFormField contactNumber() {
    return TextFormField(
      style: const TextStyle(fontSize: 16, color: Colors.black),
      keyboardType: TextInputType.text,
      controller: contact,
      decoration: InputDecoration(
        labelText: 'เบอร์โทรติดต่อ',
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color.fromARGB(255, 0, 65, 117)),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'กรุณากรอกเบอร์โทรติดต่อ';
        }
        return null;
      },
    );
  }

  TextFormField officeHoursTime() {
    return TextFormField(
      style: const TextStyle(fontSize: 16, color: Colors.black),
      keyboardType: TextInputType.text,
      controller: officeHours,
      decoration: InputDecoration(
        labelText: 'เวลาทำการ',
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color.fromARGB(255, 0, 65, 117)),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'กรุณากรอกเวลาทำการ';
        }
        return null;
      },
    );
  }
}
