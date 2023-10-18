import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:runnn/admin/Controller/controller.dart';
import 'package:runnn/admin/model/model.dart';
import 'package:runnn/const/appcolors.dart';

class AddEditMap extends StatefulWidget {
  final index;
  final mapLocation_model? map;
  const AddEditMap({super.key, this.index, this.map});

  @override
  State<AddEditMap> createState() => _AddEditMapState();
}

class _AddEditMapState extends State<AddEditMap> {
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();
  final id = TextEditingController();
  final name = TextEditingController();
  final address = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isEditingMode = false;
  @override
  void initState() {
    if (widget.index != null) {
      isEditingMode = true;
      double numberLatitude = widget.map?.latitude;
      double numberLongitude = widget.map?.longitude;
      id.text = widget.map?.id;
      latitudeController.text = numberLatitude.toString();
      longitudeController.text = numberLongitude.toString();
      name.text = widget.map?.name;
      address.text = widget.map?.address;
    } else {
      isEditingMode = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isEditingMode == true
            ? const Text('แก้ไขข้อมูล')
            : const Text('เพิ่มข้อมูล'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Center(
            child: SizedBox(
              width: 1120,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Name(),
                  const SizedBox(height: 10),
                  Address(),
                  const SizedBox(height: 10),
                  liti(),
                  const SizedBox(height: 10),
                  long(),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 75.0),
                    child: SizedBox(
                      width: 200,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          double latitude =
                              double.parse(latitudeController.text);
                          double longitude =
                              double.parse(longitudeController.text);
                          // Now you have the latitude and longitude as double values.
                          if (_formKey.currentState!.validate()) {
                            if (isEditingMode == true) {
                              map_controller().update_map(mapLocation_model(
                                id: id.text,
                                latitude: latitude,
                                longitude: longitude,
                                name: name.text,
                                address: address.text,
                              ));
                            } else {
                              map_controller().add_map(
                                mapLocation_model(
                                  latitude: latitude,
                                  longitude: longitude,
                                  name: name.text,
                                  address: address.text,
                                ),
                              );
                            }

                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                            Fluttertoast.showToast(msg: "เพิ่มข้อมูลสำเร็จ");
                          } else {
                            Fluttertoast.showToast(msg: "เพิ่มข้อมูลไม่สำเร็จ");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[300],
                          elevation: 3,
                        ),
                        child: isEditingMode == true
                            ? Text(
                                "บันทึกข้อมูล",
                                style: Textstyle().buttomTextWhite,
                              )
                            : Text(
                                "เพิ่มข้อมูล",
                                style: Textstyle().buttomTextWhite,
                              ),
                      ),
                    ),
                  ),
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

  TextFormField Name() {
    return TextFormField(
      style: const TextStyle(fontSize: 16, color: Colors.black),
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
          return 'กรุณาใส่รายละเอียด';
        }
        return null;
      },
    );
  }

  TextFormField Address() {
    return TextFormField(
      style: const TextStyle(fontSize: 16, color: Colors.black),
      controller: address,
      decoration: InputDecoration(
        labelText: 'ที่อยู่',
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
}
