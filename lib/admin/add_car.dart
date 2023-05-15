// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:runnn/admin/car.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AddCar extends StatefulWidget {
  const AddCar({Key? key}) : super(key: key);

  @override
  State<AddCar> createState() => _AddCarState();
}

class _AddCarState extends State<AddCar> {
  final _nametourController = TextEditingController();
  final _keywordController = TextEditingController();
  final _originController = TextEditingController();
  final _destinationController = TextEditingController();
  final _priceController = TextEditingController();
  final _departuretimeController = TextEditingController();
  final _timetoarriveController = TextEditingController();
  final _pickupController = TextEditingController();
  final _dropoffController = TextEditingController();
  final _typeofcarController = TextEditingController();
  List<String> typecar = ["ป.1", "วีไอพี24", "วีไอพี32"];

  final _formKey = GlobalKey<FormState>();

  Future addCar() async {
    await FirebaseFirestore.instance
        .collection('list')
        .add({
          'NameTour': _nametourController.text,
          'Origin': _originController.text,
          'Destination': _destinationController.text,
          'Keyword': _keywordController.text,
          'Price': _priceController.text,
          'DepartureTime': _departuretimeController.text,
          'TimetoArrive': _timetoarriveController.text,
          'PickUp': _pickupController.text,
          'DropOff': _dropoffController.text,
          'TypeofCar': _typeofcarController.text,
          'imageUrl': imageUrl,
        })
        .then((value) => {})
        .catchError((error) => print("Failed to add user: $error"));
  }

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  File? _photo;
  final ImagePicker _picker = ImagePicker();
  String imageUrl = '';

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
      } else {
        Fluttertoast.showToast(msg: "ไม่ได้เลือกรูปภาพ");
      }
    });
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
      } else {
        Fluttertoast.showToast(msg: "ไม่ได้เลือกรูปภาพ");
      }
    });
  }

  Future uploadFile() async {
    if (_photo == null) return;
    final fileName = basename(_photo!.path);
    final destination = 'files/$fileName';

    try {
      final ref =
          firebase_storage.FirebaseStorage.instance.ref().child(destination);

      await ref.putFile(_photo!);
      imageUrl = await ref.getDownloadURL();
      addCar();
    } catch (e) {
      print('error occured');
    }

    print(imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เพิ่มเที่ยวรถทัวร์'),
        backgroundColor: Colors.blueAccent[500],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.h),
                  const Text(
                    'อัพโหลดรูปภาพรถ',
                    style: TextStyle(fontSize: 16),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => imgFromCamera(),
                        icon: const Icon(
                          Icons.add_a_photo,
                          size: 36,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        width: 200,
                        height: 180,
                        child: _photo == null
                            ? const Icon(
                                Icons.photo,
                                size: 150,
                              )
                            : Image.file(
                                _photo!,
                              ),
                      ),
                      IconButton(
                        onPressed: () => imgFromGallery(),
                        icon: const Icon(
                          Icons.add_photo_alternate,
                          size: 36,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10.h),
                  NameConpany(),
                  SizedBox(height: 20.h),
                  Origin(),
                  SizedBox(height: 20.h),
                  Destination(),
                  SizedBox(height: 20.h),
                  Keyword(),
                  SizedBox(height: 20.h),
                  Price(),
                  SizedBox(height: 20.h),
                  Departuretime(),
                  SizedBox(height: 20.h),
                  TimeToArrive(),
                  SizedBox(height: 20.h),
                  Pickup(),
                  SizedBox(height: 20.h),
                  DropOff(),
                  SizedBox(height: 20.h),
                  TextFormField(
                    controller: _typeofcarController,
                    decoration: InputDecoration(
                      labelText: 'ประเภทรถ',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 0, 65, 117)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณาเลือกประเภทรถ';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.h),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 75.0),
                    child: SizedBox(
                      width: 1.sw,
                      height: 56.h,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            uploadFile();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CarAdmin(),
                              ),
                            );
                            Fluttertoast.showToast(msg: "เพิ่มเที่ยวรถสำเร็จ");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[300],
                          elevation: 3,
                        ),
                        child: Text(
                          "เพิ่มเที่ยวรถ",
                          style:
                              TextStyle(color: Colors.white, fontSize: 18.sp),
                        ),
                      ),
                    ),
                  ),

                  ////////////////////
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField DropOff() {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: _dropoffController,
      decoration: InputDecoration(
        labelText: 'จุดลงรถ',
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color.fromARGB(255, 0, 65, 117)),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'กรุณาใส่จุดลงรถ';
        }
        return null;
      },
    );
  }

  TextFormField Pickup() {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: _pickupController,
      decoration: InputDecoration(
        labelText: 'จุดขึ้นรถ',
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color.fromARGB(255, 0, 65, 117)),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'กรุณาใส่จุดขึ้นรถ';
        }
        return null;
      },
    );
  }

  TextFormField TimeToArrive() {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: _timetoarriveController,
      decoration: InputDecoration(
        labelText: 'เวลารถถึง',
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color.fromARGB(255, 0, 65, 117)),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'กรุณาใส่เวลารถถึง';
        }
        return null;
      },
    );
  }

  TextFormField Departuretime() {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: _departuretimeController,
      decoration: InputDecoration(
        labelText: 'เวลารถออก',
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color.fromARGB(255, 0, 65, 117)),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'กรุณาใส่เวลาออกรถ';
        }
        return null;
      },
    );
  }

  TextFormField Price() {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: _priceController,
      decoration: InputDecoration(
        labelText: 'ราคา',
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color.fromARGB(255, 0, 65, 117)),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'กรุณาใส่ราคา';
        }
        return null;
      },
    );
  }

  TextFormField Keyword() {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: _keywordController,
      decoration: InputDecoration(
        labelText: 'คีย์เวิร์ด',
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color.fromARGB(255, 0, 65, 117)),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'กรุณาใส่คีย์เวิร์ด';
        }
        return null;
      },
    );
  }

  TextFormField Destination() {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: _destinationController,
      decoration: InputDecoration(
        labelText: 'จังหวัดปลายทาง',
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color.fromARGB(255, 0, 65, 117)),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'กรุณาใส่จังหวัดปลายทาง';
        }
        return null;
      },
    );
  }

  TextFormField Origin() {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: _originController,
      decoration: InputDecoration(
        labelText: 'จังหวัดต้นทาง',
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color.fromARGB(255, 0, 65, 117)),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'กรุณาใส่จังหวัดต้นทาง';
        }
        return null;
      },
    );
  }

  TextFormField NameConpany() {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: _nametourController,
      decoration: InputDecoration(
        labelText: 'ชื่อบริษัททัวร์',
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color.fromARGB(255, 0, 65, 117)),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'กรุณาใส่ชื่อบริษัททัวร์';
        }
        return null;
      },
    );
  }
}
